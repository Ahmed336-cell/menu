import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/food_item.dart';
import '../../data/repository/menu_repo.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository menuRepository;
  MenuCubit(this.menuRepository)
      : super(MenuState(
          items: const [],
          status: MenuStatus.initial,
          error: '',
          search: '',
          selectedCategory: 'All',
        ));

  Future<void> loadMenuItems() async {
    emit(state.copyWith(status: MenuStatus.loading));
    final result = await menuRepository.getMenuItems();
    result.fold(
      (failure) => emit(state.copyWith(status: MenuStatus.error, error: failure.message)),
      (items) => emit(state.copyWith(items: items, status: MenuStatus.loaded)),
    );
  }

  void setSearch(String search) {
    emit(state.copyWith(search: search));
  }

  void setCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }
} 