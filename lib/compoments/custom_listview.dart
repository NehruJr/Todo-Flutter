import 'package:flutter/material.dart';
import 'package:todo_app/compoments/taskItem.dart';


class CustomListView extends StatelessWidget {
  const CustomListView({required this.map});
  final List<Map> map;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return buildTaskItem(
              model: map[index],
              disKey: map[index]['id'].toString());
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          );
        },
        itemCount: map.length);
  }
}
