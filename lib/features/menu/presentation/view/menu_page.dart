import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../auth/presentation/controller/auth_cubit.dart';
import '../../../cart/presentation/controller/cart_cubit.dart';
import '../../../cart/presentation/view/cart_page.dart';
import '../../data/model/food_item.dart';
import '../controller/menu_cubit.dart';

class MenuPage extends StatefulWidget {
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<String> _categories = const [
    'All', 'Pizza', 'Burgers', 'Salads', 'Mexican', 'Desserts', 'Pasta'
  ];
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      context.read<MenuCubit>().loadMenuItems();
      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
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
                _buildSearchBar(context),
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
                        // Debug print
                        // print('Filtered items: ${filtered.length}');
                        if (filtered.isEmpty && state.items.isNotEmpty) {
                          return const Center(child: Text('No items found.'));
                        }
                        return _buildMenuGrid(filtered.isEmpty ? state.items : filtered, context);
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
      floatingActionButton: _buildCartFAB(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text('FoodieApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 1.2)),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () => context.read<AuthCubit>().signOut(),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return BlocBuilder<MenuCubit, MenuState>(
      buildWhen: (prev, curr) => prev.search != curr.search,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(24),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search food...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => context.read<MenuCubit>().setSearch(val),
            ),
          ),
        );
      },
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

  Widget _buildMenuGrid(List<FoodItem> items, BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildFoodCard(items[index], context),
    );
  }

  Widget _buildFoodCard(FoodItem item, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
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
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ' 4${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                        AnimatedScale(
                          scale: 1.0,
                          duration: const Duration(milliseconds: 150),
                          child: InkWell(
                            onTap: () => _addToCart(item, context),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B35),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartFAB(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final itemCount = context.read<CartCubit>().itemCount;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              ),
              backgroundColor: const Color(0xFFFF6B35),
              label: const Row(
                children: [
                  Icon(Icons.shopping_cart),
                  SizedBox(width: 8),
                  Text('Cart'),
                ],
              ),
            ),
            if (itemCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    '$itemCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
          ],
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