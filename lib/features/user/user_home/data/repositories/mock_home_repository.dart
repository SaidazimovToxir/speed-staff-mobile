import 'package:speed_staff_mobile/features/user/user_home/domain/models/restaurant_model.dart';


class MockHomeRepository {
  static final List<Category> categories = [
    Category(id: '1', name: 'All'),
    Category(id: '2', name: 'Italian'),
    Category(id: '3', name: 'Sushi'),
    Category(id: '4', name: 'Vegan'),
  ];

  static final List<Restaurant> restaurants = [
    Restaurant(
      id: 'r1',
      name: 'The Golden Whisk',
      location: 'San Francisco, CA',
      rating: 4.8,
      reviewCount: 150,
      isFavorite: false,
      isOpen: true,
      imageUrl: 'assets/images/test1.png', 
      description: 'The Golden Whisk offers a premium dining experience specializing in flame-grilled steaks, organic vegetables, and a curated wine list. Our mission is to provide high-quality hospitality in a warm, inviting atmosphere.',
      categoryIds: ['1', '2'],
    ),
    Restaurant(
      id: 'r2',
      name: 'Sakura Gardens',
      location: 'Palo Alto, CA',
      rating: 4.6,
      reviewCount: 95,
      isFavorite: true,
      isOpen: true,
      imageUrl: 'assets/images/test2.png',
      description: 'Authentic Japanese cuisine with a modern twist.',
      categoryIds: ['1', '3'],
    ),
    Restaurant(
      id: 'r3',
      name: 'Verde Kitchen',
      location: 'Oakland, CA',
      rating: 4.9,
      reviewCount: 210,
      isFavorite: false,
      isOpen: false,
      imageUrl: 'assets/images/test3.png',
      description: 'Healthy and sustainable vegan meals sourced locally.',
      categoryIds: ['1', '4'],
    ),
  ];

  static final List<Review> reviews = [
    Review(
      id: 'rev1',
      authorName: 'Sarah Jenkins',
      rating: 5.0,
      timeAgo: '3d ago',
      text: '"The ribeye steak was perfectly cooked! The ambiance is cozy and the service is top-notch."',
    ),
    Review(
      id: 'rev2',
      authorName: 'Michael Chen',
      rating: 4.0,
      timeAgo: '1w ago',
      text: '"Great food but can get quite noisy during peak hours. Highly recommend the grilled asparagus side."',
    ),
    Review(
      id: 'rev3',
      authorName: 'Emily Murphy',
      rating: 5.0,
      timeAgo: '2m ago',
      text: '"Fantastic wine selection and the chocolate dessert is a must-try!"',
    ),
  ];

  Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return categories;
  }

  Future<List<Restaurant>> getRestaurants() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return restaurants;
  }

  Future<Restaurant> getRestaurantDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return restaurants.firstWhere((r) => r.id == id);
  }

  Future<List<Review>> getRestaurantReviews(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return reviews; // mocking same reviews for all for simplicity
  }
}
