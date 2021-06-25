import 'dart:math';

class Complex {
  final num real;
  final num imaginary;

  const Complex(this.real, [this.imaginary = 0]);

  Complex.polar(double radius, double angle)
      : real = radius * cos(angle),
        imaginary = radius * sin(angle);

  Complex get conjugate => Complex(real, -imaginary);

  String toString() => '${real.toString()}  ${imaginary.toString()} j';
  String toStringAsPolar() => '|${radius.toString()}|∠${angle.toString()}°';

  double get radius => sqrt(real * real + imaginary * imaginary);

  double get angle => atan2(imaginary, real);

  Complex operator +(Complex other) {
    return Complex(
      this.real + other.real,
      this.imaginary + other.imaginary,
    );
  }

  Complex operator -() {
    return Complex(
      -this.real,
      -this.imaginary,
    );
  }

  Complex operator -(Complex other) {
    return this + (-other);
  }

  Complex operator *(Complex other) {
    return Complex(
      real * other.real - imaginary * other.imaginary,
      imaginary * other.real + real * other.imaginary,
    );
  }

  Complex operator /(Complex other) {
    num div = other.real * other.real + other.imaginary * other.imaginary;
    return Complex(
      (real * other.real + imaginary * other.imaginary) / div,
      (imaginary * other.real - real * other.imaginary) / div,
    );
  }
}
