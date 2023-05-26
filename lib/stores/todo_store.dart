import 'package:equatable/equatable.dart';
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

  Todo updateTodoStatus(bool done) => copyWith(completed: done);
}

class Todos extends Equatable {
  final Map<String, Todo> value;
  const Todos(this.value);

  @override
  List<Object?> get props => [value];

  Todo? findById(String id) => value[id];

  Todos add(Todo todo) => Todos({...value, todo.id: todo});

  Todos update(Todo todo) {
    final n = value;
    n[todo.id] = todo;
    return Todos(n);
  }
}

@freezed
class TodoState with _$TodoState implements ImmutableState {
  const factory TodoState({
    @Default(Todos({})) Todos todos,
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
  TodosStore() : super(const TodoState(todos: Todos({})));
}
