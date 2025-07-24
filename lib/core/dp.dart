import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../features/auth/data/repository/auth_repo_imp.dart';
import '../features/auth/presentation/controller/auth_cubit.dart';
import '../features/cart/data/repository/cart_repo_imp.dart';
import '../features/cart/presentation/controller/cart_cubit.dart';
import '../features/menu/data/repository/menu_repo_imp.dart';
import '../features/menu/presentation/controller/menu_cubit.dart';

class Dp{
  final sl = GetIt.instance;

  void setupLocator() {
    // Register repositories
    sl.registerLazySingleton<AuthRepositoryImpl>(() => AuthRepositoryImpl());
    sl.registerLazySingleton<MenuRepositoryImpl>(() => MenuRepositoryImpl());
    sl.registerLazySingleton<CartRepositoryImpl>(() => CartRepositoryImpl());

    // Register cubits
    sl.registerFactory(() => AuthCubit());
    sl.registerFactory(() => MenuCubit(sl<MenuRepositoryImpl>()));
    sl.registerFactory(() => CartCubit());
  }

  List<BlocProvider> get blocProviders => [
    BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
    BlocProvider<MenuCubit>(create: (_) => MenuCubit(sl<MenuRepositoryImpl>())),
    BlocProvider<CartCubit>(create: (_) => CartCubit()),
  ];
} 