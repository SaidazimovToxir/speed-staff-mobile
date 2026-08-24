class Category {
  final String id;
  final String name;
  final String? icon; // can be an emoji or asset path

  Category({
    required this.id,
    required this.name,
    this.icon,
  });
}

class Restaurant {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final bool isOpen;
  final String imageUrl;
  final String? description;
  final List<String> categoryIds; // Links to Categories

  Restaurant({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.isFavorite,
    required this.isOpen,
    required this.imageUrl,
    this.description,
    required this.categoryIds,
  });
}

class Review {
  final String id;
  final String authorName;
  final String? authorImage;
  final double rating;
  final String timeAgo;
  final String text;

  Review({
    required this.id,
    required this.authorName,
    this.authorImage,
    required this.rating,
    required this.timeAgo,
    required this.text,
  });
}
