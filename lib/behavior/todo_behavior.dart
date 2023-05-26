import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:statenotifier_flux/main.dart';
import 'package:statenotifier_flux/stores/todo_store.dart';

/// [Behavior] -> [Store]への単一フローのためメソッドの戻り値は[void]となる
class TodosBehavior with Behavior {
  @override
  final List<StateNotifier<List<ImmutableState>>> states;

  TodosBehavior({
    required TodosStore todosStore,
  }) : states = [todosStore];

  factory TodosBehavior.fromRef(WidgetRef r) => TodosBehavior(
        todosStore: r.read(todoStoreProvider.notifier),
      );

  void initialize(Todo todo) {
    print('initialize');
    effect((TodoState prev) => prev.copyWith(todos: Todos({todo.id: todo})));
  }

  void add(Todo todo) {
    print('add');
    effect((TodoState prev) => prev.copyWith(todos: prev.todos.add(todo)));
  }

  void toggleCompleted(String todoId) {
    print('toggleCompleted');
    effect(
      (TodoState prev) {
        final targetTodo = prev.todos.findById(todoId);
        if (targetTodo == null) {
          return prev;
        }
        if (targetTodo.completed) {
          return prev.copyWith(todos: prev.todos.update(targetTodo.updateTodoStatus(false)));
        } else {
          return prev.copyWith(todos: prev.todos.update(targetTodo.updateTodoStatus(true)));
        }
      },
    );
  }

  // void toggle() => effect((Todo prev) {
  //       if (prev.completed) {
  //         return prev.copyWith(completed: false);
  //       } else {
  //         return prev.copyWith(completed: true);
  //       }
  //     });
}

mixin Behavior {
  List<StateNotifier<List<ImmutableState>>> get states;

  void effect<T extends ImmutableState, MT extends StateFlow<T>>(
    T Function(T prev) updator,
  ) {
    states.whereType<MT>().forEach((s) {
      // ignore: invalid_use_of_protected_member
      final newValue = updator(s.state.first);

      print('toggle: ${s.state.first} to $newValue');

      /// [StateNotifier]が前後比較してくれる
      s.update(newValue);
    });
  }
}
