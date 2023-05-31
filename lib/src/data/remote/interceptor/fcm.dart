import 'dart:async';

import 'package:chopper/chopper.dart';

class FcmInterceptor implements RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    return applyHeaders(
      request,
      {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAguHt3QU:APA91bHVJlb8UJW4MdOzX6Soi-JE_FFt4Fr1Q30FUUUzCQYbpCt4tpMTQktzvliGbhLpqSF1SfLSx6-I5WFZ5x2ebkNrkocti_ylKtKpBVhmbFdaldPcp6OEOzPU0jovP3RQcb0i6Z0b',
      },
    );
  }
}
