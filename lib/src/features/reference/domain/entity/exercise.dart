class StandardExercise {
  final int id;
  final String name;
  final String? description;
  final String bodyPartName; // code 한글
  final String bodyPartCode;
  final String equipmentName; // type 한글

  StandardExercise({
    required this.id,
    required this.name,
    this.description,
    required this.bodyPartName,
    required this.bodyPartCode,
    required this.equipmentName,
  });
}
