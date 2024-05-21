import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/home_page_model.dart';
import '../components/nav_bar.dart';

class StatisticPageWidget extends StatefulWidget {
  //StatisticPageWidget({Key? key}) : super(key: key);
  StatisticPageWidget();

  @override
  State<StatisticPageWidget> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPageWidget> {
  late HomePageModel _model;
  int sold = 0;
  int bought = 0;

  @override
  void initState() {
    super.initState();
    initModel();
  }

  Future<void> initModel() async {
    _model = HomePageModel();
    _model.initState(context);
    await _model.initializeContract();
    await getSold();
  }

  Future<void> getSold() async {
    try {
      List<dynamic> result = await _model.query("getSoldCount", []);
      setState(() {
        sold = int.parse(result[0].toString());
      });
    } catch (e) {
      print('Error in getSoldCount: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Statistic',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Pie chart representing all of your sold and bought NFTs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            //if statement in the build
            
            SfCircularChart(
              legend: Legend(isVisible: true),
              series: <CircularSeries>[
                PieSeries<CircularChartSampleData, String>(
                  dataSource: <CircularChartSampleData>[
                    CircularChartSampleData('Sold NFTs', sold),
                    CircularChartSampleData('Bought NFTs', bought),
                  ],
                  xValueMapper: (CircularChartSampleData data, _) => data.x,
                  yValueMapper: (CircularChartSampleData data, _) => data.y,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}

class CircularChartSampleData {
  CircularChartSampleData(this.x, this.y);
  final String x;
  final int y;
}
