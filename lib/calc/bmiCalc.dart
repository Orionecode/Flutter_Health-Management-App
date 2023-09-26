/* 每次点击确定计算都会调用的BMI计算类 */
import 'dart:math';

class BMICalculator {
  BMICalculator({
    required this.height,
    required this.weight,
    required this.age,
    this.waist,
    required this.gender,
  });

  final int height;
  final double weight;
  final int age;
  final int? waist;
  final int gender;

  double _bmi = 0;
  double _bf = 0;

  double calculateBMI() {
    _bmi = (weight / pow(height / 100, 2));
    return double.parse(_bmi.toStringAsFixed(1));
  }

  double calculateBF() {
    _bf = -44.988 +
        (0.503 * age) +
        (10.689 * gender) +
        (3.172 * _bmi) -
        (0.026 * _bmi * _bmi) +
        (0.181 * _bmi * gender) -
        (0.02 * _bmi * age) -
        (0.005 * _bmi * _bmi * gender) +
        (0.00021 * _bmi * _bmi * age);
    if (_bf > 0)
      return double.parse(_bf.toStringAsFixed(1));
    else
      return 0;
  }

// Body fat % = -44.988 + (0.503 * age) + (10.689 * gender) + (3.172 * BMI) - (0.026 * BMI2) + (0.181 * BMI * gender) - (0.02 * BMI * age) - (0.005 * BMI2 * gender) + (0.00021 * BMI2 * age)
}
