import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:statenotifier_flux/behavior/todo_behavior.dart';
import 'package:statenotifier_flux/stores/todo_store.dart';

class AddTodoDialog extends ConsumerWidget {
  const AddTodoDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosBehavior = TodosBehavior.fromRef(ref);

    String? value;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            TextField(onChanged: (it) => value = it),
            ElevatedButton(
              onPressed: () {
                final v = value;
                if (v == null) {
                  return;
                }
                todosBehavior.add(Todo(id: v, description: v));
              },
              child: Text('todoを登録'),
            )
          ],
        ),
      ),
    );
  }
}
