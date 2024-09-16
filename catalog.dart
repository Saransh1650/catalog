import 'dart:convert';
import 'dart:io';
import 'dart:math';

// Point class to represent (x, y) pairs
class Point {
  final BigInt x, y;

  Point(this.x, this.y);
}

// Lagrange Interpolation to compute f(0)
BigInt lagrangeInterpolation(List<Point> points) {
  BigInt result = BigInt.zero;
  int n = points.length;

  // Compute the Lagrange interpolation at x = 0
  for (int i = 0; i < n; i++) {
    BigInt xi = points[i].x;
    BigInt yi = points[i].y;

    // Calculate the Lagrange basis polynomial l_i(0)
    BigInt numerator = BigInt.one;
    BigInt denominator = BigInt.one;

    for (int j = 0; j < n; j++) {
      if (i != j) {
        BigInt xj = points[j].x;
        numerator *= -xj; // l_i(0) = product of (0 - xj)
        denominator *= xi - xj; // xi - xj
      }
    }

    // yi * (numerator / denominator) contributes to the result
    BigInt term = yi * (numerator ~/ denominator);
    result += term; // Accumulate the result
  }

  return result;
}

// Parse JSON and solve for the constant term
void parseJsonAndSolve(String inputJson) {
  var json = jsonDecode(inputJson);

  // Extract the "keys" section (n and k)
  var keys = json['keys'];
  int n = keys['n'];
  int k = keys['k'];

  // Extract points (x, base, and value)
  List<Point> points = [];
  json.forEach((key, value) {
    if (key == 'keys') return;

    int base = int.parse(value['base']);
    String valueStr = value['value'];
    BigInt y = BigInt.parse(valueStr, radix: base);
    BigInt x = BigInt.parse(key);

    points.add(Point(x, y));
  });

  // Ensure we have enough points to solve the polynomial
  if (points.length < k) {
    print("Not enough points to solve the polynomial.");
    return;
  }

  // Perform Lagrange interpolation to find the constant term (f(0))
  BigInt constantTerm = lagrangeInterpolation(points);

  // Output the constant term
  print("Constant term of the polynomial: $constantTerm");
}

void main() {
  // Prompt user for JSON input
  print("Please enter the JSON input:");

  // Read JSON input from user
  String? inputJson = stdin.readLineSync();

  if (inputJson != null && inputJson.isNotEmpty) {
    // Call the method to parse JSON and compute the constant term
    parseJsonAndSolve(inputJson);
  } else {
    print("Invalid input. Please provide a valid JSON string.");
  }
}
