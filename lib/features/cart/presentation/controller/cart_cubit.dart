import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../menu/data/model/food_item.dart';
import '../../data/model/cart_item.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<CartItem> items;
  final double totalPrice;

  CartUpdated({required this.items, required this.totalPrice});

  @override
  List<Object?> get props => [items, totalPrice];
}

class CartCubit extends Cubit<CartState> {
  List<CartItem> _items = [];

  CartCubit() : super(CartInitial());

  void addItem(FoodItem foodItem) {
    final existingIndex = _items.indexWhere((item) => item.foodItem.id == foodItem.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(CartItem(foodItem: foodItem, quantity: 1));
    }
    
    _updateState();
  }

  void removeItem(String foodItemId) {
    final existingIndex = _items.indexWhere((item) => item.foodItem.id == foodItemId);
    
    if (existingIndex >= 0) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex] = _items[existingIndex].copyWith(
          quantity: _items[existingIndex].quantity - 1,
        );
      } else {
        _items.removeAt(existingIndex);
      }
    }
    
    _updateState();
  }

  void clearCart() {
    _items.clear();
    _updateState();
  }

  void _updateState() {
    final totalPrice = _items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    
    emit(CartUpdated(items: List.from(_items), totalPrice: totalPrice));
  }

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
} 