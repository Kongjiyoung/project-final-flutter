// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pedometer/pedometer.dart';
// import 'package:project_app/ui/main/activity/viewmodel/walking_detail.viewmodel.dart';
//
// import '../../../../_core/constants/constants.dart';
// import '../../../../_core/constants/http.dart';
// import '../widgets/step_count_body.dart';
//
// //todo: StepTimer 실행시
// class StepCountDetailPage extends ConsumerStatefulWidget {
//   @override
//   _StepCountDetailPageState createState() => _StepCountDetailPageState();
// }
//
// class _StepCountDetailPageState extends ConsumerState<StepCountDetailPage> {
//   int _currentSteps = 0;
//   late StreamSubscription<StepCount> _stepCountStream;
//   Timer? _timer;
//   int secondCount = 0; // 클래스 레벨에서 secondCount 선언
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSteps();
//     _initializePedometer();
//     _startTimer();
//   }
//
//   void _initializePedometer() {
//     _stepCountStream = Pedometer.stepCountStream.listen(
//       _onStepCount,
//       onError: _onStepCountError,
//     );
//   }
//
//   void _onStepCount(StepCount event) {
//     setState(() {
//       _currentSteps = event.steps;
//     });
//     _saveSteps(_currentSteps);
//   }
//
//   void _onStepCountError(dynamic error) {
//     print("Step Count Error: $error");
//   }
//
//   void _saveSteps(int steps) async {
//     await secureStorage.write(key: 'current_steps', value: steps.toString());
//   }
//
//   Future<void> _loadSteps() async {
//     String? storedSteps = await secureStorage.read(key: 'current_steps');
//     setState(() {
//       _currentSteps = int.tryParse(storedSteps ?? '0') ?? 0;
//     });
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
//       setState(() {
//         _currentSteps++;
//       });
//       _saveSteps(_currentSteps);
//
//       secondCount++; // 매 초마다 카운터 증가
//
//       if (secondCount % 10 == 0) {
//         _sendCurrentStepsToServer();
//       }
//     });
//   }
//
//   void _sendCurrentStepsToServer() async {
//     String? stepsString = await secureStorage.read(key: 'current_steps');
//     int steps = int.tryParse(stepsString ?? '0') ?? 0;
//     ref.read(WalkingDetailProvider.notifier).sendStepsToServer(steps);
//   }
//
//   @override
//   void dispose() {
//     _stepCountStream.cancel();
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('걸음 수', style: TextStyle(color: Colors.white)),
//           backgroundColor: kAccentColor2,
//           iconTheme: IconThemeData(color: Colors.white),
//           bottom: TabBar(
//             tabs: [
//               Tab(text: 'Day'),
//               Tab(text: 'Week'),
//               Tab(text: 'Month'),
//             ],
//             indicatorColor: Colors.white,
//             labelColor: Colors.white,
//           ),
//         ),
//         body: StepCountBody(currentSteps: _currentSteps),
//       ),
//     );
//   }
// }

//todo: StepCount 실행시 (실제 만보기)

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedometer/pedometer.dart';
import '../../../../_core/constants/constants.dart';
import '../../../../_core/constants/http.dart';
import '../widgets/step_count_body.dart';
import '../../activity/viewmodel/walking_detail.viewmodel.dart';


class StepCountDetailPage extends ConsumerStatefulWidget {
  @override
  _StepCountDetailPageState createState() => _StepCountDetailPageState();
}

class _StepCountDetailPageState extends ConsumerState<StepCountDetailPage> {
  int _currentSteps = 0;
  late StreamSubscription<StepCount> _stepCountStream;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadSteps(); // 앱 시작 시 저장된 단계 수 불러오기
    _initializePedometer();
    _startTimer();
  }

  void _initializePedometer() {
    _stepCountStream = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
    );
  }

  void _onStepCount(StepCount event) {
    setState(() {
      _currentSteps = event.steps;
    });
    _saveSteps(_currentSteps); // 단계 수를 Secure Storage에 저장
  }

  void _onStepCountError(dynamic error) {
    print("Step Count Error: $error");
  }

  void _saveSteps(int steps) async {
    await secureStorage.write(key: 'current_steps', value: steps.toString());
  }

  Future<void> _loadSteps() async {
    String? storedSteps = await secureStorage.read(key: 'current_steps');
    setState(() {
      _currentSteps = int.tryParse(storedSteps ?? '0') ?? 0;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      _sendCurrentStepsToServer();
    });
  }

  void _sendCurrentStepsToServer() async {
    String? stepsString = await secureStorage.read(key: 'current_steps');
    int steps = int.tryParse(stepsString ?? '0') ?? 0;
    ref.read(WalkingDetailProvider.notifier).sendStepsToServer(steps);
  }

  @override
  void dispose() {
    _stepCountStream.cancel();
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('걸음 수', style: TextStyle(color: Colors.white)),
          backgroundColor: kAccentColor2,
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Day'),
              Tab(text: 'Week'),
              Tab(text: 'Month'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
          ),
        ),
        body: StepCountBody(currentSteps: _currentSteps),
      ),
    );
  }
}

