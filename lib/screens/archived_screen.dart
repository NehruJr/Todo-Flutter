import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/compoments/custom_listview.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit , AppStates>
      (listener: (context, state) {},
      builder: (context, state) => CustomListView(map: TodoCubit.get(context).archivedTasks,),);
  }
}
