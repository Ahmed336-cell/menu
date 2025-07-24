import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu/features/menu/presentation/widgets/menu_app_bar.dart';
import 'package:menu/features/menu/presentation/widgets/menu_cart_fab.dart';
import 'package:menu/features/menu/presentation/widgets/menu_grid.dart';
import 'package:menu/features/menu/presentation/widgets/menu_search_bar.dart';
import '../../../cart/presentation/controller/cart_cubit.dart';
import '../../data/model/food_item.dart';
import '../controller/menu_cubit.dart';

class MenuPage extends StatelessWidget {
  final List<String> _categories = const [
    'All', 'Pizza', 'Burgers', 'Salads', 'Mexican', 'Desserts', 'Pasta'
  ];

  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuCubit, MenuState>(
      listenWhen: (prev, curr) => prev.status == MenuStatus.initial && curr.status != MenuStatus.initial,
      listener: (context, state) {},
      child: Builder(
        builder: (context) {
          final status = context.select((MenuCubit cubit) => cubit.state.status);
          if (status == MenuStatus.initial) {
            context.read<MenuCubit>().loadMenuItems();
          }
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            appBar: MenuAppBar(),
            body: Stack(
              children: [
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      MenuSearchBar(),
                      _buildCategoryChips(context),
                      Expanded(
                        child: BlocBuilder<MenuCubit, MenuState>(
                          builder: (context, state) {
                            if (state.status == MenuStatus.loading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (state.status == MenuStatus.error) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                                    const SizedBox(height: 16),
                                    Text(state.error),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () => context.read<MenuCubit>().loadMenuItems(),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              );
                            } else if (state.status == MenuStatus.loaded) {
                              final filtered = state.items.where((item) {
                                final matchesCategory = state.selectedCategory == 'All' || item.category == state.selectedCategory;
                                final matchesSearch = item.name.toLowerCase().contains(state.search.toLowerCase());
                                return matchesCategory && matchesSearch;
                              }).toList();
                              if (filtered.isEmpty && state.items.isNotEmpty) {
                                return const Center(child: Text('No items found.'));
                              }
                              return MenuGrid(items:filtered.isEmpty ? state.items : filtered);
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: MenuCartFAB(),
          );
        },
      ),
    );
  }



  Widget _buildCategoryChips(BuildContext context) {
    return BlocBuilder<MenuCubit, MenuState>(
      buildWhen: (prev, curr) => prev.selectedCategory != curr.selectedCategory,
      builder: (context, state) {
        return SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final selected = cat == state.selectedCategory;
              return ChoiceChip(
                label: Text(
                  cat,
                  style: TextStyle(
                    color: selected ? Colors.white : Color(0xFF2D3748),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: selected,
                selectedColor: Color(0xFFFF6B35),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: selected ? 4 : 0,
                shadowColor: selected ? Colors.orangeAccent : Colors.transparent,
                onSelected: (_) => context.read<MenuCubit>().setCategory(cat),
              );
            },
          ),
        );
      },
    );
  }


  void _addToCart(FoodItem item, BuildContext context) {
    context.read<CartCubit>().addItem(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        backgroundColor: const Color(0xFFFF6B35),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }
} 