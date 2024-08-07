import 'package:flutter/material.dart';
import 'package:project_app/data/dtos/challenge/challenge_response.dart';

import '../../../../_core/constants/line.dart';
import '../../../../_core/constants/size.dart';
import '../../../../_core/constants/style.dart';
import '../../../_common/components/challenge_container.dart';
import 'no_challenge_text.dart';

class AvailableChallenge extends StatelessWidget {
  final String title;
  final List<ChallengeListDTO>? challenges;

  const AvailableChallenge(
      {Key? key, required this.title, required this.challenges})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (challenges == null) {
      return NoChallengeText("모든 챌린지를 끝냈습니다.");
    } else {
      return Padding(
        padding: EdgeInsets.all(gap_m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(title, style: h6(mColor: Colors.grey)),
            ),
            line1,
            SizedBox(height: 10),
            Container(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: challenges!.length,
                separatorBuilder: (context, index) => SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return ChallengeContainer(challenge: challenges![index]);
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
