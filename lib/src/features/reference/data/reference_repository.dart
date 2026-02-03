import 'package:active_memory/src/common/network/dio_client.dart';
import 'package:active_memory/src/features/reference/data/mapper/exercise_mapper.dart';
import 'package:active_memory/src/features/reference/data/mapper/gym_mapper.dart';
import 'package:active_memory/src/features/reference/data/reference_api.dart';
import 'package:active_memory/src/features/reference/domain/exercise/entity/exercise.dart';
import 'package:active_memory/src/features/reference/domain/exercise/repository/exercise_repository.dart';
import 'package:active_memory/src/features/reference/domain/gym/entity/gym.dart';
import 'package:active_memory/src/features/reference/domain/gym/repository/gym_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reference_repository.g.dart';

// 1. API Client 빈 등록
@riverpod
ExerciseRepositoryImpl referenceRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final api = ReferenceApi(dio);
  return ExerciseRepositoryImpl(api);
}

@riverpod
GymRepositoryImpl gymRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final api = ReferenceApi(dio);

  return GymRepositoryImpl(api);
}

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ReferenceApi _api;

  ExerciseRepositoryImpl(this._api);

  @override
  Future<List<StandardExercise>> getExercies() async {
    final response = await _api.getExercies();

    return response.data.map((dto) => dto.toEntity()).toList();
  }
}

class GymRepositoryImpl implements GymRepository {
  final ReferenceApi _api;

  GymRepositoryImpl(this._api);

  @override
  Future<List<Gym>> getGyms(String keyword) async {
    final response = await _api.getGymList(keyword);
    return response.data.map((dto) => dto.toEntity()).toList();
  }
}
