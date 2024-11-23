import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/intercom/ui/route/mixer/mixer_state.dart';

class MixerBloc extends Cubit<MixerRouteState> {
  MixerBloc() : super(MixerRouteState());

  void toggleLive({required int cameraId}) {
    // TODO not implemented
  }

  Future<void> sendMessage({
    required int cameraId,
    required String message,
  }) async {
    // TODO not implemented
  }
}
