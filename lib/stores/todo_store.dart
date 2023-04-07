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

  void update({required String targetId, required String description, bool completed = false}) => copyWith(
        description: description,
        completed: completed,
      );
}

class TodosStore extends StateNotifier<List<Todo>> {
  TodosStore() : super([]);

  void initialize() => state = [];

  void addTodo(String todoId) {
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  // void toggle(String todoId) {
  //   state = [
  //     for (final todo in state)
  //       if (todo.id == todoId) todo.copyWith(completed: !todo.completed) else todo,
  //   ];
  // }
}
