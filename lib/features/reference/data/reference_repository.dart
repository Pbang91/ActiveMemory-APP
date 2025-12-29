import 'package:active_memory/common/dio_client.dart';
import 'package:active_memory/features/reference/data/reference_api.dart';
import 'package:active_memory/features/reference/domain/body_part.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reference_repository.g.dart';

// 1. API Client 빈 등록
@riverpod
ReferenceApi referenceApi(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ReferenceApi(dio);
}

// 2. Repository 빈 등록(External Use - UI에서 이거 사용)
@riverpod
ReferenceRepository referenceRepository(Ref ref) {
  final api = ref.watch(referenceApiProvider);
  return ReferenceRepository(api);
}

// 3. 실제 구현 클래스 like Impl
class ReferenceRepository {
  final ReferenceApi _api;
  ReferenceRepository(this._api);

  Future<List<BodyPart>> getBodyParts() => _api.getBodyParts();
}
