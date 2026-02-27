import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/user/user_home/data/repositories/mock_home_repository.dart';
import 'package:speed_staff_mobile/features/user/user_home/domain/models/restaurant_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MockHomeRepository repository;
  
  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final categories = await repository.getCategories();
      final restaurants = await repository.getRestaurants();
      
      emit(HomeLoaded(
        categories: categories,
        restaurants: restaurants,
        selectedCategoryId: categories.first.id, // default to All
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void _onSelectCategory(SelectCategory event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(selectedCategoryId: event.categoryId));
    }
  }
}
