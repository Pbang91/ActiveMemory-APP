import 'package:active_memory/features/reference/domain/body_part.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'reference_api.g.dart';

// API 추상화 - Retrofit
@RestApi()
abstract class ReferenceApi {
  factory ReferenceApi(Dio dio) = _ReferenceApi;

  @GET('/references/body-parts')
  Future<List<BodyPart>> getBodyParts();
}
