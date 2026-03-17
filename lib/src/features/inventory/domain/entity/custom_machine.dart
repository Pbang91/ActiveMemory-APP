class MachineBodyPart {
  final String code;
  final String name;

  MachineBodyPart({
    required this.code,
    required this.name,
  });
}

class MachineStandardExercise {
  final int standardExerciseId;
  final String name;

  MachineStandardExercise({
    required this.standardExerciseId,
    required this.name,
  });
}

class MachineMuscle {
  final int muscleId;
  final String name;
  final String role;

  MachineMuscle({
    required this.muscleId,
    required this.name,
    required this.role,
  });
}

class CustomMachine {
  final int customMachineId;
  final String name;
  final String? memo;
  final MachineBodyPart bodyPart;
  final MachineStandardExercise standardExercise;
  final List<MachineMuscle> muscles;

  CustomMachine({
    required this.customMachineId,
    required this.name,
    this.memo,
    required this.bodyPart,
    required this.standardExercise,
    required this.muscles,
  });
}
