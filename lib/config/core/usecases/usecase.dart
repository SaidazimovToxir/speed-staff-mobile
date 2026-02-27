// ignore_for_file: avoid_types_as_parameter_names

import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
