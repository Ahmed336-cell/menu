import 'package:dartz/dartz.dart';
import '../../../../core/Failures.dart';
import 'menu_repo.dart';
import '../model/food_item.dart';

class MenuRepositoryImpl implements MenuRepository {
  @override
  Future<Either<Failure, List<FoodItem>>> getMenuItems() async {
    try {
      // Static data for demonstration. Replace with Firestore or API call as needed.
      final items = [
        const FoodItem(
          id: '1',
          name: 'Margherita Pizza',
          price: 12.99,
          description: 'Classic pizza with fresh tomatoes, mozzarella, and basil',
          imageUrl: 'https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=400',
          category: 'Pizza',
        ),
        const FoodItem(
          id: '2',
          name: 'Chicken Burger',
          price: 8.99,
          description: 'Juicy grilled chicken with lettuce, tomato, and mayo',
          imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
          category: 'Burgers',
        ),
        const FoodItem(
          id: '3',
          name: 'Caesar Salad',
          price: 7.99,
          description: 'Fresh romaine lettuce with parmesan and caesar dressing',
          imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
          category: 'Salads',
        ),
        const FoodItem(
          id: '4',
          name: 'Beef Tacos',
          price: 10.99,
          description: 'Three soft tacos with seasoned beef, cheese, and salsa',
          imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
          category: 'Mexican',
        ),
        const FoodItem(
          id: '5',
          name: 'Chocolate Cake',
          price: 5.99,
          description: 'Rich chocolate cake with chocolate ganache',
          imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
          category: 'Desserts',
        ),
        const FoodItem(
          id: '6',
          name: 'Pasta Carbonara',
          price: 11.99,
          description: 'Creamy pasta with bacon, egg, and parmesan cheese',
          imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=400',
          category: 'Pasta',
        ),
      ];
      return right(items);
    } catch (e) {
      return left(ServerFailure('Failed to load menu items'));
    }
  }
} 