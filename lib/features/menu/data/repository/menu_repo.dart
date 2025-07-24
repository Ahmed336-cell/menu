import 'package:dartz/dartz.dart';
import '../../../../core/failures.dart';
import '../model/food_item.dart';

abstract class MenuRepository {
  Future<Either<Failure, List<FoodItem>>> getMenuItems();
} 