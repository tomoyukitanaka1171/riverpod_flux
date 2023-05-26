import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:statenotifier_flux/behavior/todo_behavior.dart';
import 'package:statenotifier_flux/screens/todos/add_todo/add_todo_dialog.dart';
import 'package:statenotifier_flux/stores/todo_store.dart';

/// 実質的なシングルトンとして扱える
final todoStoreProvider = StateNotifierProvider<TodosStore, List<TodoState>>((ref) {
  return TodosStore();
});
final helloWorldProvider = StateProvider((ref) => 'hello');

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePageConsumerState extends ConsumerState<MyHomePage> {
  late TodosBehavior todosBehavior;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      todosBehavior = TodosBehavior.fromRef(ref);
      todosBehavior.initialize(const Todo(id: 'hoge', description: 'desc'));
      print('initState');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todoStoreProvider).first.todos;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todoState.value.keys.length,
                itemBuilder: (_, index) {
                  final key = todoState.value.entries.elementAt(index).key;
                  final t = todoState.value[key];
                  if (t == null) {
                    return Container();
                  }
                  final completed = t.completed;
                  return CheckboxListTile(
                    onChanged: (_) => todosBehavior.toggleCompleted(t.id),
                    title: Text(t.description),
                    value: completed,
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const AddTodoDialog())),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyHomePage extends StatefulHookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MyHomePageConsumerState();
}
