import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project_app/_core/constants/constants.dart';
import 'package:project_app/ui/main/activity/viewmodel/change_weight_viewmodel.dart';

import '../../../../_core/utils/date_format.dart';
import '../../../../data/dtos/activity/activity_response.dart';
import '../../../../data/dtos/activity/activity_response.dart';

Widget buildMetricView(String currentLabel,
    String currentValue,
    String goalLabel,
    String goalValue,
    Color lineColor,
    List<Color> gradientColors,
    ChangeWeightModel model,
    String type) {
  return CustomScrollView(
    slivers: <Widget>[
      SliverToBoxAdapter(
        child: Container(
          color: kAccentColor2,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildWeightIndicator(currentLabel, currentValue),
              Container(
                  height: 50,
                  width: 2,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 55)),
              buildWeightIndicator(goalLabel, goalValue),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: buildWeightGraph(lineColor, gradientColors, model, type),
      ),
      SliverList(
        delegate: SliverChildListDelegate([buildTimeline(model, type)]),
      ),
    ],
  );
}

Widget buildWeightIndicator(String label, String value) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(value,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      Text(label, style: TextStyle(fontSize: 16, color: Colors.white70)),
    ],
  );
}

Widget buildWeightGraph(Color lineColor, List<Color> gradientColors,
    ChangeWeightModel model, String type) {
  List<FlSpot> bodyChart = [];

  if (type == "fat") {
    int dataLength = model.fatTimeLineDTO!.length;
    int startIndex = max(0, dataLength - 10); // 마지막 10개 데이터의 시작 인덱스
    for (int i = dataLength - 1; i >= startIndex; i--) {
      var item = model.fatTimeLineDTO![i];
      bodyChart.add(FlSpot((dataLength - 1 - i).toDouble(), item.fat));
    }
  } else if (type == "muscle") {
    int dataLength = model.muscleTimeLineDTO!.length;
    int startIndex = max(0, dataLength - 10); // 마지막 10개 데이터의 시작 인덱스
    for (int i = dataLength - 1; i >= startIndex; i--) {
      var item = model.muscleTimeLineDTO![i];
      bodyChart.add(FlSpot((dataLength - 1 - i).toDouble(), item.muscle));
    }
  } else if (type == "weight") {
    int dataLength = model.weightTimeLineDTO!.length;
    int startIndex = max(0, dataLength - 10); // 마지막 10개 데이터의 시작 인덱스
    for (int i = dataLength - 1; i >= startIndex; i--) {
      var item = model.weightTimeLineDTO![i];
      bodyChart.add(FlSpot((dataLength - 1 - i).toDouble(), item.weight));
    }
  }

  return Container(
    height: 200,
    decoration: BoxDecoration(color: kAccentColor2),
    child: LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 9,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: bodyChart,
            isCurved: true,
            color: lineColor,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


Widget buildTimeline(ChangeWeightModel model, String type) {
  List<Map<String, String>> data = [];


  if (type == "fat") {
    model.fatTimeLineDTO?.forEach((item) {
      data.add({
        "fat": "${item.fat} kg",
        "date": item.formattedDate,
      });
    });
  } else if (type == "muscle") {
    model.muscleTimeLineDTO?.forEach((item) {
      data.add({
        "muscle": "${item.muscle} kg",
        "date": item.formattedDate,
      });
    });
  } else if (type == "weight") {
    model.weightTimeLineDTO?.forEach((item) {
      data.add({
        "weight": "${item.weight} kg",
        "date": item.formattedDate,
      });
    });
  }
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: Text("타임라인",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      Stack(
        children: [
          CustomPaint(
            painter: TimelinePainter(
                data.map((entry) => 60.0 + data.indexOf(entry) * 120).toList()),
            size: Size(40, 400),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Column(
              children: List.generate(data.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[index][type]!,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SizedBox(height: 4),
                              Text(data[index]["date"]!,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      )
    ],
  );
}


class TimelinePainter extends CustomPainter {
  final List<double> yPositions;

  TimelinePainter(this.yPositions);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kAccentColor2
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    for (int i = 0; i < yPositions.length; i++) {
      if (i > 0) {
        canvas.drawLine(
          Offset(size.width / 2, yPositions[i - 1]),
          Offset(size.width / 2, yPositions[i]),
          paint,
        );
      }
      canvas.drawCircle(Offset(size.width / 2, yPositions[i]), 10, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
