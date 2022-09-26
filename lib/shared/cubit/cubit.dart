import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archivedtasks/archived_tasks_screen.dart';
import 'package:todoapp/modules/donetasks/done_tasks_screen.dart';
import 'package:todoapp/modules/newtasks/new_tasks_screen.dart';
import 'package:todoapp/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentindex = 0;
  List<Widget> screens = [
    new_tasks_screen(),
    done_tasks_screen(),
    archived_tasks_screen()
  ];
  List<String> titles = ["New Tasks", "Done Tasks", "Archived Tasks"];
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  void changeIndex(int index) {
    currentindex = index;
    emit(AppChangeBottomNavBarState());
  }

  void CreateDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print("database creatred");
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT )')
          .then((value) {
        print("Table created");
      }).catchError((error) {
        print(error);
      });
    }, onOpen: (database) {
      GetDataFromDataBase(database);
      print("database opened");
    }).then((value) {
      database = value;
      emit(AppCreateDatebaseState());
    });
  }

   insertToDatabase(
      {required String title, required String time, required String date}) async {
      await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        GetDataFromDataBase(database);
        print("$value inserted successfully");
        emit(AppInsertDatebaseState());

        GetDataFromDataBase(database);
      }).catchError((error) {
        print(error.toString());
      });
    });
  }

  void GetDataFromDataBase(database)  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatebaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element) {
        if(element['status'] == 'new'){
                      newTasks.add(element);
        }
        else if (element['status'] == 'done'){
          doneTasks.add(element);
        }
        else{
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatebaseState());
    });;
  }

  void updateData ({
    required String status,
    required int id,

})
  {
        database.rawUpdate(
          'UPDATE tasks SET status=? WHERE id=?',
          ['$status' , id ],
        ).then((value) {
          GetDataFromDataBase(database);
          emit(AppUpdateDatebaseState());
        });

  }
  void deleteData ({
    required int id,

  })
  {
    database.rawDelete(
      'DELETE FROM tasks WHERE id=?',
      [ id ],
    ).then((value) {
      GetDataFromDataBase(database);
      emit(AppdELETEDatebaseState());
    });

  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppchangeBottomSheetState());
  }
}
