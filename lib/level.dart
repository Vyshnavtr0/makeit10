import 'dart:math';
import 'dart:collection';
import 'package:expressions/expressions.dart';
import 'package:math_expressions/math_expressions.dart';

class Level {
  final List<int> numbers;
  final int goal;
  final List<int> remove;

  Level(this.numbers, this.goal, this.remove);
}

final List<Level> levels = [
  Level([1, 2, 3, 4], 10, []),
  Level([1, 1, 8, 2], 10, []),
  Level([2, 3, 5, 1], 10, []),
  Level([4, 4, 2, 1], 10, []),
  Level([6, 1, 3, 2], 10, []),
  Level([4, 9, 2, 2], 10, []),
  Level([6, 5, 4, 4], 10, []),
  Level([6, 4, 8, 3], 10, [44]),
  Level([7, 6, 9, 7], 10, []),
  Level([9, 6, 6, 8], 10, []),
  Level([6, 4, 8, 3], 10, [44, 22]),
  Level([8, 9, 3, 1], 10, [55]),
  Level([2, 9, 8, 3], 10, [55]),
  Level([0, 9, 4, 6], 10, []),
  Level([3, 3, 1, 8], 10, []),
  Level([9, 9, 6, 3], 10, [11, 66]),
  Level([0, 2, 7, 3], 10, [44, 33]),
  Level([8, 8, 3, 3], 10, [44]),
  Level([1, 9, 9, 8], 10, [33]),
  Level([7, 7, 6, 2], 10, [33]),
  Level([7, 5, 2, 6], 10, [44, 22]),
  Level([7, 2, 3, 2], 10, [44, 22]),
  Level([7, 3, 3, 9], 10, [44, 22, 55]),
  Level([2, 2, 3, 7], 10, [44, 22, 55]),
  Level([6, 7, 1, 2], 10, [55]),
  Level([9, 5, 8, 2], 10, []),
  Level([5, 9, 2, 4], 10, []),
  Level([0, 3, 8, 2], 10, []),
  Level([5, 0, 3, 5], 10, []),
  Level([1, 9, 0, 4], 10, [44, 33]),
  Level([8, 4, 3, 5], 10, [44, 33, 11, 66]),
  Level([1, 6, 5, 3], 10, [33, 22, 55]),
  Level([1, 8, 4, 5], 10, [33, 22, 55]),
  Level([2, 1, 2, 9], 10, [44, 33, 55, 11, 66]),
  Level([9, 9, 5, 2], 10, []),
  Level([9, 2, 5, 2], 10, []),
  Level([7, 9, 9, 4], 10, []),
  Level([7, 5, 9, 5], 10, []),
  Level([7, 7, 0, 9], 10, []),
  Level([6, 9, 5, 7], 10, []),
  Level([5, 7, 3, 9], 10, [22]),
  Level([9, 5, 3, 9], 10, [22]),
  Level([9, 6, 3, 9], 10, [22]),
  Level([3, 7, 1, 2], 10, [22, 44]),
  Level([8, 0, 7, 2], 10, [22, 44]),
  Level([6, 7, 2, 9], 10, [22, 44]),
  Level([7, 6, 2, 6], 10, [22, 44]),
  Level([7, 3, 2, 4], 10, [44, 55]),
  Level([5, 0, 9, 4], 10, [44, 55]),
  Level([2, 7, 5, 5], 10, [33, 44]),
  Level([2, 0, 1, 5], 10, [44, 33]),
  Level([5, 3, 5, 0], 10, [11, 22, 55, 66]),
  Level([6, 3, 0, 8], 10, [11, 66, 22, 55]),
  Level([1, 8, 6, 8], 10, [11, 66, 22, 55]),
  Level([5, 5, 1, 2], 10, [22]),
  Level([3, 8, 8, 8], 10, [11, 66, 44]),
  Level([4, 7, 7, 7], 10, [11, 66, 44]),
  Level([6, 7, 8, 2], 10, [22]),
  Level([5, 9, 1, 8], 10, [55]),
  Level([2, 5, 1, 0], 10, [55]),
  Level([2, 6, 6, 2], 10, [22]),
  Level([1, 5, 1, 0], 10, [33, 55]),
  Level([3, 3, 6, 8], 10, [33]),
  Level([3, 6, 3, 1], 10, [55]),
  Level([5, 6, 1, 7], 10, [55]),
  Level([8, 8, 8, 8], 10, [33, 44]),
  Level([1, 9, 8, 8], 10, [55]),
  Level([1, 9, 1, 9], 10, [33]),
  Level([1, 6, 5, 6], 10, [33]),
  Level([5, 5, 5, 9], 10, [33]),
  Level([6, 7, 1, 1], 10, [33]),
  Level([8, 8, 3, 1], 10, [44]),
  Level([8, 8, 1, 2], 10, [33]),
  Level([3, 5, 3, 3], 10, [33]),
  Level([4, 6, 9, 7], 10, [33, 44]),
  Level([8, 6, 1, 1], 10, [33, 44]),
  Level([8, 9, 9, 9], 10, [33, 44]),
  Level([7, 8, 1, 3], 10, [22, 55]),
  Level([6, 7, 9, 5], 10, [33, 44]),
  Level([9, 9, 9, 9], 10, [33]),
  Level([3, 5, 3, 2], 10, [22, 33, 11, 66]),
  Level([4, 4, 9, 4], 10, []),
  Level([9, 6, 9, 6], 10, [33]),
  Level([6, 6, 1, 8], 10, [11, 33, 44, 66]),
  Level([0, 7, 9, 3], 10, [11, 33, 44, 66]),
  Level([2, 1, 9, 8], 10, [11, 55, 66]),
  Level([8, 6, 5, 5], 10, [22]),
  Level([5, 7, 5, 5], 10, [11, 55, 66]),
  Level([3, 5, 9, 5], 10, [11, 22, 66]),
  Level([4, 8, 9, 8], 10, [11, 22, 66]),
  Level([8, 6, 9, 8], 10, [11, 22, 55, 66]),
  Level([2, 4, 7, 3], 10, [11, 55, 44, 66]),
  Level([4, 1, 6, 5], 10, [11, 55, 22, 66]),
  Level([8, 2, 2, 9], 10, [22]),
  Level([5, 8, 2, 3], 10, [22]),
  Level([3, 4, 7, 8], 10, [22]),
  Level([9, 5, 6, 6], 10, [22]),
  Level([7, 6, 4, 4], 10, [22]),
  Level([5, 3, 3, 7], 10, [22]),
  Level([5, 1, 8, 1], 10, [22]),
];


bool findSolution(
  List<int> numbers,
  int goal, {
  List<String> solutions = const [],
  bool allowAddition = true,
  bool allowSubtraction = true,
  bool allowMultiplication = true,
  bool allowDivision = true,
  bool allowParentheses = true,
}) {
  List<String> nums = numbers.map((e) => e.toString()).toList();
  List<List<String>> comb = combinations(nums);
  double bestGuessMath = 9999;
  String bestGuessAns = "";
  String printBest = '';
  List<String> oprs = [];
  if (allowAddition) oprs.add('+');
  if (allowSubtraction) oprs.add('-');
  if (allowMultiplication) oprs.add('*');
  if (allowDivision) oprs.add('/');

  bool found = false;

  for (int x = 0; x < comb.length; x++) {
    String ans = '';
    for (int i = 0; i < oprs.length; i++) {
      for (int j = 0; j < oprs.length; j++) {
        for (int k = 0; k < oprs.length; k++) {
          for (int l = 0; l < nums.length; l++) {
            ans += comb[x][l];
            if (l == 0) ans += oprs[i];
            if (l == 1) ans += oprs[j];
            if (l == 2) ans += oprs[k];
          }
          List<String> split = ans.split('');
          List<String> parenCombinations = allowParentheses
              ? [
                  '',
                  '(a+b)c+d',
                  '(a+b+c)+d',
                  '(a+b)+(c+d)',
                  'a+(b+c)+d',
                  'a+((b+c)+d)'
                ]
              : [''];

          for (String parenCombo in parenCombinations) {
            String expression = applyParentheses(ans, parenCombo);
            double mathAns;
            try {
              mathAns = evaluateExpression(expression);
            } catch (e) {
              mathAns = double.infinity;
            }
            String printAns = expression
                .replaceAll('-', '–')
                .replaceAll('*', '×')
                .replaceAll('/', '÷');
            String print = '$printAns=${mathAns.toStringAsFixed(2)}';
            if (mathAns == goal) {
              solutions.add(print);
              found = true;
            }
            if ((mathAns - goal).abs() < (bestGuessMath - goal).abs()) {
              bestGuessMath = mathAns;
              bestGuessAns = printAns;
            }
          }
          ans = '';
        }
      }
    }
  }

  printBest = '$bestGuessAns=${(bestGuessMath * 100).round() / 100}';
  if (!found) {
    solutions.add('No exact solution found. Closest: $printBest');
  }

  return found;
}

String applyParentheses(String expression, String parenCombo) {
  List<String> parts = expression.split(RegExp(r'([+\-*/])'));
  if (parts.length != 4) return expression;

  switch (parenCombo) {
    case '(a+b)c+d':
      return '(${parts[0]}${expression[1]}${parts[1]})${expression[3]}${parts[2]}${expression[5]}${parts[3]}';
    case '(a+b+c)+d':
      return '(${parts[0]}${expression[1]}${parts[1]}${expression[3]}${parts[2]})${expression[5]}${parts[3]}';
    case '(a+b)+(c+d)':
      return '(${parts[0]}${expression[1]}${parts[1]})${expression[3]}(${parts[2]}${expression[5]}${parts[3]})';
    case 'a+(b+c)+d':
      return '${parts[0]}${expression[1]}(${parts[1]}${expression[3]}${parts[2]})${expression[5]}${parts[3]}';
    case 'a+((b+c)+d)':
      return '${parts[0]}${expression[1]}((${parts[1]}${expression[3]}${parts[2]})${expression[5]}${parts[3]})';
    default:
      return expression;
  }
}

double evaluateExpression(String expression) {
  // This is a simple implementation and might not handle all cases
  // You may want to use a more robust expression evaluator
  return eval(expression);
}

double eval(String expression) {
  expression = expression.replaceAll(' ', '');
  List<String> tokens = tokenize(expression);
  List<String> postfix = infixToPostfix(tokens);
  return evaluatePostfix(postfix);
}

List<String> tokenize(String expression) {
  RegExp regex = RegExp(r'(\d+\.?\d*|\+|\-|\*|\/|\(|\))');
  return regex.allMatches(expression).map((m) => m.group(0)!).toList();
}

List<String> infixToPostfix(List<String> infix) {
  Map<String, int> precedence = {'+': 1, '-': 1, '*': 2, '/': 2};
  List<String> operators = [];
  List<String> postfix = [];

  for (String token in infix) {
    if (double.tryParse(token) != null) {
      postfix.add(token);
    } else if (token == '(') {
      operators.add(token);
    } else if (token == ')') {
      while (operators.isNotEmpty && operators.last != '(') {
        postfix.add(operators.removeLast());
      }
      if (operators.isNotEmpty && operators.last == '(') {
        operators.removeLast();
      }
    } else {
      while (operators.isNotEmpty &&
          operators.last != '(' &&
          precedence[operators.last]! >= precedence[token]!) {
        postfix.add(operators.removeLast());
      }
      operators.add(token);
    }
  }

  while (operators.isNotEmpty) {
    postfix.add(operators.removeLast());
  }

  return postfix;
}

double evaluatePostfix(List<String> postfix) {
  List<double> stack = [];

  for (String token in postfix) {
    if (double.tryParse(token) != null) {
      stack.add(double.parse(token));
    } else {
      double b = stack.removeLast();
      double a = stack.removeLast();
      switch (token) {
        case '+':
          stack.add(a + b);
          break;
        case '-':
          stack.add(a - b);
          break;
        case '*':
          stack.add(a * b);
          break;
        case '/':
          stack.add(a / b);
          break;
      }
    }
  }

  return stack.first;
}

List<List<String>> combinations(List<String> arr) {
  if (arr.isEmpty) return [[]];
  List<List<String>> result = [];
  for (int i = 0; i < arr.length; i++) {
    var rest = [...arr.sublist(0, i), ...arr.sublist(i + 1)];
    var combs = combinations(rest);
    combs.forEach((comb) => result.add([arr[i], ...comb]));
  }
  return result;
}
