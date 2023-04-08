import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'todo_store.freezed.dart';

typedef Store<T> = StateNotifier<List<T>>;

@freezed
class Todo with _$Todo {
  const factory Todo({
    @Default('') String id,
    @Default('') String description,
    @Default(false) bool completed,
  }) = _Todo;

  const Todo._();
}

@freezed
class TodoState with _$TodoState implements ImmutableState {
  const factory TodoState({
    @Default([]) List<Todo> todos,
  }) = _TodoState;

  const TodoState._();
}

abstract class ImmutableState {
  const ImmutableState();
}

abstract class StateFlow<T extends ImmutableState> extends StateNotifier<List<T>> {
  StateFlow(this.initState) : super([initState]);

  @override
  List<T> get state;

  T initState;

  void update(T newState) {
    state = [newState];
  }
}

class TodosStore extends StateFlow<TodoState> {
  TodosStore() : super(const TodoState(todos: [Todo()]));
}
