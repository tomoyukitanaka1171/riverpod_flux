import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:statenotifier_flux/behavior/todo_behavior.dart';

part 'todo_store.freezed.dart';

/// 実質的なシングルトンとして扱える
final todosProvider = StateNotifierProvider<TodosStore, List<Todo>>((ref) {
  return TodosStore();
});

typedef Store<T> = StateNotifier<List<T>>;

@freezed
class Todo with _$Todo implements ImmutableState {
  const factory Todo({
    @Default('') String id,
    @Default('') String description,
    @Default(false) bool completed,
  }) = _Todo;

  const Todo._();
}

abstract class StateFlow<T extends List<ImmutableState>> extends StateNotifier<T> {
  StateFlow() : super(<ImmutableState>[]);
  
  T get value => state;

  void update(T Function(T prev) updator) {
    final newValue = updator(state);
  };
}

class TodosStore extends StateFlow<Todo> {
  TodosStore();
}
