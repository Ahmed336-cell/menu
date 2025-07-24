part of 'menu_cubit.dart';

enum MenuStatus { initial, loading, loaded, error }

class MenuState extends Equatable {
  final List<FoodItem> items;
  final MenuStatus status;
  final String error;
  final String search;
  final String selectedCategory;

  const MenuState({
    required this.items,
    required this.status,
    required this.error,
    required this.search,
    required this.selectedCategory,
  });

  MenuState copyWith({
    List<FoodItem>? items,
    MenuStatus? status,
    String? error,
    String? search,
    String? selectedCategory,
  }) {
    return MenuState(
      items: items ?? this.items,
      status: status ?? this.status,
      error: error ?? this.error,
      search: search ?? this.search,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [items, status, error, search, selectedCategory];
} 