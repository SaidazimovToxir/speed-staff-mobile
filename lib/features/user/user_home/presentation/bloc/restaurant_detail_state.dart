part of 'restaurant_detail_bloc.dart';

abstract class RestaurantDetailState extends Equatable {
  const RestaurantDetailState();
  
  @override
  List<Object?> get props => [];
}

class RestaurantDetailInitial extends RestaurantDetailState {}

class RestaurantDetailLoading extends RestaurantDetailState {}

class RestaurantDetailLoaded extends RestaurantDetailState {
  final Restaurant restaurant;
  final List<Review> reviews;

  const RestaurantDetailLoaded({
    required this.restaurant,
    required this.reviews,
  });

  @override
  List<Object?> get props => [restaurant, reviews];
}

class RestaurantDetailError extends RestaurantDetailState {
  final String message;

  const RestaurantDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
