part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Category> categories;
  final List<Restaurant> restaurants;
  final String selectedCategoryId;

  const HomeLoaded({
    required this.categories,
    required this.restaurants,
    required this.selectedCategoryId,
  });

  @override
  List<Object?> get props => [categories, restaurants, selectedCategoryId];

  HomeLoaded copyWith({
    List<Category>? categories,
    List<Restaurant>? restaurants,
    String? selectedCategoryId,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      restaurants: restaurants ?? this.restaurants,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
