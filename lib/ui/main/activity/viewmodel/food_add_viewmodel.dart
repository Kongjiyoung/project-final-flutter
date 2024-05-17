import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_app/data/dtos/response_dto.dart';
import 'package:project_app/data/repository/activity_repository.dart';
import '../../../../data/dtos/activity/activity_response.dart';
import '../../../../data/models/activities/meal_detail.dart';
import '../../../../main.dart';

class FoodAddModel {
  String? selectedMealType;
  DateTime? selectedDate;
  String? selectedImg;
  List<FoodContentListDTO> foodContentList;
  List<FoodContentListDTO> selectedFoods;
  List<int> selectedServings; // 각 음식의 인분 수를 나타내는 리스트

  FoodAddModel({
    this.selectedMealType,
    this.selectedDate,
    this.selectedImg,
    required this.foodContentList,
    this.selectedFoods = const [],
    this.selectedServings = const [],
  });

  FoodAddModel copyWith({
    DateTime? selectedDate,
    String? selectedImg,
    String? selectedMealType,
    List<FoodContentListDTO>? foodContentList,
    List<FoodContentListDTO>? selectedFoods,
    List<int>? selectedServings, // 인분 수 추가
  }) {
    return FoodAddModel(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedImg: selectedImg ?? this.selectedImg,
      selectedMealType: selectedMealType ?? this.selectedMealType,
      foodContentList: foodContentList ?? this.foodContentList,
      selectedFoods: selectedFoods ?? this.selectedFoods,
      selectedServings: selectedServings ?? this.selectedServings,
    );
  }
}

class FoodAddViewModel extends StateNotifier<FoodAddModel?> {
  final mContext = navigatorKey.currentContext;
  final Ref ref;

  FoodAddViewModel(super._state, this.ref);

  void selectMealType(String mealType) {
    state = state!.copyWith(selectedMealType: mealType);
  }

  void selectImg(String img) {
    state = state!.copyWith(selectedImg: img);
  }

  void selectDate(DateTime date) {
    state = state!.copyWith(selectedDate: date);
  }

  void selectFood(FoodContentListDTO food, int portion) {
    final updatedFoods = List<FoodContentListDTO>.from(state!.selectedFoods)..add(food);
    final updatedServings = List<int>.from(state!.selectedServings)..add(portion);
    state = state!.copyWith(selectedFoods: updatedFoods, selectedServings: updatedServings);
  }

  void updatePortion(int index, int portion) {
    final updatedServings = List<int>.from(state!.selectedServings);
    updatedServings[index] = portion;
    state = state!.copyWith(selectedServings: updatedServings);
  }

  void removeFood(int index) {
    final updatedFoods = List<FoodContentListDTO>.from(state!.selectedFoods)..removeAt(index);
    final updatedServings = List<int>.from(state!.selectedServings)..removeAt(index);
    state = state!.copyWith(selectedFoods: updatedFoods, selectedServings: updatedServings);
  }

  bool canAddMeal() {
    return state!.selectedMealType != null && state!.selectedMealType!.isNotEmpty;
  }

  void addMeal(WidgetRef ref) {
    if (!canAddMeal()) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text('식사 종류를 선택하세요')),
      );
      return;
    }

    final newMeals = state!.selectedFoods.map((food) {
      final index = state!.selectedFoods.indexOf(food);
      final portion = state!.selectedServings[index];

      return MealDetail(
        date: state!.selectedDate ?? DateTime.now(),
        mealType: state!.selectedMealType!,
        foodName: food.name,
        gram: '${food.gram * portion}g',
        imagePath: state!.selectedImg ?? 'assets/images/workout.gif',
        calories: food.kcal * portion,
        targetCalories: 2000,
        carbo: food.carbo * portion,
        protein: food.protein * portion,
        fat: food.fat * portion,
      );
    }).toList();

    ref.read(mealProvider.notifier).addMeals(newMeals);
  }

  Future<void> loadFoodList({String? keyword}) async {
    ResponseDTO responseDTO = await ActivityRepository().fetchFoodList(keyword: keyword);
    List<FoodContentListDTO> foodContentListDTO = responseDTO.body;

    state = state!.copyWith(foodContentList: foodContentListDTO);
  }
}

final foodAddProvider = StateNotifierProvider<FoodAddViewModel, FoodAddModel?>((ref) {
  return FoodAddViewModel(
    FoodAddModel(
      foodContentList: [],
    ),
    ref,
  );
});
