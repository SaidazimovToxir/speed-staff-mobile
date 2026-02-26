import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<SignInEvent>(_onSignIn);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()));
    }
  }
}
