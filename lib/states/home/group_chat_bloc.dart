import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';

class GroupChatBloc extends Cubit<List<User>> {
  GroupChatBloc() : super([]);

  add(User user) {
    state.add(user);
    emit(List.from(state));
  }

  remove(User user) {
    state.removeWhere((element) => element.id == user.id);
    emit(List.from(state));
  }
}
