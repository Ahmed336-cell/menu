import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/cart_item.dart';
import '../controller/cart_cubit.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final BuildContext parentContext;

  const CartItemWidget({super.key, required this.item, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.foodItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      confirmDismiss: (_) async {
        parentContext.read<CartCubit>().removeItem(item.foodItem.id);
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CachedNetworkImage(
              imageUrl: item.foodItem.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.restaurant, color: Colors.grey),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          title: Text(
            item.foodItem.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Color(0xFF2D3748),
            ),
          ),
          subtitle: Text(
            "${item.foodItem.price.toStringAsFixed(2)} EGP",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFFF6B35)),
                onPressed: () => parentContext.read<CartCubit>().removeItem(item.foodItem.id),
              ),
              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Color(0xFFFF6B35)),
                onPressed: () => parentContext.read<CartCubit>().addItem(item.foodItem),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 