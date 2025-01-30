import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';


class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit,AppStates>(
      builder: (BuildContext context, AppStates state) {
        return AppCubit.get(context).tasks.isNotEmpty? ListView.separated(
          itemBuilder: (BuildContext context, int index) => buildTaskItem(
            context,
              title: cubit.tasks[index]['title'],
              time: cubit.tasks[index]['time'],
              date: cubit.tasks[index]['date'],
              id: cubit.tasks[index]['id']),
          separatorBuilder: (BuildContext context, int index) => Container(
            margin: const EdgeInsetsDirectional.symmetric(horizontal: 15),
            color: Colors.pink[100],
            width: double.infinity,
            height: 2,
          ),
          itemCount: cubit.tasks.length,
        )
            :const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  Icons.hourglass_empty,
                  color: Colors.pink,
                  size:45
              ),
          Text(
            'No taskes yet...',
            style: TextStyle(
              fontWeight: FontWeight.w700,
                  color: Colors.grey,
              fontSize:25,
            ),
          )
                  ],
                  ),
        );
      },
      listener: (BuildContext context, AppStates state) {  },

    );
  }
}
