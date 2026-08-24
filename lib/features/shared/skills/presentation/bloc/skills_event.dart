import 'package:equatable/equatable.dart';

sealed class SkillsEvent extends Equatable {
  const SkillsEvent();

  @override
  List<Object?> get props => [];
}

class FetchSkills extends SkillsEvent {
  final String? q;
  final String? category;

  const FetchSkills({this.q, this.category});

  @override
  List<Object?> get props => [q, category];
}
