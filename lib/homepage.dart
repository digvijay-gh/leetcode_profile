// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var totalSolved;
  var totalQuestions;
  var easySolved;
  var totalEasy;
  var mediumSolved;
  var totalMedium;
  var hardSolved;
  var totalHard;
  var acceptanceRate;
  var ranking;
  var contributionPoints;
  var reputation;
  var submissionCalendar;
  bool showDate = false;

  final DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Map<DateTime, int> convertedSubmissionCalendar = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      var response = await Dio()
          .get("https://leetcode-stats-api.herokuapp.com/digvijaydsy2");
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        setState(() {
          totalSolved = responseData["totalSolved"] as int;
          totalQuestions = responseData["totalQuestions"] as int;
          easySolved = responseData["easySolved"] as int;
          totalEasy = responseData["totalEasy"] as int;
          mediumSolved = responseData["mediumSolved"] as int;
          totalMedium = responseData["totalMedium"] as int;
          hardSolved = responseData["hardSolved"] as int;
          totalHard = responseData["totalHard"] as int;
          acceptanceRate = responseData["acceptanceRate"] as double;
          ranking = responseData["ranking"] as int;
          contributionPoints = responseData["contributionPoints"] as int;
          reputation = responseData["reputation"] as int;
          submissionCalendar =
              responseData["submissionCalendar"] as Map<String, dynamic>;

          if (submissionCalendar != null) {
            submissionCalendar.forEach(
              (timestamp, count) {
                DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(timestamp) * 1000);

                DateTime dt2 =
                    DateTime(dateTime.year, dateTime.month, dateTime.day);

                convertedSubmissionCalendar[dt2] = count;
              },
            );
          }
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/images/logo.png"),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                "Show Dates?",
                // style: TextStyle(fontSize: 16),
              ),
              Switch(
                value: showDate,
                onChanged: (booli) {
                  setState(() {
                    showDate = !showDate;
                  });
                },
              ),
              const SizedBox(width: 8)
            ],
          ),
        ],
        title: const Text("LeetCode"),
      ),
      body: SafeArea(
        child: (totalSolved != null)
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    profileCard(),
                    const SizedBox(height: 8),
                    problemsSolvedCard(),
                    const SizedBox(height: 20),
                    submissionDoneToday(),
                    const SizedBox(height: 12),
                    myHeatMap(context),
                    const SizedBox(height: 40),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget submissionDoneToday() {
    return (convertedSubmissionCalendar.containsKey(today))
        ? Text(
            "You have done ${convertedSubmissionCalendar[today]} submissions today",
            style: const TextStyle(
                fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
          )
        : const Text(
            "You have not made any submissions today",
            style: TextStyle(
                fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
          );
  }

  Padding profileCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset("assets/images/profile_pic.jpeg")),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Digvijay Singh Yadav",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "digvijaydsy2",
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "Rank   ",
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey.shade300),
                      ),
                      Text(
                        "$ranking",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(CupertinoIcons.star_fill,
                  color: Color(0xffffc01e), size: 20),
              const SizedBox(width: 8),
              Text(
                "Reputation",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade300),
              ),
              const SizedBox(width: 16),
              Text(
                "$reputation",
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.check_box, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                "Acceptance Rate",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade300),
              ),
              const SizedBox(width: 16),
              Text(
                "$acceptanceRate %",
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.view_agenda, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                "Contribution Points",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade300),
              ),
              const SizedBox(width: 16),
              Text(
                "$contributionPoints",
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

  Card problemsSolvedCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Text(
                "Solved Problems",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 20,
                  child: Center(
                    child: PieChart(
                      dataMap: {
                        "Solved": (totalSolved != null)
                            ? totalSolved.toDouble()
                            : 0.0,
                        "Unsolved":
                            (totalSolved != null && totalQuestions != null)
                                ? (totalQuestions! - totalSolved!).toDouble()
                                : 0.0,
                      },
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: 100,
                      colorList: [
                        const Color(0xffffc01e),
                        Colors.grey.shade700
                      ],
                      initialAngleInDegree: 270,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 6,
                      centerText: "$totalSolved \n Solved",
                      centerTextStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      legendOptions: const LegendOptions(
                          showLegendsInRow: false, showLegends: false),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: false,
                        showChartValues: false,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 34,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DifficultyCategoryWidget(
                        solved: easySolved ?? 0,
                        total: totalEasy ?? 1,
                        difficulty: "Easy",
                        frontColor: 0xff01b9a3,
                        backColor: 0xff294c34,
                      ),
                      const SizedBox(height: 12),
                      DifficultyCategoryWidget(
                        solved: mediumSolved ?? 0,
                        total: totalMedium ?? 1,
                        difficulty: "Medium",
                        frontColor: 0xffffc01e,
                        backColor: 0xff5e4e26,
                      ),
                      const SizedBox(height: 12),
                      DifficultyCategoryWidget(
                        solved: hardSolved ?? 0,
                        total: totalHard ?? 1,
                        difficulty: "Hard",
                        frontColor: 0xffee4742,
                        backColor: 0xff5b302e,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 8)
          ],
        ),
      ),
    );
  }

  HeatMap myHeatMap(BuildContext context) {
    return HeatMap(
      showText: showDate,
      // textColor: Colors.white,
      size: 24,
      // defaultColor: const Color(0xff383938),
      defaultColor: Colors.grey.shade800,
      datasets: convertedSubmissionCalendar,
      colorMode: ColorMode.color,
      showColorTip: false,
      scrollable: true,
      colorsets: const {
        1: Color(0xff006720),
        3: Color(0xff119832),
        5: Color(0xff28c244),
        10: Color(0xff7fe18b)
      },
      onClick: (value) {
        String submits = convertedSubmissionCalendar[value].toString();
        List monList = <String>[
          " ",
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec"
        ];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "$submits submissions on ${monList[value.month]} ${value.day}, ${value.year}"),
          ),
        );
      },
    );
  }
}

class DifficultyCategoryWidget extends StatelessWidget {
  const DifficultyCategoryWidget({
    super.key,
    required this.solved,
    required this.total,
    required this.difficulty,
    required this.backColor,
    required this.frontColor,
  });

  final int solved;
  final int total;
  final String difficulty;
  final int backColor;
  final int frontColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(difficulty),
            Row(
              children: [
                Text(
                  "$solved",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  " / $total",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.maxFinite,
          height: 8,
          decoration: BoxDecoration(
              color: Color(backColor), borderRadius: BorderRadius.circular(16)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (solved / total),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(frontColor),
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
        )
      ],
    );
  }
}
