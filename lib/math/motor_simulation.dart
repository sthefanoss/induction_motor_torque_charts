import 'dart:math';
import 'complex_math.dart';
import '../models/motor.dart';

class MotorSimulation {
  final Motor motor;
  final Map<double, Map<String, double>> data;

  const MotorSimulation._({
    required this.motor,
    required this.data,
  });

  factory MotorSimulation.compute({
    required Motor motor,
    required int numberOfPoints,
  }) {
    List<T> _generate<T>(T generator(int i)) {
      return List<T>.generate(numberOfPoints, generator);
    }

    final Vf = Complex(motor.Vl / sqrt(3));
    final ns = 120 * motor.f / motor.p;
    final ws = 2 * pi * ns / motor.f;
    final Tn = motor.Pn / ws;

    double dnm = ns / (numberOfPoints - 1);
    final nm = _generate<double>((i) => i * dnm);
    final s = _generate<double>((i) => (ns - nm[i]) / ns);
    final R2s = _generate<double>((i) => motor.R2 / s[i]);

    final Z1 = Complex(motor.R1, motor.X1);
    final Zm = Complex(0, motor.Xm);
    final Z2s = _generate<Complex>((i) => Complex(R2s[i], motor.X2));
    final Zeqs = _generate<Complex>((i) => Z1 + parallel(Zm, Z2s[i]));
    final I1 = _generate<Complex>((i) => Vf / Zeqs[i]);
    final E1 = _generate<Complex>((i) => Vf - I1[i] * Z1);
    final I2 = _generate<Complex>((i) => E1[i] / Z2s[i]);

    final Pag = _generate<double>((i) => 3 * pow(I2[i].radius, 2) * R2s[i]);
    final T = _generate<double>((i) => Pag[i] / ws);
    final data = <double, Map<String, double>>{};
    for (int i = 0; i < numberOfPoints; i++)
      data[nm[i]] = {
        'I1': I1[i].radius,
        'I2': I2[i].radius,
        'Im': (I1[i] - I2[i]).radius,
        'T': T[i],
        'T10': Tn * 0.1,
        'T100': Tn,
      };

    return MotorSimulation._(
      motor: motor,
      data: data,
    );
  }

  static Complex parallel(Complex Za, Complex Zb) {
    return (Za * Zb) / (Za + Zb);
  }
}
