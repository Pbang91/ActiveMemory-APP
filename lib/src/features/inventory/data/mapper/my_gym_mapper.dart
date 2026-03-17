import 'package:active_memory/src/features/inventory/data/dto/get_my_gym_machine_response.dart';
import 'package:active_memory/src/features/inventory/data/dto/my_gym_response.dart';
import 'package:active_memory/src/features/inventory/data/dto/register_my_gym_machine_request.dart';
import 'package:active_memory/src/features/inventory/data/dto/register_my_gym_request.dart';
import 'package:active_memory/src/features/inventory/data/dto/update_my_gym_machine_request.dart';
import 'package:active_memory/src/features/inventory/domain/command/register_my_gym_machine_command.dart';
import 'package:active_memory/src/features/inventory/domain/command/regitser_my_gym_command.dart';
import 'package:active_memory/src/features/inventory/domain/command/update_my_gym_machine_command.dart';
import 'package:active_memory/src/features/inventory/domain/entity/custom_machine.dart';
import 'package:active_memory/src/features/inventory/domain/entity/my_gym.dart';

extension RegisterMyGymCommandMapper on RegisterMyGymCommand {
  RegisterMyGymRequest toDto() {
    return RegisterMyGymRequest(
        providerId: providerId, name: name, address: address, x: x, y: y);
  }
}

extension GetMyGymResponseMapper on GetMyGymResponse {
  MyGym toEntity() {
    return MyGym(myGymId: myGymId, name: name, address: address);
  }
}

extension GetMyGymMachineBodyPartMapper on GetMyGymMachineBodyPart {
  MachineBodyPart toEntity() {
    return MachineBodyPart(
      code: code,
      name: name,
    );
  }
}

extension GetMyGymMachineStandardExerciseMapper
    on GetMyGymMachineStandardExercise {
  MachineStandardExercise toEntity() {
    return MachineStandardExercise(
      standardExerciseId: standardExerciseId,
      name: name,
    );
  }
}

extension GetMyGymMachineMuscleMapper on GetMyGymMachineMuscle {
  MachineMuscle toEntity() {
    return MachineMuscle(
      muscleId: muscleId,
      name: name,
      role: role,
    );
  }
}

extension GetMyGymMachineMapper on GetMyGymMachineResponse {
  CustomMachine toEntity() {
    return CustomMachine(
      customMachineId: customMachineId,
      name: name,
      memo: memo,
      bodyPart: bodyPart.toEntity(), // 미리 만들어둔 하위 매퍼의 toEntity()
      standardExercise: standardExercise.toEntity(),
      muscles: muscles.map((muscle) => muscle.toEntity()).toList(),
    );
  }
}

extension RegisterMyGymMachineMuscleMappingDataCommandMapper
    on RegisterMyGymMachineMuscleMappingDataCommand {
  RegisterMyGymMachineMuscleMappingDataRequest toDto() {
    return RegisterMyGymMachineMuscleMappingDataRequest(
        muscleId: muscleId, role: role);
  }
}

extension RegisterMyGymMachineCommandMpaaer on RegisterMyGymMachineCommand {
  RegisterMyGymMachineRequest toDto() {
    return RegisterMyGymMachineRequest(
      name: name,
      standardExerciseId: standardExerciseId,
      bodyPartCode: bodyPartCode,
      muscleMappingDataList: muscleMappingDataList
          .map((muscleData) => muscleData.toDto())
          .toList(),
      memo: memo,
    );
  }
}

extension UpdateMyGymMachineMuscleMappingDataCommandMapper
    on UpdateMyGymMachineMuscleMappingDataCommand {
  UpdateMyGymMachineMuscleMappingDataRequest toDto() {
    return UpdateMyGymMachineMuscleMappingDataRequest(
        muscleId: muscleId, role: role);
  }
}

extension UpdateMyGymMachineCommandMapper on UpdateMyGymMachineCommand {
  UpdateMyGymMachineRequest toDto() {
    return UpdateMyGymMachineRequest(
      name: name,
      standardExerciseId: standardExerciseId,
      bodyPartCode: bodyPartCode,
      muscleMappingDataList: muscleMappingDataList
          .map((muscleData) => muscleData.toDto())
          .toList(),
      memo: memo,
    );
  }
}
