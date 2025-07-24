import 'package:equatable/equatable.dart';

import '../../../menu/data/model/food_item.dart';

class CartItem extends Equatable {
  final FoodItem foodItem;
  final int quantity;

  const CartItem({
    required this.foodItem,
    required this.quantity,
  });

  CartItem copyWith({
    FoodItem? foodItem,
    int? quantity,
  }) {
    return CartItem(
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => foodItem.price * quantity;

  @override
  List<Object?> get props => [foodItem, quantity];
} 