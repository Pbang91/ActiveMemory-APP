import 'package:active_memory/features/reference/presentation/view_models/body_part_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReferenceScreen extends ConsumerWidget {
  const ReferenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Provider 구독 (데이터의 상태를 실시간으로 감지)
    final bodyPartsAsync = ref.watch(bodyPartsProvider);

    return Scaffold(
      body: bodyPartsAsync.when(
        //로딩 중일 때 (스켈레톤 UI나 로딩바)
        loading: () => const Center(child: CircularProgressIndicator()),
        //에러 났을 때 (인터셉터 로그 확인)
        error: (err, stack) => Center(child: Text('에러: $err')),
        //데이터 도착했을 때 (List<BodyPart>)
        data: (bodyParts) {
          return CustomScrollView(
            slivers: [
              // 앱바 (스크롤하면 작아지는 효과)
              const SliverAppBar(
                title: Text("운동 부위"),
                floating: true,
                snap: true,
              ),

              // 고성능 리스트 (SliverList)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final part = bodyParts[index];
                    return ListTile(
                      title: Text(part.name), // 한글 이름
                      subtitle: Text(part.code), // 코드 (CHEST)
                      leading: const Icon(Icons.fitness_center),
                      onTap: () {
                        // TODO: 상세 화면 이동
                        debugPrint("클릭: ${part.name}");
                      },
                    );
                  },
                  childCount: bodyParts.length, // 데이터 개수
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
