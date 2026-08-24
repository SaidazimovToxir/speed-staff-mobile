import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/seeker/profile/data/datasources/seeker_profile_remote_datasource.dart';
import 'package:speed_staff_mobile/features/seeker/profile/data/models/seeker_profile_model.dart';
import 'package:speed_staff_mobile/features/seeker/profile/domain/entities/seeker_profile.dart';
import 'package:speed_staff_mobile/features/seeker/profile/domain/repositories/seeker_profile_repository.dart';

class SeekerProfileRepositoryImpl implements SeekerProfileRepository {
  final SeekerProfileRemoteDataSource remoteDataSource;
  SeekerProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, SeekerProfile>> getMyProfile() async {
    try {
      return Right(await remoteDataSource.getMyProfile());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, SeekerProfile>> updateProfile(Map<String, dynamic> data) async {
    try {
      return Right(await remoteDataSource.updateProfile(data));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, SeekerExperience>> addExperience(Map<String, dynamic> data) async {
    try {
      return Right(await remoteDataSource.addExperience(data));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateExperience(String id, Map<String, dynamic> data) async {
    try {
      await remoteDataSource.updateExperience(id, data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExperience(String id) async {
    try {
      await remoteDataSource.deleteExperience(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, SeekerDocument>> uploadDocument(String filePath, String title, String docType) async {
    try {
      return Right(await remoteDataSource.uploadDocument(filePath, title, docType));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocument(String id) async {
    try {
      await remoteDataSource.deleteDocument(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addSkill(int skillId, String level) async {
    try {
      await remoteDataSource.addSkill(skillId, level);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeSkill(int skillId) async {
    try {
      await remoteDataSource.removeSkill(skillId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(String filePath) async {
    try {
      return Right(await remoteDataSource.uploadAvatar(filePath));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> uploadResume(String filePath) async {
    try {
      return Right(await remoteDataSource.uploadResume(filePath));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<SkillModel>>> getAllSkills() async {
    try {
      return Right(await remoteDataSource.getAllSkills());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
