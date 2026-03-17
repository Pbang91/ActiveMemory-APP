import 'package:active_memory/src/features/reference/data/reference_repository.dart';
import 'package:active_memory/src/features/reference/domain/exercise/entity/muscle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 서버에서 근육 전체 리스트를 가져오는 Provider
final muscleListProvider = FutureProvider<List<Muscle>>((ref) async {
  final repository = ref.watch(referenceRepositoryProvider);
  return await repository.getMuscles();
});
