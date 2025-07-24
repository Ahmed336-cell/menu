import '../../../menu/data/model/food_item.dart';
import '../model/cart_item.dart';

abstract class CartRepository {
  List<CartItem> get items;
  void addItem(FoodItem foodItem);
  void removeItem(String foodItemId);
  void clearCart();
} 