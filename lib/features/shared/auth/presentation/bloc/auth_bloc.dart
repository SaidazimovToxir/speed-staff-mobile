import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/usecases/send_otp.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/usecases/verify_otp.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/usecases/register_finalize.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/usecases/check_auth_status.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/usecases/get_current_user.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/usecases/logout.dart';
import 'package:speed_staff_mobile/config/core/usecases/usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtp sendOtpUseCase;
  final VerifyOtp verifyOtpUseCase;
  final RegisterFinalize registerFinalizeUseCase;
  final CheckAuthStatus checkAuthStatusUseCase;
  final GetCurrentUser getCurrentUserUseCase;
  final Logout logoutUseCase;

  AuthBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.registerFinalizeUseCase,
    required this.checkAuthStatusUseCase,
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<FinalizeRegistrationEvent>(_onFinalizeRegistration);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await checkAuthStatusUseCase.checkInitial();

    result.fold((failure) => emit(AuthFailure(failure.message)), (user) {
      if (user != null && user.isAuthenticated) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial());
      }
    });
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await sendOtpUseCase(SendOtpParams(phoneNumber: event.telephoneNumber));

    result.fold((failure) => emit(AuthFailure(failure.message)), (requestId) => emit(AuthOtpSent(event.telephoneNumber)));
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await verifyOtpUseCase(VerifyOtpParams(telephoneNumber: event.telephoneNumber, confirmCode: event.confirmCode));

    result.fold((failure) => emit(AuthFailure(failure.message)), (user) {
      if (user.needsProfileUpdate) {
        emit(AuthNeedsProfileUpdate(user));
      } else {
        emit(AuthSuccess(user));
      }
    });
  }

  Future<void> _onFinalizeRegistration(FinalizeRegistrationEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerFinalizeUseCase(
      RegisterFinalizeParams(
        phone: event.phone,
        code: event.code,
        password: event.password,
        role: event.role,
        firstName: event.firstName,
        lastName: event.lastName,
        restaurantName: event.restaurantName,
      ),
    );

    result.fold((failure) => emit(AuthFailure(failure.message)), (user) => emit(AuthSuccess(user)));
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUseCase(NoParams());
    result.fold((failure) => emit(AuthFailure(failure.message)), (_) => emit(AuthInitial()));
  }
}
