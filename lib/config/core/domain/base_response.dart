import 'package:equatable/equatable.dart';

import 'meta.dart';

class BaseResponse<T> extends Equatable {
  final List<T> data;
  final Meta meta;

  const BaseResponse({required this.data, required this.meta});

  @override
  List<Object?> get props => [data, meta];
}
