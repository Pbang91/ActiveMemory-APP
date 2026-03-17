import 'package:active_memory/src/common/theme/app_colors.dart';
import 'package:active_memory/src/features/inventory/data/inventory_repository.dart';
import 'package:active_memory/src/features/inventory/domain/command/register_my_gym_machine_command.dart';
import 'package:active_memory/src/features/inventory/domain/command/update_my_gym_machine_command.dart';
import 'package:active_memory/src/features/inventory/domain/entity/custom_machine.dart';
import 'package:active_memory/src/features/reference/domain/exercise/entity/standard_exercise.dart';
import 'package:active_memory/src/features/reference/domain/exercise/entity/standard_exercise_muscle.dart';
import 'package:active_memory/src/features/reference/presentation/widget/exercise_search_bottom_sheet.dart';
import 'package:active_memory/src/features/reference/presentation/widget/muscle_search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterMyGymMachineScreen extends ConsumerStatefulWidget {
  final int gymId;
  final CustomMachine? machineToEdit;

  const RegisterMyGymMachineScreen({
    super.key,
    required this.gymId,
    this.machineToEdit,
  });

  @override
  ConsumerState<RegisterMyGymMachineScreen> createState() =>
      _RegisterMyGymMachineScreenState();
}

class _RegisterMyGymMachineScreenState
    extends ConsumerState<RegisterMyGymMachineScreen> {
  final _nameController = TextEditingController();
  final _memoController = TextEditingController();

  StandardExercise? _selectedExercise;
  List<StandardExerciseMuscle> _selectedMuscles = [];

  @override
  void initState() {
    super.initState();

    // 수정 모드일 경우 기존 데이터 엎어쓰기
    if (widget.machineToEdit != null) {
      final machine = widget.machineToEdit!;

      _nameController.text = machine.name;

      if (machine.memo != null) {
        _memoController.text = machine.memo!;
      }

      _selectedExercise = StandardExercise(
          id: machine.standardExercise.standardExerciseId,
          name: machine.standardExercise.name,
          description: '',
          bodyPartCode: machine.bodyPart.code,
          bodyPartName: machine.bodyPart.name,
          equipmentName: '',
          targetMuscles: []);

      _selectedMuscles = machine.muscles
          .map((m) => StandardExerciseMuscle(
                id: m.muscleId,
                name: m.name,
                role: m.role,
              ))
          .toList();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('나만의 기구 이름을 입력해주세요.')),
      );
      return;
    }

    if (_selectedExercise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('매핑할 운동 종목을 선택해주세요.')),
      );
      return;
    }

    try {
      // 로딩 인디케이터를 띄우고 싶다면 setState(() => _isLoading = true); 추가 가능
      if (widget.machineToEdit == null) {
        final command = RegisterMyGymMachineCommand(
          name: _nameController.text.trim(),
          standardExerciseId: _selectedExercise!.id,
          bodyPartCode: _selectedExercise!.bodyPartCode, // 종목의 대분류를 그대로 따라감
          muscleMappingDataList: _selectedMuscles.map((muscle) {
            return RegisterMyGymMachineMuscleMappingDataCommand(
              muscleId: muscle.id,
              role: muscle.role, // 'PRIMARY' or 'SECONDARY'
            );
          }).toList(),
          memo: _memoController.text.trim().isEmpty
              ? null
              : _memoController.text.trim(),
        );

        await ref
            .read(inventoryRepositoryProvider)
            .registerMyGymMachine(widget.gymId, command);
      } else {
        final command = UpdateMyGymMachineCommand(
          name: _nameController.text.trim(),
          standardExerciseId: _selectedExercise!.id, // 바뀐 종목 정보 (그대로면 기존 값)
          bodyPartCode: _selectedExercise!.bodyPartCode,
          muscleMappingDataList: _selectedMuscles
              .map((muscle) => UpdateMyGymMachineMuscleMappingDataCommand(
                  muscleId: muscle.id, role: muscle.role))
              .toList(), // 택갈이 할 새로운 근육 리스트
          memo: _memoController.text.trim().isEmpty
              ? null
              : _memoController.text.trim(),
        );

        await ref.read(inventoryRepositoryProvider).updateMyGymMachine(
            widget.gymId, widget.machineToEdit!.customMachineId, command);
      }

      // 성공 시 현재 창을 닫으면서 이전 화면에 true를 넘겨줌
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.machineToEdit == null
                  ? '기구가 등록되었습니다.'
                  : '기구가 수정되었습니다.')),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('기구 등록에 실패했습니다. 다시 시도해주세요.\n($e)')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.machineToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? '기구 수정' : '기구 등록'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 나만의 기구 이름
            const Text("기구 이름",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "예) 파라마운트 숄더 프레스",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),

            // 2. 종목 및 부위 선택 (버튼을 눌러 검색 화면이나 바텀시트 띄우기)
            const Text("운동 종목 매핑",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final result = await showModalBottomSheet<StandardExercise>(
                  context: context,
                  isScrollControlled: true, // 바텀시트 높이를 조절하기 위함
                  backgroundColor: Colors.transparent,
                  builder: (context) => const ExerciseSearchBottomSheet(),
                );

                if (result != null) {
                  setState(() {
                    _selectedExercise = result;

                    if (_nameController.text.isEmpty) {
                      _nameController.text = result.name;
                    }

                    _selectedMuscles = List.from(result.targetMuscles);
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedExercise != null
                          ? "${_selectedExercise!.name} (${_selectedExercise!.bodyPartName})"
                          : "운동 종목을 선택해주세요",
                      style: TextStyle(
                        color: _selectedExercise == null
                            ? Colors.grey
                            : AppColors.primary,
                        fontWeight: _selectedExercise == null
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    Icon(
                      _selectedExercise == null
                          ? Icons.search
                          : Icons.check_circle,
                      color: _selectedExercise == null
                          ? Colors.grey
                          : AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text("타겟 근육 설정",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),

            if (_selectedMuscles.isEmpty)
              Text("운동 종목을 매핑하면 기본 근육이 자동 설정됩니다.",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),

            Wrap(
              spacing: 8, // 가로 여백
              runSpacing: 8, // 줄바꿈 시 세로 여백
              children: [
                ..._selectedMuscles.map((muscle) {
                  final isPrimary = muscle.role == 'PRIMARY';

                  return Chip(
                    label:
                        Text("${muscle.name} (${isPrimary ? '주동근' : '협력근'})"),
                    labelStyle: TextStyle(
                      color:
                          isPrimary ? AppColors.primary : Colors.grey.shade700,
                      fontWeight:
                          isPrimary ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                    backgroundColor: isPrimary
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.grey.shade100,
                    side: BorderSide.none,
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      // X 버튼을 누르면 목록에서 제거
                      setState(() {
                        _selectedMuscles.remove(muscle);
                      });
                    },
                  );
                }),

                // + 추가 버튼 (직접 다른 근육을 더하고 싶을 때)
                ActionChip(
                  label: const Text("+ 추가"),
                  labelStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  backgroundColor: Colors.grey.shade400,
                  side: BorderSide.none,
                  onPressed: () async {
                    // 현재 이미 선택된 근육 ID 목록 추출 (중복 방지용)
                    final alreadySelectedIds =
                        _selectedMuscles.map((m) => m.id).toList();

                    // 다중 선택 바텀시트 띄우기
                    final List<StandardExerciseMuscle>? newMuscles =
                        await showModalBottomSheet<
                            List<StandardExerciseMuscle>>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => MuscleSearchBottomSheet(
                        alreadySelectedIds: alreadySelectedIds,
                      ),
                    );

                    // 결과가 있으면 기존 리스트에서 중복 없이 병합
                    if (newMuscles != null && newMuscles.isNotEmpty) {
                      setState(() {
                        _selectedMuscles.addAll(newMuscles);
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 4. 나만의 세팅 메모
            const Text("메모",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _memoController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "예) 의자 높이 3칸, 와이드 그립으로 진행",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              isEditMode ? "수정하기" : "등록하기",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
