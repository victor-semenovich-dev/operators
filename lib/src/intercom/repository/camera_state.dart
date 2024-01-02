import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../data/camera.dart';
import '../ui/widget/camera_widget.dart';

class CameraState {
  final int id;

  CameraState(this.id);

  Stream<Camera> open() {
    return FirebaseDatabase.instance
        .ref('intercom/camera/$id')
        .onValue
        .map((event) {
      return Camera.fromJson(id, event.snapshot.value as Map);
    });
  }

  void setLive(bool isLive) {
    FirebaseDatabase.instance.ref('intercom/camera/$id/isLive').set(isLive);
  }

  void setReady(bool isReady) {
    FirebaseDatabase.instance.ref('intercom/camera/$id/isReady').set(isReady);
  }

  void setRequested(bool isRequested) {
    FirebaseDatabase.instance
        .ref('intercom/camera/$id/isRequested')
        .set(isRequested);
  }

  Future<void> sendMessage(String message, CameraContext cameraContext) async {
    final dbRef = FirebaseDatabase.instance.ref('intercom/camera/$id');
    final child = cameraContext == CameraContext.CAMERA
        ? 'outcomingMessages'
        : 'incomingMessages';

    final snapshot = await dbRef.get();
    int index = 0;
    if (snapshot.hasChild(child)) {
      final eventValue = snapshot.child(child).value;
      if (eventValue is List) {
        index = eventValue.length;
      } else if (eventValue is Map) {
        eventValue.forEach((key, value) {
          final i = int.parse(key);
          if (i > index) {
            index = i;
          }
          index++;
        });
      }
    }
    await dbRef.child(child).child(index.toString()).set({'text': message});
  }

  void messageRead(CameraContext cameraContext) {
    if (cameraContext == CameraContext.CAMERA) {
      FirebaseDatabase.instance
          .ref('intercom/camera/$id/incomingMessages')
          .remove();
    } else {
      FirebaseDatabase.instance
          .ref('intercom/camera/$id/outcomingMessages')
          .remove();
    }
  }

  void setCameraOk(bool isOk) {
    FirebaseDatabase.instance.ref('intercom/camera/$id/isOk').set(isOk);
  }
}
