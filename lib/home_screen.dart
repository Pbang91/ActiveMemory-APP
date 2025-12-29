import 'package:active_memory/features/reference/data/reference_repository.dart';
import 'package:active_memory/features/reference/domain/body_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bodyPartsProvider = FutureProvider<List<BodyPart>>((ref) {
  return ref.read(referenceRepositoryProvider).getBodyParts();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bodyPartsAsync = ref.watch(bodyPartsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("운동 부위")),
      body: bodyPartsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('에러: $err')),
        data: (bodyParts) {
          return ListView.builder(
            itemCount: bodyParts.length,
            itemBuilder: (context, index) {
              final part = bodyParts[index];
              return ListTile(
                title: Text(part.name),
                subtitle: Text(part.code),
              );
            },
          );
        },
      ),
    );
  }
}
