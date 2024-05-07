import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_app/data/dtos/response_dto.dart';
import 'package:project_app/data/repository/challenge_respository.dart';
import 'package:project_app/data/store/session_store.dart';
import 'package:project_app/main.dart';

import '../../../../data/dtos/challenge/challenge_response.dart';

class ChallengeDetailModel {
  ChallengeDetailDTO challengeDetailDTO;

  ChallengeDetailModel(this.challengeDetailDTO);
}

class ChallengeDetailViewModel extends StateNotifier<ChallengeDetailModel?> {
  final mContext = navigatorKey.currentContext;
  Ref ref;

  ChallengeDetailViewModel(super._state, this.ref);

  Future<void> notifyInit(int challengeId) async {
    SessionStore sessionStore = ref.read(sessionProvider);

    ResponseDTO responseDTO = await ChallengeRepository()
        .getChallengeDetail(challengeId, sessionStore.accessToken!);

    ChallengeDetailModel challengeDetailModel =
        ChallengeDetailModel(ChallengeDetailDTO.fromJson(responseDTO.body));
    if (responseDTO.status == 200) {
      state = challengeDetailModel;
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(content: Text("챌린지 정보 불러오기 실패 : ${responseDTO.msg}")));
    }
  }
}

final challengeDetailProvider = StateNotifierProvider.family
    .autoDispose<ChallengeDetailViewModel, ChallengeDetailModel?, int>(
        (ref, challengeId) {
  return ChallengeDetailViewModel(null, ref)..notifyInit(challengeId);
});