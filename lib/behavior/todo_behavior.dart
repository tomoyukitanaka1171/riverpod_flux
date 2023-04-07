import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:statenotifier_flux/stores/todo_store.dart';

/// [Behavior] -> [Store]への単一フローのためメソッドの戻り値は[void]となる
class TodosBehavior with Behavior {
  @override
  final List<StateFlow<ImmutableState>> states;

  TodosBehavior({
    required TodosStore todosStore,
  }) : states = [todosStore];

  factory TodosBehavior.fromRef(WidgetRef r) => TodosBehavior(
        todosStore: r.read(todosProvider.notifier),
      );

  /// うまくいかない
  void addTodo(String desc) => effect((Todo prev) => prev.copyWith(description: desc));
}

mixin Behavior {
  List<StateFlow<ImmutableState>> get states;

  void effect<T extends ImmutableState, MT extends StateFlow<T>>(T Function(T prev) updator) {
    states.whereType<MT>().forEach((s) {
      final prev = s.value;
      final newValue = updator(s.value);

      /// [StateNotifier]が前後比較してくれる
      // ignore: invalid_use_of_protected_member
      s.update(updator);
    });
  }
}

abstract class ImmutableState {
  const ImmutableState();
}
