import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/states.dart';
import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  bool isBottomSheetShown = false;
  int currentIndex = 0;
  Database? database;
  List<Map> tasks = [];
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen()
  ];
  List<String> titles = [
    "Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBar());
  }

  Future<void> insertInDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES (?, ?, ?, ?)',
          [title, date, time, 0]).then((value) {
        emit(AppInsertDatabase());
        getFromDatabase(database,0);
        emit(AppGetDatabase());
      });
    });
  }

void getFromDatabase(database,status){
    emit(AppGetDatabaseLoading());
     database!.rawQuery('SELECT * FROM tasks Where status=$status').then((value){
       tasks=value;
       emit(AppGetDatabase());
     });
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT, date TEXT,time  TEXT,status INTEGER)');
    }, onOpen: (database) {
      getFromDatabase(database,0);
      emit(AppGetDatabase());
    }).then((value) {
      database = value;
      emit(AppCreateDatabase());
    });
  }

  void changeBottomSheet({required bool isShowed}) {
    isBottomSheetShown = isShowed;
    emit(AppChangeBottomSheet());
  }

  void updateData({required int id, required int state}) async {
    /*
    (0)->New
    (1)->Done
    (-1)->Archived
    */
 database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        [state, id]).then((value){
          emit(AppUpdateDatabase());
          getFromDatabase(database, currentIndex);
 });
  }
  void deleteData({required int id }) async {
 database!.rawDelete('DELETE FROM tasks WHERE id=?',
        [id]).then((value){
          emit(AppDeleteDatabase());
          getFromDatabase(database, currentIndex);
 });
  }
}
