class RegisterMyGymMachineCommand {
  final String name;
  final int standardExerciseId;
  final String bodyPartCode;
  final List<RegisterMyGymMachineMuscleMappingDataCommand>
      muscleMappingDataList;
  final String? memo;

  RegisterMyGymMachineCommand({
    required this.name,
    required this.standardExerciseId,
    required this.bodyPartCode,
    this.muscleMappingDataList = const [],
    this.memo,
  });
}

class RegisterMyGymMachineMuscleMappingDataCommand {
  final int muscleId;
  final String role;

  RegisterMyGymMachineMuscleMappingDataCommand({
    required this.muscleId,
    required this.role,
  });
}
