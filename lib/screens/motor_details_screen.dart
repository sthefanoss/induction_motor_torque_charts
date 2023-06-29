import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../helpers/base_uri.dart';
import '../main.dart';
import '../models/motor.dart';
import '../math/motor_simulation.dart';

const myRepositoryUrl = r'https://sthefanoss.github.io/#/';

class MotorDetailsScreen extends StatefulWidget {
  const MotorDetailsScreen({super.key});

  @override
  _MotorDetailsScreenState createState() => _MotorDetailsScreenState();
}

class _MotorDetailsScreenState extends State<MotorDetailsScreen> {
  late MotorSimulation _simulation;
  late List<FlSpot> _TData;
  late List<FlSpot> _T10Data;
  late List<FlSpot> _T100Data;
  late List<FlSpot> _I1Data;
  late List<FlSpot> _I2Data;
  late List<FlSpot> _ImData;
  late Motor _motor;
  bool didInit = false;

  @override
  void didChangeDependencies() {
    if (!didInit) {
      didInit = true;

      final state = GoRouterState.of(context);
      _motor = context.read<MotorsController>().motors[int.parse(state.pathParameters['index']!)];
      _simulation = MotorSimulation.compute(
        motor: _motor,
        numberOfPoints: 360,
      );
      List<FlSpot> _mapper(String key) =>
          _simulation.data.entries.map<FlSpot>((e) => FlSpot(e.key, e.value[key]!)).toList();

      _TData = _mapper('T');
      _T10Data = _mapper('T10');
      _T100Data = _mapper('T100');
      _I1Data = _mapper('I1');
      _I2Data = _mapper('I2');
      _ImData = _mapper('Im');
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_motor.name),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => ListView(
          children: [
            Divider(),
            Text(
              'Especificações do Motor',
              textAlign: TextAlign.center,
            ),
            Divider(),
            Text(
              'P = ${_motor.Pn.toStringAsFixed(0)} kW |'
              ' f = ${_motor.f} Hz |'
              ' p = ${_motor.p} |'
              ' Vl = ${_motor.Vl} V',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Divider(),
            Text(
              'Parâmetros do Modelo',
              textAlign: TextAlign.center,
            ),
            Divider(),
            Text(
              'R1 = ${_motor.R1}Ω |'
              ' X1 = ${_motor.X1}Ω |'
              ' Xm = ${_motor.Xm}Ω |'
              ' R2 = ${_motor.R2}Ω |'
              ' X2 = ${_motor.X2}Ω',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Divider(),
            Text(
              'Gráficos do Motor',
              textAlign: TextAlign.center,
            ),
            Divider(),
            buildCharts(
              constraints.maxWidth,
              [
                chartBuilder(
                  data: {
                    'T': _TData,
                    'T10%': _T10Data,
                    'Tn': _T100Data,
                  },
                  domain: 'nm',
                  domainUnity: 'rpm',
                  imageUnity: 'Nm',
                  key: 'T',
                  title: 'Curvas de Torque',
                  yTitle: 'T, T10%, T100% [Nm]',
                  xTitle: 'nm [rpm]',
                ),
                chartBuilder(
                  data: {
                    'I1': _I1Data,
                    'I2': _I2Data,
                    'Im': _ImData,
                  },
                  domain: 'nm',
                  domainUnity: 'rpm',
                  imageUnity: 'A',
                  key: 'I1',
                  title: 'Curvas de Corrente',
                  yTitle: 'I1, I2, Im [A]',
                  xTitle: 'nm [rpm]',
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: kIsWeb
          ? FloatingActionButton(
              child: Icon(Icons.share),
              onPressed: () {
                final baseUri = getBaseUri();
                final uri = Uri(path: 'share', queryParameters: _motor.toMap());

                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Compartilhar Registro'),
                          content: SelectableText(baseUri! + '#/' + uri.toString()),
                          actions: [ElevatedButton(onPressed: context.pop, child: Text('Ok'))],
                        ));
              },
            )
          : null,
    );
  }

  Widget buildCharts(double maxWidth, List charts) {
    if (maxWidth > 700)
      return Row(
        children: charts
            .map(
              (chart) => Container(
                constraints: BoxConstraints.tightFor(width: maxWidth / 2, height: maxWidth / 2),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: chart,
                ),
              ),
            )
            .toList(),
      );

    return Column(
      children: charts
          .map(
            (chart) => Container(
              constraints: BoxConstraints.tightFor(width: maxWidth * 0.85, height: maxWidth * 0.85),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: chart,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget chartBuilder({
    required Map<String, List<FlSpot>> data,
    required String key,
    required String title,
    required String xTitle,
    required String yTitle,
    required String domain,
    required String domainUnity,
    required String imageUnity,
  }) {
    double max = data[key]![0].y, min = data[key]![0].y;
    data[key]!.map((e) => e.y).forEach((v) {
      if (v > max) max = v;
      if (v < min) min = v;
    });
    final maxY = max.ceil().toDouble();
    final minY = 0.0;
    final maxX = data[key]!.last.x;
    final intervalY = ((maxY - minY) / 8).floorToDouble();
    final intervalX = (maxX / 10.0).floorToDouble();

    return LineChart(
      LineChartData(
          maxY: maxY,
          minY: minY,
          minX: 0,
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
            horizontalInterval: intervalY,
            verticalInterval: intervalX,
          ),
          //  betweenBarsData: [],
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) =>
                  const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 11),
              margin: 6,
              interval: intervalY,
            ),
            rightTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: (value) => value.toString(),
              getTextStyles: (value) => const TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              margin: 6,
              interval: intervalX,
            ),
            topTitles: SideTitles(showTitles: false),
          ),
          axisTitleData: FlAxisTitleData(
            topTitle: AxisTitle(showTitle: true, titleText: title),
            leftTitle: AxisTitle(showTitle: true, titleText: yTitle, reservedSize: 20),
            bottomTitle: AxisTitle(showTitle: true, titleText: xTitle, reservedSize: 20),
          ),
          lineBarsData: data.values
              .map((data) => LineChartBarData(
                    spots: data,
                    showingIndicators: [],
                    belowBarData: BarAreaData(
                      cutOffY: 30,
                      applyCutOffY: true,
                    ),
                    dotData: FlDotData(
                      show: false,
                    ),
                  ))
              .toList(),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((e) {
                int index = e.barIndex;

                return LineTooltipItem(
                    '${data.keys.toList()[index]}(${e.x.toStringAsFixed(0)}) = ${e.y.toStringAsFixed(2)} $imageUnity',
                    TextStyle(fontSize: 11, color: Colors.black),
                    textAlign: TextAlign.start);
              }).toList();
            }),
          )),
    );
  }
}
