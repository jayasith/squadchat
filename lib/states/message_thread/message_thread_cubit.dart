import 'package:bloc/bloc.dart';
import 'package:squadchat/models/local_message.dart';
import 'package:squadchat/view_models/chat_view_model.dart';

class MessageThreadCubit extends Cubit<List<LocalMessage>> {
  final ChatViewModel viewModel;
  MessageThreadCubit(this.viewModel) : super([]);

  Future<void> messages(String chatId) async {
    final messages = await viewModel.getMessages(chatId);
    emit(messages);
  }
}
