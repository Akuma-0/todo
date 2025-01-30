import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabase) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.pink,
              leading: cubit.isBottomSheetShown
                  ? IconButton(
                      onPressed: () {
                        cubit.changeBottomSheet(isShowed: false);
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ))
                  : null,
              title: Center(
                child: Text(
                  cubit.titles[cubit.currentIndex],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.changeBottomSheet(isShowed: false);
                    cubit.insertInDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  cubit.changeBottomSheet(isShowed: true);
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Container(
                            color: Colors.pink[50],
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: titleController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Title can't be empty";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Title",
                                        prefixIcon: Icon(Icons.title),
                                        prefixIconColor: Colors.pink,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: timeController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Time can't be empty";
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text =
                                              value!.format(context);
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Time",
                                        prefixIcon:
                                            Icon(Icons.watch_later_outlined),
                                        prefixIconColor: Colors.pink,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: dateController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Date can't be empty";
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    "2025-01-01"))
                                            .then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value!);
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Date",
                                        prefixIcon: Icon(Icons.date_range),
                                        prefixIconColor: Colors.pink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(isShowed: false);
                  });
                }
              },
              backgroundColor: Colors.pink,
              child: cubit.isBottomSheetShown
                  ? const Icon(
                      Icons.save,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              selectedItemColor: Colors.pink,
              onTap: (index) {
                cubit.getFromDatabase(cubit.database, index);
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.done_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: "Archive"),
              ],
            ),
            body: state is! AppGetDatabaseLoading
                ? cubit.screens[cubit.currentIndex]
                : const Center(
                    child: CircularProgressIndicator(
                    color: Colors.pink,
                  )),
          );
        },
      ),
    );
  }
}
