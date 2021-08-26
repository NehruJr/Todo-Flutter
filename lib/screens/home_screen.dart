import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';

class HomeScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit, AppStates>(
        listener: (context, state) {
          if (state is AppOnInsertIntoDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.get(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: TodoCubit.get(context).isDark ? ThemeData.dark() : ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  title: Text(cubit.titles[cubit.currentIndex]),
                  actions: [
                    IconButton(onPressed: (){cubit.changeAppTheme();},
                        icon: Icon(Icons.wb_sunny))
                  ],
                ),
                body: cubit.screens[cubit.currentIndex],
                floatingActionButton: FloatingActionButton(
                  child: Icon(cubit.fabIcon),
                  onPressed: () {
                    if (cubit.isBottomSheetShown) {
                      if(_formKey.currentState!.validate()){
                        cubit.insertToDatabase(title: titleController.text,
                            date: dateController.text,
                            time: timeController.text);
                      }
                    } else {
                      scaffoldKey.currentState!.showBottomSheet((context) => Form(
                          key: _formKey,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    labelText: 'Task Title',
                                    prefixIcon: Icon(Icons.title),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  controller: dateController,
                                  keyboardType: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2021-12-31'),
                                    ).then((value) => dateController.text =
                                        DateFormat.yMMMd().format(value!));
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Pick Date',
                                    prefixIcon: Icon(Icons.date_range),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please pick date';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  controller: timeController,
                                  keyboardType: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) => timeController.text =
                                            value!.format(context).toString());
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Pick Time',
                                    prefixIcon: Icon(Icons.watch_later_outlined),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please choose time';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                      ),
                      ).closed.then((value) {
                        cubit.changeBottomSheetState(isShown: false, icon: Icons.edit);
                      });
                      cubit.changeBottomSheetState(isShown: true, icon: Icons.add);
                    }
                  },
                  elevation: 20,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: cubit.currentIndex,
                  onTap: (index) {
                    cubit.changeIndex(index);
                  },
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                    BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.archive), label: 'Archived'),
                  ],
                ),
              ),
          );
        },
      ),
    );
  }
}
