import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final IStatusService _statusService;
  StreamSubscription _subscription;

  StatusBloc(this._statusService) : super(StatusState.initial());

  @override
  Stream<StatusState> mapEventToState(StatusEvent event) async* {
    if (event is Subscribed) {
      await _subscription?.cancel();
      _subscription = _statusService
          .userStatus(event.user)
          .listen((userStatus) => add(_StatusReceived(userStatus)));
    }

    if (event is _StatusReceived) {
      yield StatusState.received(event.userStatus);
    }
    if (event is StatusSent) {
      await _statusService.send(event.userStatus);
      yield StatusState.sent(event.userStatus);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _statusService.dispose();
    return super.close();
  }
}
