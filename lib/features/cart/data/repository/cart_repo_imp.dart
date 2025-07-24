import '../../../menu/data/model/food_item.dart';
import 'cart_repo.dart';
import '../model/cart_item.dart';

class CartRepositoryImpl implements CartRepository {
  final List<CartItem> _items = [];

  @override
  List<CartItem> get items => List.unmodifiable(_items);

  @override
  void addItem(FoodItem foodItem) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodItem.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
    } else {
      _items.add(CartItem(foodItem: foodItem, quantity: 1));
    }
  }

  @override
  void removeItem(String foodItemId) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index] = _items[index].copyWith(quantity: _items[index].quantity - 1);
      } else {
        _items.removeAt(index);
      }
    }
  }

  @override
  void clearCart() {
    _items.clear();
  }
} 