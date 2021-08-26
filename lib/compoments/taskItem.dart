import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubit.dart';

class buildTaskItem extends StatelessWidget {
  const buildTaskItem({required this.model , required this.disKey});
  
  final Map model;
  final String disKey;

  @override
  Widget build(BuildContext context) {
    return Dismissible(key: Key(disKey),
        child: Padding(padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(radius: 35.0,
                child: Text('${model['time']}'),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${model['title']}' , style: TextStyle(fontSize:18.0 ,fontWeight: FontWeight.bold),),
                  Text('${model['date']}' , style: TextStyle(color: Colors.grey),),
                ],
              )),
              SizedBox(
                width: 20.0,
              ),
              IconButton(icon: Icon(Icons.check_box , color: Colors.green,), onPressed:(){
                TodoCubit.get(context).updateData(status: 'done', id: model['id']);
              }),
              SizedBox(
                width: 20.0,
              ),
              IconButton(icon: Icon(Icons.archive , color: Colors.black45,), onPressed:(){
                TodoCubit.get(context).updateData(status: 'Archived', id: model['id']);
              }),
            ],
          ),
        ),
      onDismissed: (dir){
      TodoCubit.get(context).deleteData(id: model['id']);
      },
    );
  }
}
