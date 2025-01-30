import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget buildTaskItem(context,
        {required int id,
        required String title,
        required String time,
        required String date}) =>
    Dismissible(
      key: Key('$id'),
      onDismissed: (direction){
        AppCubit.get(context).deleteData(id: id);
      },
      child: Container(
        margin: const EdgeInsetsDirectional.all(10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.pink[50],
              child: Text(time),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(id: id, state: 1);
              },
              icon: const Icon(Icons.done),
              color: Colors.pink,
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(id: id, state: 2);
              },
              icon: const Icon(Icons.archive_outlined),
              color: Colors.pink,
            ),
          ],
        ),
      ),
    );
