import '../math/unit_convertions.dart';

class Motor {
  final String name;
  final num R1;
  final num R2;
  final num X1;
  final num X2;
  final num Xm;
  final num Vl;
  final int p;
  final num f;
  final num Pn;

  const Motor({
    required this.name,
    required this.R1,
    required this.R2,
    required this.X1,
    required this.X2,
    required this.Xm,
    required this.Vl,
    required this.p,
    required this.f,
    required this.Pn,
  });

  static const list = [
    Motor(
      name: 'Motor de 3hp',
      Pn: 3 * hpToKw,
      Vl: 220,
      f: 60,
      p: 4,
      R1: 0.435,
      X1: 0.754,
      Xm: 26.13,
      R2: 0.816,
      X2: 0.754,
    ),
    Motor(
      name: 'Motor de 50hp ',
      Pn: 50 * hpToKw,
      Vl: 460,
      f: 60,
      p: 4,
      R1: 0.087,
      X1: 0.302,
      Xm: 13.08,
      R2: 0.228,
      X2: 0.302,
    ),
    Motor(
      name: 'Motor de 500hp ',
      Pn: 500 * hpToKw,
      Vl: 2300,
      f: 60,
      p: 4,
      R1: 0.262,
      X1: 1.206,
      Xm: 54.02,
      R2: 0.187,
      X2: 1.206,
    ),
    Motor(
      name: 'Motor de 2250hp ',
      Pn: 2250 * hpToKw,
      Vl: 2300,
      f: 60,
      p: 4,
      R1: 0.029,
      X1: 0.226,
      Xm: 13.04,
      R2: 0.022,
      X2: 0.226,
    ),
  ];
}
