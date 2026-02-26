part of 'restaurant_detail_bloc.dart';

abstract class RestaurantDetailEvent extends Equatable {
  const RestaurantDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurantDetail extends RestaurantDetailEvent {
  final String restaurantId;

  const LoadRestaurantDetail(this.restaurantId);

  @override
  List<Object?> get props => [restaurantId];
}
