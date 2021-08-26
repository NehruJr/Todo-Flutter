import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import '../compoments/custom_listview.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit , AppStates>
      (listener: (context, state) {},
    builder: (context, state) => CustomListView(map: TodoCubit.get(context).newTasks,),);
  }
}
