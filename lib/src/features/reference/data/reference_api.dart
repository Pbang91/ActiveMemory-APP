import 'package:active_memory/src/common/network/base_response.dart';
import 'package:active_memory/src/features/reference/data/dto/get_exercise_response.dart';
import 'package:active_memory/src/features/reference/data/dto/get_gym_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'reference_api.g.dart';

// API 추상화 - Retrofit
@RestApi()
abstract class ReferenceApi {
  factory ReferenceApi(Dio dio) = _ReferenceApi;

  @GET('/references/exercise')
  Future<BaseResponse<List<GetExerciseResponse>>> getExercies();

  @GET('/references/gym')
  Future<BaseResponse<List<GetGymResponse>>> getGymList(@Query("q") String q);
}
