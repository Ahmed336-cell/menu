import 'package:flutter/material.dart';
import '../../data/model/food_item.dart';
import 'menu_food_card.dart';

class MenuGrid extends StatelessWidget {
  final List<FoodItem> items;
  const MenuGrid({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => MenuFoodCard(item: items[index]),
    );
  }
} 