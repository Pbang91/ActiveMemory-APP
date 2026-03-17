import 'package:active_memory/src/common/network/base_response.dart';
import 'package:active_memory/src/features/inventory/data/dto/get_my_gym_machine_response.dart';
import 'package:active_memory/src/features/inventory/data/dto/my_gym_response.dart';
import 'package:active_memory/src/features/inventory/data/dto/register_my_gym_machine_request.dart';
import 'package:active_memory/src/features/inventory/data/dto/register_my_gym_request.dart';
import 'package:active_memory/src/features/inventory/data/dto/register_my_gym_response.dart';
import 'package:active_memory/src/features/inventory/data/dto/update_my_gym_machine_request.dart';
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

  @GET('/inventories/gym/{myGymId}/machine')
  Future<SuccessResponse<List<GetMyGymMachineResponse>>> getMyGymMachine(
      @Path('myGymId') int myGymId);

  @POST('/inventories/gym/{myGymId}/machine')
  Future<SuccessResponse<dynamic>> registerMyGymMachine(
    @Path('myGymId') int myGymId,
    @Body() RegisterMyGymMachineRequest request,
  );

  @PUT('/inventories/gym/{myGymId}/machine/{machineId}')
  Future<SuccessResponse<dynamic>> updateMyGymMachine(
    @Path('myGymId') int myGymId,
    @Path('machineId') int machineId,
    @Body() UpdateMyGymMachineRequest request,
  );
}
