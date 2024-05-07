//창고 데이터
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_app/data/dtos/response_dto.dart';
import 'package:project_app/data/dtos/today/today_request.dart';
import 'package:project_app/data/dtos/user/user_request.dart';
import 'package:project_app/data/store/session_store.dart';
import 'package:project_app/main.dart';
import '../../../../data/dtos/today/today_response.dart';
import '../../../../data/dtos/user/user_response.dart';
import '../../../../data/repository/today_repository.dart';

class TodayPageModel {
  MainDTO mainDTO;
  List<BodyDataDTO> bodyData;

  TodayPageModel({required this.mainDTO, required this.bodyData});
}

// 창고 창고

class TodayPageViewModel extends StateNotifier<TodayPageModel?> {
  final mContext = navigatorKey.currentContext;
  final Ref ref;

  TodayPageViewModel(super.state, this.ref);

  Future<void> notifyInit() async {
    SessionStore sessionStore = ref.read(sessionProvider);

    ResponseDTO responseDTO =
        await TodayRepository().fetchMainPage(sessionStore.accessToken!);

    if (responseDTO.status == 200) {
      MainDTO mainDTO = MainDTO.fromJson(responseDTO.body);
      List<BodyDataDTO> bodyData = mainDTO.bodyData;
      TodayPageModel model =
          TodayPageModel(mainDTO: mainDTO, bodyData: bodyData);
      state = model;
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(content: Text("불러오기 실패 : ${responseDTO.msg}")));
    }
  }

  Future<void> notifyAddBodyData(UpdateBodyDataRequestDTO requestDTO) async {
    SessionStore sessionStore = ref.read(sessionProvider);
    ResponseDTO responseDTO = await TodayRepository()
        .fetchUpdateBodyData(requestDTO, sessionStore.accessToken!);

    if (responseDTO.status == 200) {
      MainDTO mainDTO = MainDTO(
          fat: responseDTO.body.fat,
          muscle: responseDTO.body.muscle,
          weight: responseDTO.body.weight,
          bodyData: []);
      TodayPageModel model = TodayPageModel(mainDTO: mainDTO, bodyData: []);

      state = model;
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(content: Text("데이터 입력 실패 : ${responseDTO.msg}")));
    }
  }

  Future<void> resetPage(body) async {
    TodayPageModel model = state!;
    MainDTO prevMain = model.mainDTO;
    List<BodyDataDTO> prevBodyData = model.bodyData;
  }
}

// 창고 관리자
final TodayPageProvider =
    StateNotifierProvider<TodayPageViewModel, TodayPageModel?>(
  (ref) {
    return TodayPageViewModel(null, ref)..notifyInit();
  },
);
