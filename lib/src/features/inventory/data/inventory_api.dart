import 'package:active_memory/src/common/network/base_response.dart';
import 'package:active_memory/src/features/inventory/data/dto/my_gym_response.dart';
import 'package:active_memory/src/features/inventory/data/dto/register_my_gym_request.dart';
import 'package:active_memory/src/features/inventory/data/dto/register_my_gym_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'inventory_api.g.dart';

@RestApi()
abstract class InventoryApi {
  factory InventoryApi(Dio dio) = _InventoryApi;

  @POST('/inventories/gym')
  Future<SuccessResponse<RegisterMyGymResponse>> registerGym(
      @Body() RegisterMyGymRequest body);

  @GET('/inventories/gym')
  Future<SuccessResponse<List<GetMyGymResponse>>> getMyGyms();
}
