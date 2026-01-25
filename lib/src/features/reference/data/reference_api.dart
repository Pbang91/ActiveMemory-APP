import 'package:active_memory/src/common/network/base_response.dart';
import 'package:active_memory/src/features/reference/data/dto/get_exercise_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'reference_api.g.dart';

// API 추상화 - Retrofit
@RestApi()
abstract class ReferenceApi {
  factory ReferenceApi(Dio dio) = _ReferenceApi;

  @GET('/references/exercises')
  Future<BaseResponse<List<GetExerciseResponse>>> getExercies();
}
