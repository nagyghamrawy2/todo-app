import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/cubit.dart';

class buildTaskItem extends StatelessWidget {
    buildTaskItem({this.model , required this.context});
  Map? model ;
    BuildContext context;
  @override
  Widget build(BuildContext x) {
    return Dismissible(
      key: Key("${model! ['id']}"),
      onDismissed: (direction){
                AppCubit.get(context).deleteData(id: model!['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                  '${model!['time']}'
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
              '${model!['title']}',
                    style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),
                  ),
                  Text(
                      '${model!['date']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
              icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
              ),
              onPressed: () {
                      AppCubit.get(context).updateData(status: 'done', id: model!['id']);
              },

            ),
            IconButton(
              icon: Icon(
                  Icons.archive,
                  color: Colors.black45,
              ),
              onPressed: () {
                AppCubit.get(context).updateData(status: 'archive', id: model!['id']);
              },

            ),
          ],
        ),
      ),
    );
  }
}

class TasksBuilder extends StatelessWidget {
  TasksBuilder({required this.tasks});
  List<Map>? tasks;

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: tasks!.length > 0,
      builder: (context) => ListView.separated(
          itemBuilder: (context , index) => buildTaskItem(model: tasks![index], context: context,),
          separatorBuilder: (context , index) => Padding(
            padding: const EdgeInsetsDirectional.only(start: 20.0),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          itemCount: tasks!.length
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              "No Tasks Yet Please Add Some Tasks",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
              ),
            )
          ],
        ),
      ),

    );
  }
}

