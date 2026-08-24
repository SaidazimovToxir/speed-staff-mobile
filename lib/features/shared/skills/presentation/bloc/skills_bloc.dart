import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/shared/skills/domain/usecases/get_skills.dart';
import 'package:speed_staff_mobile/features/shared/skills/presentation/bloc/skills_event.dart';
import 'package:speed_staff_mobile/features/shared/skills/presentation/bloc/skills_state.dart';

class SkillsBloc extends Bloc<SkillsEvent, SkillsState> {
  final GetSkills getSkillsUseCase;

  SkillsBloc(this.getSkillsUseCase) : super(const SkillsState()) {
    on<FetchSkills>(_onFetchSkills);
  }

  Future<void> _onFetchSkills(FetchSkills event, Emitter<SkillsState> emit) async {
    emit(state.copyWith(status: SkillsStatus.loading));

    final result = await getSkillsUseCase(GetSkillsParams(q: event.q, category: event.category));

    result.fold(
      (failure) => emit(state.copyWith(status: SkillsStatus.failure, errorMessage: failure.message)),
      (skills) => emit(state.copyWith(status: SkillsStatus.success, skills: skills)),
    );
  }
}
