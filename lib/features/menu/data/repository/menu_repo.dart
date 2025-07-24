import 'package:dartz/dartz.dart';
import '../../../../core/Failures.dart';
import '../model/food_item.dart';

abstract class MenuRepository {
  Future<Either<Failure, List<FoodItem>>> getMenuItems();
} 