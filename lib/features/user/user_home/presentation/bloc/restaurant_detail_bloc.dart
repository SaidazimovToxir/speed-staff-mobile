import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/user/user_home/data/repositories/mock_home_repository.dart';
import 'package:speed_staff_mobile/features/user/user_home/domain/models/restaurant_model.dart';

part 'restaurant_detail_event.dart';
part 'restaurant_detail_state.dart';

class RestaurantDetailBloc extends Bloc<RestaurantDetailEvent, RestaurantDetailState> {
  final MockHomeRepository repository;
  
  RestaurantDetailBloc({required this.repository}) : super(RestaurantDetailInitial()) {
    on<LoadRestaurantDetail>(_onLoadRestaurantDetail);
  }

  Future<void> _onLoadRestaurantDetail(LoadRestaurantDetail event, Emitter<RestaurantDetailState> emit) async {
    emit(RestaurantDetailLoading());
    try {
      final restaurant = await repository.getRestaurantDetail(event.restaurantId);
      final reviews = await repository.getRestaurantReviews(event.restaurantId);
      emit(RestaurantDetailLoaded(
        restaurant: restaurant,
        reviews: reviews,
      ));
    } catch (e) {
      emit(RestaurantDetailError(e.toString()));
    }
  }
}
