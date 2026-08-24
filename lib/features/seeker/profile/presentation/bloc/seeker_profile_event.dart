import 'package:equatable/equatable.dart';

abstract class SeekerProfileEvent extends Equatable {
  const SeekerProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadSeekerProfile extends SeekerProfileEvent {
  const LoadSeekerProfile();
}

class UpdateSeekerProfile extends SeekerProfileEvent {
  final Map<String, dynamic> data;
  const UpdateSeekerProfile(this.data);
  @override
  List<Object?> get props => [data];
}

// Skills
class AddSeekerSkill extends SeekerProfileEvent {
  final int skillId;
  final String level;
  const AddSeekerSkill({required this.skillId, required this.level});
  @override
  List<Object?> get props => [skillId, level];
}

class RemoveSeekerSkill extends SeekerProfileEvent {
  final int skillId;
  const RemoveSeekerSkill(this.skillId);
  @override
  List<Object?> get props => [skillId];
}

class LoadAllSkills extends SeekerProfileEvent {
  const LoadAllSkills();
}

// Experience
class AddSeekerExperience extends SeekerProfileEvent {
  final Map<String, dynamic> data;
  const AddSeekerExperience(this.data);
  @override
  List<Object?> get props => [data];
}

class EditSeekerExperience extends SeekerProfileEvent {
  final String id;
  final Map<String, dynamic> data;
  const EditSeekerExperience(this.id, this.data);
  @override
  List<Object?> get props => [id, data];
}

class DeleteSeekerExperience extends SeekerProfileEvent {
  final String id;
  const DeleteSeekerExperience(this.id);
  @override
  List<Object?> get props => [id];
}

// Documents
class UploadSeekerDocument extends SeekerProfileEvent {
  final String filePath;
  final String title;
  final String docType;
  const UploadSeekerDocument({required this.filePath, required this.title, required this.docType});
  @override
  List<Object?> get props => [filePath, title, docType];
}

class DeleteSeekerDocument extends SeekerProfileEvent {
  final String id;
  const DeleteSeekerDocument(this.id);
  @override
  List<Object?> get props => [id];
}

// Avatar / Resume
class UploadSeekerAvatar extends SeekerProfileEvent {
  final String filePath;
  const UploadSeekerAvatar(this.filePath);
  @override
  List<Object?> get props => [filePath];
}

class UploadSeekerResume extends SeekerProfileEvent {
  final String filePath;
  const UploadSeekerResume(this.filePath);
  @override
  List<Object?> get props => [filePath];
}

class ClearSeekerProfileMessages extends SeekerProfileEvent {
  const ClearSeekerProfileMessages();
}
