class UpdateMyGymMachineCommand {
  final String name;
  final int standardExerciseId;
  final String bodyPartCode;
  final List<UpdateMyGymMachineMuscleMappingDataCommand> muscleMappingDataList;
  final String? memo;

  UpdateMyGymMachineCommand({
    required this.name,
    required this.standardExerciseId,
    required this.bodyPartCode,
    this.muscleMappingDataList = const [],
    this.memo,
  });
}

class UpdateMyGymMachineMuscleMappingDataCommand {
  final int muscleId;
  final String role;

  UpdateMyGymMachineMuscleMappingDataCommand({
    required this.muscleId,
    required this.role,
  });
}
