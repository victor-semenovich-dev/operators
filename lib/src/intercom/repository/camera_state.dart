import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:operators/src/data/model/user.dart';
import 'package:operators/src/data/util/dateTime.dart';

import '../data/camera.dart';
import '../ui/widget/camera_widget.dart';

FirebaseDatabase intercomFirebaseDatabase = FirebaseDatabase.instance;

class CameraState {
  final int id;

  CameraState(this.id);

  Stream<Camera> open() {
    debugPrint('open: $id');
    return intercomFirebaseDatabase
        .ref('intercom/camera/$id')
        .onValue
        .map((event) {
      return Camera.fromJson(id, event.snapshot.value as Map);
    });
  }

  void setLive(bool isLive) {
    intercomFirebaseDatabase.ref('intercom/camera/$id/isLive').set(isLive);
  }

  void setReady(bool isReady) {
    intercomFirebaseDatabase.ref('intercom/camera/$id/isReady').set(isReady);
  }

  void setRequested(bool isRequested) {
    intercomFirebaseDatabase
        .ref('intercom/camera/$id/isRequested')
        .set(isRequested);
  }

  Future<void> sendMessage(
    TableUser? user,
    String message,
    CameraContext cameraContext,
  ) async {
    final dbRef = intercomFirebaseDatabase.ref('intercom/camera/$id');
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

    await dbRef.child(child).child(index.toString()).set({
      'text': message,
      'author': user?.shortName ?? user?.name,
      'date': formatDateTimeSeconds.format(DateTime.now()),
    });
  }

  void messageRead(CameraContext cameraContext) {
    if (cameraContext == CameraContext.CAMERA) {
      intercomFirebaseDatabase
          .ref('intercom/camera/$id/incomingMessages')
          .remove();
    } else {
      intercomFirebaseDatabase
          .ref('intercom/camera/$id/outcomingMessages')
          .remove();
    }
  }

  void setCameraOk(bool isOk) {
    intercomFirebaseDatabase.ref('intercom/camera/$id/isOk').set(isOk);
  }
}
