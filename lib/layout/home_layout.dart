import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archivedtasks/archived_tasks_screen.dart';
import 'package:todoapp/modules/donetasks/done_tasks_screen.dart';
import 'package:todoapp/modules/newtasks/new_tasks_screen.dart';
import 'package:todoapp/shared/components/constants.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
class HomeLayout extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AppCubit()
        ..CreateDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(

        listener: (context, state) {
          if(state is AppInsertDatebaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            // tasks.length == 0
            //                 ? Center(child: CircularProgressIndicator())
          //   body: ConditionalBuilder(
          //   condition:  state is! AppGetDatebaseLoadingState,
          //   builder: (context) => cubit.screens[cubit.currentindex],
          //   fallback: (context) => Center(child: CircularProgressIndicator()),
          // ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatebaseLoadingState,
                builder: (context) => cubit.screens[cubit.currentindex],
              fallback: (BuildContext context) =>Center(child: CircularProgressIndicator()),
            ),
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentindex]),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabIcon),
                onPressed: () {
                  if (cubit.isBottomSheetShown)
                  {
                    if (formkey.currentState!.validate())
                    {
                      cubit.insertToDatabase(
                        title: titlecontroller.text,
                        time: timecontroller.text,
                        date: datecontroller.text,
                      );
                    }
                  }else{
                    scaffoldKey.currentState?.showBottomSheet
                      (
                            (context) =>Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0,),
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children:
                              [
                                TextFormField(
                                  controller: titlecontroller,
                                  keyboardType: TextInputType.text,
                                  validator: (value) =>
                                  value!.isEmpty
                                      ? 'Title must not be empty'
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: 'Title',
                                    prefixIcon: Icon(
                                      Icons.title,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: timecontroller,
                                  keyboardType: TextInputType.datetime,
                                  validator: (value) =>
                                  value!.isEmpty
                                      ? 'Time must not be empty'
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: 'Time',
                                    prefixIcon: Icon(
                                      Icons.title,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timecontroller.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: datecontroller,
                                  keyboardType: TextInputType.datetime,
                                  validator: (value) =>
                                  value!.isEmpty
                                      ? 'Date must not be empty'
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: 'Date',
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-05-05'),
                                    ).then((value) {
                                      datecontroller.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0
                    ).closed.then((value)
                    {
                      cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                    });
                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                }),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentindex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: 'Archived'),
                ]),

          );
        },
      ),
    );
  }

//   Future<String> getName() async{
//     return "Ahmed Ali";
//   }
// }


}
