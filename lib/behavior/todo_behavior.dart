import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:statenotifier_flux/stores/todo_store.dart';

/// [Behavior] -> [Store]への単一フローのためメソッドの戻り値は[void]となる
class TodosBehavior with Behavior {
  @override
  final List<StateNotifier<List<ImmutableState>>> states;

  TodosBehavior({
    required TodosStore todosStore,
  }) : states = [todosStore];

  factory TodosBehavior.fromRef(WidgetRef r) => TodosBehavior(
        todosStore: r.read(todosProvider.notifier),
      );

  /// うまくいかない
  // void addTodo(Todo todo) {
  //   effect((TodosStore prev) => prev.addTodo());
  // }
}

mixin Behavior {
  List<StateNotifier<List<ImmutableState>>> get states;

  void effect<T extends ImmutableState, MT extends StateNotifier<List<T>>>(List<T> Function(MT target) curr) {
    states.whereType<MT>().forEach((s) {
      /// [StateNotifier]が前後比較してくれる
      // ignore: invalid_use_of_protected_member
      s.state = curr(s);
    });
  }
}

abstract class ImmutableState {
  const ImmutableState();
}

abstract class StateFlow<T extends ImmutableState> extends StateNotifier<List<T>> {
  StateFlow() : super([]);

  T get value;
  set value(T value);
}
