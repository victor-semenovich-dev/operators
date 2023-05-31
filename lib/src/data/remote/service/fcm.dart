import 'package:chopper/chopper.dart';

part 'fcm.chopper.dart';

@ChopperApi(baseUrl: "/send")
abstract class FcmService extends ChopperService {
  static FcmService create([ChopperClient? client]) => _$FcmService(client);

  @Post()
  Future<Response> send(@Body() Map<String, dynamic> request);
}
