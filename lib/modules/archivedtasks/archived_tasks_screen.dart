import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/components/component.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class archived_tasks_screen extends StatelessWidget {
  const archived_tasks_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<AppCubit , AppStates>(
        listener: (context ,state){},
        builder: (context , state){
          var tasks = AppCubit.get(context).archivedTasks;
          return TasksBuilder(tasks: tasks,);
        },
      );
  }
}
