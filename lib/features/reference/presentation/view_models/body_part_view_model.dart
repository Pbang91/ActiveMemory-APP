import 'package:active_memory/features/reference/data/reference_repository.dart';
import 'package:active_memory/features/reference/domain/body_part.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'body_part_view_model.g.dart';

@riverpod
Future<List<BodyPart>> bodyParts(Ref ref) {
  final repository = ref.watch(referenceRepositoryProvider);

  return repository.getBodyParts();
}
