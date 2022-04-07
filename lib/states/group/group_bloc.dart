import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'group_event.dart';

part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc(this._groupService) : super(GroupState.initial());

  final GroupService _groupService;
  StreamSubscription _streamSubscription;

  @override
  Stream<GroupState> mapEventToState(GroupEvent event) async* {
    if (event is Subscribed) {
      await _streamSubscription?.cancel();
      _streamSubscription = _groupService
          .groups(user: event.user)
          .listen((group) => add(_GroupReceived(group)));
    }
    if (event is _GroupReceived) {
      yield GroupState.received(event.group);
    }
    if (event is GroupCreated) {
      final group = await _groupService.create(event.group);
      yield GroupState.created(group);
    }

    @override
    Future<void> close() {
      print('dispose called');
      _streamSubscription?.cancel();
      _groupService.dispose();
      return super.close();
    }
  }
}
