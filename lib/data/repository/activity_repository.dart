import 'package:project_app/_core/utils/date_format.dart';
import 'package:project_app/data/dtos/activity/activity_request.dart';
import 'package:project_app/ui/main/activity/viewmodel/activity_main_viewmodel.dart';
import 'package:project_app/ui/main/activity/viewmodel/change_weight_viewmodel.dart';
import 'package:project_app/ui/main/activity/viewmodel/drink_water_viewmodel.dart';
import 'package:project_app/ui/main/activity/viewmodel/walking_detail.viewmodel.dart';

import '../../_core/constants/http.dart';
import '../dtos/activity/activity_response.dart';
import '../dtos/response_dto.dart';

class ActivityRepository {
  Future<ResponseDTO> postMeal(DateTime date, SaveMealDTO saveMealDTO) async {
    final response = await dio.post("/api/meal/${DateFormatter.format(date)}",
        data: saveMealDTO.toJson());

    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.status == 200) {
      responseDTO.body = MealSaveResponseDTO.fromJson(responseDTO.body);
    }

    return responseDTO;
  }

  Future<ResponseDTO> fetchDeleteMeal(DateTime date, int mealId) async {
    final response =
        await dio.delete("/api/meal/${DateFormatter.format(date)}/${mealId}");

    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    return responseDTO;
  }

  Future<ResponseDTO> fetchMealListByDate(DateTime selectedDate) async {
    final response =
        await dio.get("/api/meal/${DateFormatter.format(selectedDate)}");

    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.status == 200) {
      MealMainDTO mealMainDTO = MealMainDTO.fromJson(responseDTO.body);
      responseDTO.body = mealMainDTO;
    }

    return responseDTO;
  }

  Future<ResponseDTO> fetchFoodList({String? keyword}) async {
    final response;

    if (keyword == null) {
      response = await dio.get("/api/foods");
    } else {
      response = await dio.get("/api/foods?keyword=${keyword}");
    }

    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.status == 200) {
      List<dynamic> foodContentList = responseDTO.body["foodContentList"];
      List<FoodContentListDTO> listDTO =
          foodContentList.map((e) => FoodContentListDTO.fromJson(e)).toList();
      responseDTO.body = listDTO;
    }

    return responseDTO;
  }

  Future<ResponseDTO> fetchChangeWeight() async {
    final response = await dio.get("/api/activities/body-date");
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.status == 200) {
      List<dynamic> tempFat = responseDTO.body["fatTimeLine"];
      List<dynamic> tempMuscle = responseDTO.body["muscleTimeLine"];
      List<dynamic> tempWeight = responseDTO.body["weightTimeLine"];

      List<FatTimeLineDTO> fatList =
          tempFat.map((e) => FatTimeLineDTO.fromJson(e)).toList();
      List<MuscleTimeLineDTO> muscleList =
          tempMuscle.map((e) => MuscleTimeLineDTO.fromJson(e)).toList();
      List<WeightTimeLineDTO> weightList =
          tempWeight.map((e) => WeightTimeLineDTO.fromJson(e)).toList();
      ChangeBodyDataDTO changeBodyData =
          ChangeBodyDataDTO.fromJson(responseDTO.body);
      ChangeWeightModel model =
          ChangeWeightModel(changeBodyData, fatList, muscleList, weightList);

      responseDTO.body = model;
    }

    return responseDTO;
  }

  Future<ResponseDTO> fetchActivityMain(String formattedDate) async {
    final response = await dio.get("/api/activities/date/${formattedDate}");

    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.status == 200) {
      ActivitiesDateDTO activitiesDateDTO =
          ActivitiesDateDTO.fromJson(responseDTO.body);
      // print("날짜 : ${activitiesDateDTO.createdAt}");
      // print("걸음수 : ${activitiesDateDTO.walking}");
      // print("몸무게 : ${activitiesDateDTO.weight}");
      // print("물  : ${activitiesDateDTO.weight}");
      // print("칼로리  : ${activitiesDateDTO.kcal}");

      ActivityMainModel model = ActivityMainModel(activitiesDateDTO);

      responseDTO.body = model;
    }

    return responseDTO;
  }

  Future<ResponseDTO> fetchDrinkWater() async {
    final response = await dio.get("/api/activities/water/detail");
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.status == 200) {
      List<dynamic> tempWater = responseDTO.body["weakWater"];
      List<WeakWaterDTO> weakWaterDTO =
          tempWater.map((e) => WeakWaterDTO.fromJson(e)).toList();
      DrinkWaterDTO drinkWaterDTO = DrinkWaterDTO.fromJson(responseDTO.body);
      DrinkWaterModel model = DrinkWaterModel(drinkWaterDTO, weakWaterDTO);
      print("물 : ${drinkWaterDTO.dayWater}");
      print("날짜 : ${weakWaterDTO.last.date}");
      responseDTO.body = model;
    }

    return responseDTO;
  }

  Future<ResponseDTO> fetchWalkingDetail() async {
    final response = await dio.get("/api/activities/walking/detail");
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.status == 200) {
      List<dynamic> tempWalking = responseDTO.body["weakWalkings"];
      List<WeakWalkingDTO> weakWalkings =
          tempWalking.map((e) => WeakWalkingDTO.fromJson(e)).toList();
      WalkingDetailDTO walkingDetailDTO =
          WalkingDetailDTO.fromJson(responseDTO.body);
      WalkingDetailModel model =
          WalkingDetailModel(walkingDetailDTO, weakWalkings);
      responseDTO.body = model;
    }
    return responseDTO;
  }

  Future<ResponseDTO> fetchSendWalking(int steps) async {
    StepDTO stepDTO = StepDTO(steps);
    final response =
        await dio.put("/api/activities/walking-update", data: stepDTO);
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    return responseDTO;
  }

  Future<ResponseDTO> fetchUpdateWater(int water) async {
    WaterDTO waterDTO = WaterDTO(water);
    final response =
        await dio.put("/api/activities/water-update", data: waterDTO);
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    return responseDTO;
  }
}
