import 'package:active_memory/src/common/network/dio_client.dart';
import 'package:active_memory/src/features/reference/data/mapper/exercise_mapper.dart';
import 'package:active_memory/src/features/reference/data/reference_api.dart';
import 'package:active_memory/src/features/reference/domain/entity/exercise.dart';
import 'package:active_memory/src/features/reference/domain/repository/reference_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reference_repository.g.dart';

// 1. API Client 빈 등록
@riverpod
ReferenceRepositoryImpl referenceRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final api = ReferenceApi(dio);
  return ReferenceRepositoryImpl(api);
}

class ReferenceRepositoryImpl implements ReferenceRepository {
  final ReferenceApi _api;

  ReferenceRepositoryImpl(this._api);

  @override
  Future<List<StandardExercise>> getExercies() async {
    final response = await _api.getExercies();

    return response.data.map((dto) => dto.toEntity()).toList();
  }
}
