import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/screens/archived_screen.dart';
import 'package:todo_app/screens/done_screen.dart';
import 'package:todo_app/screens/newTasks_screen.dart';

class TodoCubit extends Cubit<AppStates>{
  TodoCubit() : super(AppInitialState());


  static TodoCubit get(context)=> BlocProvider.of(context);

  int currentIndex = 0 ;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeIndex(int index){
    currentIndex = index;
   emit(OnChangeBottomNavState());
  }

  late Database database;

  void createDatabase () async{
    openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
          print("database Created");
          database
              .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT)')
              .then((value) => print("Table Created"));
        }, onOpen: (database) {
          print("database Opended");
          getDataFromDatabase(database);
        }).then((value) {
      database = value;
      emit(AppOnCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) =>
        txn.rawInsert(
            'INSERT INTO tasks(title,date,time , status) VALUES("$title" , "$date" , "$time" , "new")')
            .then((value) {
          print("$value inserted Successfully");
          emit(AppOnInsertIntoDatabaseState());
          getDataFromDatabase(database);
        }));
// await database.rawInsert('INSERT INTO tasks(title,data,time , status) VALUES("first title" , "237" , "12" , "new")').then((value) => [print("$value inserted Successfully")]);
  }

  void getDataFromDatabase (database) async{
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('Select * From tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else
          archivedTasks.add(element);
      });

      emit(AppOnGetDatabaseState());
    }
    );
  }

  void updateData({required String status, required int id}) async {
    await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppOnUpdateDatabaseState());
    });
  }

  void deleteData({required int id}) async {
    await database.rawUpdate(
        'Delete From tasks WHERE id = ?',
        [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppOnDeleteFromDatabaseState());
    });
  }

  late bool isBottomSheetShown = false;
  late IconData fabIcon = Icons.edit;
  void changeBottomSheetState(
      {required bool isShown, required IconData icon}) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppOnChangeBottomSheetState());
  }

  bool isDark = false;
  void changeAppTheme (){
    isDark =!isDark;
    emit(AppChangeThemeState());
  }
}