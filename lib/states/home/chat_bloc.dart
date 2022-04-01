
import 'package:bloc/bloc.dart';
import 'package:squadchat/view_models/chats_view_model.dart';

import '../../models/chat.dart';

class ChatBloc extends Cubit<List<Chat>>{
  final ChatsViewModel chatsViewModel;
  ChatBloc(this.chatsViewModel) : super([]);

  Future<void> chats() async{
    final chats = await chatsViewModel.getChats();
    emit(chats);
  }

}