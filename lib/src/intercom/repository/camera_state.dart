import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:operators/main.dart';
import 'package:operators/src/data/model/user.dart';
import 'package:operators/src/data/util/dateTime.dart';
import 'package:operators/src/intercom/ui/route/home_route.dart';

import '../data/camera.dart';
import '../ui/widget/camera_widget.dart';

class CameraState {
  final int id;

  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  CameraState(this.id) {
    preferences
        .getString(KEY_INTERCOM_SERVER_LOCATION,
            defaultValue: VALUE_LOCATION_USA)
        .listen((value) {
      if (value == VALUE_LOCATION_USA) {
        firebaseDatabase = FirebaseDatabase.instance;
      } else if (value == VALUE_LOCATION_EU) {
        firebaseDatabase = FirebaseDatabase.instanceFor(app: euFirebaseApp);
      }
    });
  }

  Stream<Camera> open() {
    debugPrint('open: $id');
    return firebaseDatabase.ref('intercom/camera/$id').onValue.map((event) {
      return Camera.fromJson(id, event.snapshot.value as Map);
    });
  }

  void setLive(bool isLive) {
    firebaseDatabase.ref('intercom/camera/$id/isLive').set(isLive);
  }

  void setReady(bool isReady) {
    firebaseDatabase.ref('intercom/camera/$id/isReady').set(isReady);
  }

  void setRequested(bool isRequested) {
    firebaseDatabase.ref('intercom/camera/$id/isRequested').set(isRequested);
  }

  Future<void> sendMessage(
    TableUser? user,
    String message,
    CameraContext cameraContext,
  ) async {
    final dbRef = firebaseDatabase.ref('intercom/camera/$id');
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
      firebaseDatabase.ref('intercom/camera/$id/incomingMessages').remove();
    } else {
      firebaseDatabase.ref('intercom/camera/$id/outcomingMessages').remove();
    }
  }

  void setCameraOk(bool isOk) {
    firebaseDatabase.ref('intercom/camera/$id/isOk').set(isOk);
  }
}
