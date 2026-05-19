import 'package:coderecall/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeedService {
  static const String _isSeededKey = 'is_seeded';

  static Future<bool> isSeeded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isSeededKey) ?? false;
  }

  static Future<void> seedAll() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    await db.transaction((txn) async {
      await _seedQuestions(txn);
      await _seedBadges(txn);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isSeededKey, true);
  }

  static Future<void> _seedQuestions(Transaction txn) async {
    // === JAVA QUESTIONS (50) ===
    final javaQuestions = [
      // Variables - 6
      {
        'language': 'java', 'type': 'mcq', 'topic': 'variables', 'difficulty': 'easy',
        'question_text': 'Which keyword is used to declare an integer variable in Java?',
        'code_snippet': null,
        'option_a': 'int', 'option_b': 'integer', 'option_c': 'var', 'option_d': 'num',
        'correct_answer': 'A', 'explanation': 'Java uses the lowercase keyword int to declare integer primitive variables. integer is not a Java keyword. var was added in Java 10 for local type inference but is not the traditional keyword. num does not exist in Java.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'variables', 'difficulty': 'easy',
        'question_text': 'What is the default value of an instance variable of type int in Java?',
        'code_snippet': null,
        'option_a': '0', 'option_b': '1', 'option_c': 'null', 'option_d': '-1',
        'correct_answer': 'A', 'explanation': 'Java initializes numeric instance variables to 0 by default. null is the default for object references, not primitives. There is no default of 1 or -1.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'variables', 'difficulty': 'medium',
        'question_text': 'What happens if you declare a local variable but do not initialize it before use?',
        'code_snippet': null,
        'option_a': 'Compiler error', 'option_b': 'It defaults to 0', 'option_c': 'It defaults to null', 'option_d': 'It defaults to garbage value',
        'correct_answer': 'A', 'explanation': 'Java requires local variables to be explicitly initialized before use. The compiler will reject the code. Unlike instance variables, local variables get no default value.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'fillblank', 'topic': 'variables', 'difficulty': 'easy',
        'question_text': 'Complete the declaration: ___ score = 95;',
        'code_snippet': null,
        'option_a': 'int', 'option_b': 'String', 'option_c': 'boolean', 'option_d': 'double',
        'correct_answer': 'A', 'explanation': '95 is an integer literal, so int is the correct type. String requires quotes. boolean only accepts true/false. double would work but is not the best fit for a whole number.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'variables', 'difficulty': 'medium',
        'question_text': 'Which of the following is NOT a valid variable name in Java?',
        'code_snippet': null,
        'option_a': '_name', 'option_b': '\$value', 'option_c': '2count', 'option_d': 'myVar',
        'correct_answer': 'C', 'explanation': 'Java variable names cannot start with a digit. 2count is invalid. Variables can start with an underscore _, a dollar sign \$, or a letter.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'variables', 'difficulty': 'hard',
        'question_text': 'What is the output of: System.out.println(012);',
        'code_snippet': null,
        'option_a': '12', 'option_b': '10', 'option_c': '012', 'option_d': 'Compiler error',
        'correct_answer': 'B', 'explanation': 'In Java, a leading 0 denotes an octal (base-8) literal. 012 in octal equals 1x8 + 2 = 10 in decimal.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // Data Types - 5
      {
        'language': 'java', 'type': 'mcq', 'topic': 'data_types', 'difficulty': 'easy',
        'question_text': 'What is the size of the char data type in Java?',
        'code_snippet': null,
        'option_a': '1 byte', 'option_b': '2 bytes', 'option_c': '4 bytes', 'option_d': '8 bytes',
        'correct_answer': 'B', 'explanation': 'Java char is 2 bytes (16 bits) because it uses Unicode (UTF-16). This differs from C/C++ where char is typically 1 byte.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'data_types', 'difficulty': 'easy',
        'question_text': 'Which data type should be used to store a decimal value like 3.14?',
        'code_snippet': null,
        'option_a': 'int', 'option_b': 'char', 'option_c': 'double', 'option_d': 'boolean',
        'correct_answer': 'C', 'explanation': 'double is the default floating-point type in Java. int stores whole numbers. char stores single characters. boolean stores true/false.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'data_types', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int a = 5 / 2;\nSystem.out.println(a);',
        'option_a': '2.5', 'option_b': '2', 'option_c': '3', 'option_d': 'Compiler error',
        'correct_answer': 'B', 'explanation': 'Integer division in Java truncates the decimal portion. 5 / 2 equals 2, not 2.5. To get 2.5, at least one operand must be a floating-point: 5.0 / 2.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'data_types', 'difficulty': 'medium',
        'question_text': 'What is the range of the byte data type in Java?',
        'code_snippet': null,
        'option_a': '0 to 255', 'option_b': '-128 to 127', 'option_c': '-256 to 255', 'option_d': '-32768 to 32767',
        'correct_answer': 'B', 'explanation': 'Java byte is a signed 8-bit type, ranging from -128 to 127. Unlike C where char might be unsigned, Java numeric types are always signed (except char).',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'data_types', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'double d = 1.0 / 0.0;\nSystem.out.println(d);',
        'option_a': '0', 'option_b': 'Infinity', 'option_c': 'NaN', 'option_d': 'ArithmeticException',
        'correct_answer': 'B', 'explanation': 'Floating-point division by zero in Java does NOT throw an exception. Instead, 1.0 / 0.0 produces Double.POSITIVE_INFINITY, which prints as Infinity.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // Operators - 5
      {
        'language': 'java', 'type': 'mcq', 'topic': 'operators', 'difficulty': 'easy',
        'question_text': 'What does the != operator check?',
        'code_snippet': null,
        'option_a': 'Equality', 'option_b': 'Inequality', 'option_c': 'Assignment', 'option_d': 'Negation',
        'correct_answer': 'B', 'explanation': '!= is the "not equal to" operator in Java. == checks equality. = is assignment. ! is logical negation on a boolean.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'operators', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int x = 5;\nSystem.out.println(x++ + ++x);',
        'option_a': '10', 'option_b': '11', 'option_c': '12', 'option_d': '13',
        'correct_answer': 'C', 'explanation': 'x++ uses x (5) then increments to 6. ++x increments to 7 then uses x (7). So 5 + 7 = 12.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'operators', 'difficulty': 'easy',
        'question_text': 'What is the result of 10 % 3 in Java?',
        'code_snippet': null,
        'option_a': '3', 'option_b': '1', 'option_c': '0', 'option_d': '3.33',
        'correct_answer': 'B', 'explanation': 'The % (modulo) operator returns the remainder of integer division. 10 / 3 = 3 with a remainder of 1. So 10 % 3 = 1.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'operators', 'difficulty': 'medium',
        'question_text': 'What does boolean result = (5 > 3) && (2 < 1); evaluate to?',
        'code_snippet': null,
        'option_a': 'true', 'option_b': 'false', 'option_c': 'Compiler error', 'option_d': 'null',
        'correct_answer': 'B', 'explanation': '(5 > 3) is true, but (2 < 1) is false. && (AND) returns true only if BOTH operands are true. So true && false = false.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'operators', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int a = 10;\na += a -= a;\nSystem.out.println(a);',
        'option_a': '0', 'option_b': '10', 'option_c': '-10', 'option_d': '20',
        'correct_answer': 'A', 'explanation': 'Right-to-left: a -= a sets a to 0 and returns 0. Then a += 0 gives a = 0 + 0 = 0.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // Conditionals - 5
      {
        'language': 'java', 'type': 'mcq', 'topic': 'conditionals', 'difficulty': 'easy',
        'question_text': 'Which statement is used to execute code only when a condition is true?',
        'code_snippet': null,
        'option_a': 'for', 'option_b': 'if', 'option_c': 'while', 'option_d': 'switch',
        'correct_answer': 'B', 'explanation': 'The if statement executes its block only when the condition evaluates to true. for and while are loops. switch is for multi-way branching.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'conditionals', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int x = 15;\nif (x > 10) {\n    System.out.println("A");\n} else if (x > 5) {\n    System.out.println("B");\n} else {\n    System.out.println("C");\n}',
        'option_a': 'A', 'option_b': 'B', 'option_c': 'C', 'option_d': 'AB',
        'correct_answer': 'A', 'explanation': 'Since x = 15 > 10, the first if condition is true, so "A" is printed. The else if and else blocks are skipped entirely once a match is found.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'conditionals', 'difficulty': 'medium',
        'question_text': 'Can a switch statement in Java use a String as the expression?',
        'code_snippet': null,
        'option_a': 'Yes, since Java 7', 'option_b': 'No, only int and char', 'option_c': 'Yes, since Java 1', 'option_d': 'Only in Java 17+',
        'correct_answer': 'A', 'explanation': 'Java 7 introduced support for String in switch statements. Before that, only byte, short, char, int, and enums were allowed.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'conditionals', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int a = 5;\nSystem.out.println(a > 3 ? "yes" : "no");',
        'option_a': 'yes', 'option_b': 'no', 'option_c': 'true', 'option_d': 'Compiler error',
        'correct_answer': 'A', 'explanation': 'The ternary operator condition ? val1 : val2 returns val1 if the condition is true, else val2. Since 5 > 3 is true, it returns "yes".',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'fillblank', 'topic': 'conditionals', 'difficulty': 'easy',
        'question_text': 'Complete the conditional:\n\n___ (score >= 90) { grade = \'A\'; }',
        'code_snippet': null,
        'option_a': 'if', 'option_b': 'for', 'option_c': 'while', 'option_d': 'switch',
        'correct_answer': 'A', 'explanation': 'if is the keyword used to begin a conditional block. for and while are loop constructs. switch doesn\'t use a boolean expression in parentheses.',
        'xp_reward': 5, 'is_seeded': 1
      },
      // Loops - 6
      {
        'language': 'java', 'type': 'output', 'topic': 'loops', 'difficulty': 'easy',
        'question_text': 'What does this print?',
        'code_snippet': 'for (int i = 0; i < 3; i++) {\n    System.out.print(i);\n}',
        'option_a': '012', 'option_b': '123', 'option_c': '0 1 2', 'option_d': '0123',
        'correct_answer': 'A', 'explanation': 'The loop starts at i = 0, runs while i < 3, and prints 0, 1, 2 without newlines. The loop stops before i = 3.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'loops', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int i = 0;\nwhile (i < 5) {\n    i += 2;\n}\nSystem.out.println(i);',
        'option_a': '4', 'option_b': '5', 'option_c': '6', 'option_d': 'Infinite loop',
        'correct_answer': 'C', 'explanation': 'i starts at 0, becomes 2, 4, 6. When i=6, the condition 6 < 5 is false, so the loop stops. Final value printed is 6.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'loops', 'difficulty': 'easy',
        'question_text': 'Which keyword immediately exits a loop in Java?',
        'code_snippet': null,
        'option_a': 'exit', 'option_b': 'break', 'option_c': 'return', 'option_d': 'stop',
        'correct_answer': 'B', 'explanation': 'break immediately exits the innermost loop. return exits the entire method. exit and stop are not Java loop control keywords.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'loops', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'for (int i = 1; i <= 3; i++) {\n    for (int j = 1; j <= i; j++) {\n        System.out.print("*");\n    }\n    System.out.println();\n}',
        'option_a': '*\n**\n***', 'option_b': '***\n**\n*', 'option_c': '*\n*\n*', 'option_d': '***\n***\n***',
        'correct_answer': 'A', 'explanation': 'The outer loop runs i=1,2,3. The inner loop prints i stars per row. Row 1: *, Row 2: **, Row 3: ***.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'loops', 'difficulty': 'medium',
        'question_text': 'What does continue do inside a for loop?',
        'code_snippet': null,
        'option_a': 'Exits the loop', 'option_b': 'Skips the rest of the current iteration and moves to the next', 'option_c': 'Restarts the loop from the beginning', 'option_d': 'Ends the program',
        'correct_answer': 'B', 'explanation': 'continue skips the remaining code in the current iteration and jumps to the update expression (e.g., i++), then checks the condition again.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'loops', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int sum = 0;\nfor (int i = 1; i <= 10; i++) {\n    if (i % 2 == 0) continue;\n    sum += i;\n}\nSystem.out.println(sum);',
        'option_a': '30', 'option_b': '25', 'option_c': '55', 'option_d': '20',
        'correct_answer': 'B', 'explanation': 'The loop adds only odd numbers (1, 3, 5, 7, 9) because even numbers are skipped by continue. Sum = 1+3+5+7+9 = 25.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // Arrays - 6
      {
        'language': 'java', 'type': 'mcq', 'topic': 'arrays', 'difficulty': 'easy',
        'question_text': 'What is the index of the first element in a Java array?',
        'code_snippet': null,
        'option_a': '1', 'option_b': '0', 'option_c': '-1', 'option_d': 'Depends on array size',
        'correct_answer': 'B', 'explanation': 'Java arrays are zero-indexed. The first element is at index 0, and the last is at length - 1.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'arrays', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int[] arr = {10, 20, 30, 40, 50};\nSystem.out.println(arr[2]);',
        'option_a': '10', 'option_b': '20', 'option_c': '30', 'option_d': '40',
        'correct_answer': 'C', 'explanation': 'Arrays are zero-indexed: arr[0]=10, arr[1]=20, arr[2]=30. So arr[2] prints 30.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'arrays', 'difficulty': 'easy',
        'question_text': 'How do you get the length of an array arr in Java?',
        'code_snippet': null,
        'option_a': 'arr.length()', 'option_b': 'arr.length', 'option_c': 'arr.size()', 'option_d': 'arr.count',
        'correct_answer': 'B', 'explanation': 'Arrays in Java have a length property (not a method). length() is for Strings. size() is for Collections like ArrayList.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'arrays', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int[] a = {1, 2, 3};\nint[] b = a;\nb[0] = 99;\nSystem.out.println(a[0]);',
        'option_a': '1', 'option_b': '99', 'option_c': '0', 'option_d': 'Compiler error',
        'correct_answer': 'B', 'explanation': 'In Java, arrays are reference types. b = a makes b point to the same array object as a. Modifying b[0] also changes a[0].',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'fillblank', 'topic': 'arrays', 'difficulty': 'easy',
        'question_text': 'Complete the array declaration: int[] nums = ___ int[5];',
        'code_snippet': null,
        'option_a': 'new', 'option_b': 'create', 'option_c': 'make', 'option_d': 'init',
        'correct_answer': 'A', 'explanation': 'The new keyword is used to allocate memory for arrays in Java: new int[5] creates an array of 5 integers, all initialized to 0.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'arrays', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int[] arr = new int[3];\narr[0] = 5;\nSystem.out.println(arr[1]);',
        'option_a': '5', 'option_b': '0', 'option_c': 'null', 'option_d': 'Garbage value',
        'correct_answer': 'B', 'explanation': 'new int[3] initializes all elements to 0 (default for int). Only arr[0] is set to 5. arr[1] remains 0.',
        'xp_reward': 10, 'is_seeded': 1
      },
      // Methods - 5
      {
        'language': 'java', 'type': 'mcq', 'topic': 'methods', 'difficulty': 'easy',
        'question_text': 'What keyword specifies that a method does not return a value?',
        'code_snippet': null,
        'option_a': 'null', 'option_b': 'void', 'option_c': 'none', 'option_d': 'empty',
        'correct_answer': 'B', 'explanation': 'void is the return type that indicates a method returns nothing. null is a value for reference types.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'methods', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'static int add(int a, int b) { return a + b; }\npublic static void main(String[] args) {\n    System.out.println(add(3, 4));\n}',
        'option_a': '34', 'option_b': '7', 'option_c': '3 + 4', 'option_d': 'Compiler error',
        'correct_answer': 'B', 'explanation': 'The add method returns the sum of two integers. add(3, 4) returns 7, which is printed.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'methods', 'difficulty': 'medium',
        'question_text': 'What is method overloading in Java?',
        'code_snippet': null,
        'option_a': 'Having multiple methods with the same name but different parameters', 'option_b': 'A method calling itself', 'option_c': 'Overriding a parent class method', 'option_d': 'Having one method with multiple return types',
        'correct_answer': 'A', 'explanation': 'Method overloading means defining multiple methods with the same name in the same class, but with different parameter lists.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'fillblank', 'topic': 'methods', 'difficulty': 'easy',
        'question_text': 'Complete the method signature:\n\n___ int multiply(int a, int b) { return a * b; }',
        'code_snippet': null,
        'option_a': 'static', 'option_b': 'class', 'option_c': 'new', 'option_d': 'return',
        'correct_answer': 'A', 'explanation': 'static allows the method to be called without creating an instance of the class.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'methods', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'static int mystery(int n) {\n    if (n <= 1) return 1;\n    return n * mystery(n - 1);\n}\npublic static void main(String[] args) {\n    System.out.println(mystery(5));\n}',
        'option_a': '25', 'option_b': '120', 'option_c': '24', 'option_d': 'StackOverflowError',
        'correct_answer': 'B', 'explanation': 'This is a recursive factorial function. mystery(5) = 5 x 4 x 3 x 2 x 1 = 120.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // OOP - 7
      {
        'language': 'java', 'type': 'mcq', 'topic': 'oop', 'difficulty': 'easy',
        'question_text': 'Which keyword is used to create a class in Java?',
        'code_snippet': null,
        'option_a': 'struct', 'option_b': 'class', 'option_c': 'object', 'option_d': 'define',
        'correct_answer': 'B', 'explanation': 'class is the Java keyword for defining a class. struct is used in C/C++ but not Java.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'oop', 'difficulty': 'easy',
        'question_text': 'What is the default value of a boolean instance variable in Java?',
        'code_snippet': null,
        'option_a': 'true', 'option_b': 'false', 'option_c': 'null', 'option_d': '0',
        'correct_answer': 'B', 'explanation': 'Java initializes boolean instance variables to false. Primitive booleans cannot be null.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'oop', 'difficulty': 'medium',
        'question_text': 'What does the this keyword refer to in Java?',
        'code_snippet': null,
        'option_a': 'The parent class', 'option_b': 'The current object', 'option_c': 'The class name', 'option_d': 'The method name',
        'correct_answer': 'B', 'explanation': 'this refers to the current instance of the class. It is used to distinguish instance variables from parameters.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'oop', 'difficulty': 'medium',
        'question_text': 'Which access modifier makes a member accessible only within its own class?',
        'code_snippet': null,
        'option_a': 'public', 'option_b': 'protected', 'option_c': 'private', 'option_d': 'default',
        'correct_answer': 'C', 'explanation': 'private restricts access to the same class only. public allows access from anywhere. protected allows access within the package and subclasses.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'oop', 'difficulty': 'medium',
        'question_text': 'What is inheritance in Java?',
        'code_snippet': null,
        'option_a': 'A class acquiring properties and methods of another class', 'option_b': 'A class hiding its data', 'option_c': 'Multiple methods with the same name', 'option_d': 'Combining data and methods into one unit',
        'correct_answer': 'A', 'explanation': 'Inheritance is when a subclass (child) acquires fields and methods from a superclass (parent) using the extends keyword.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'fillblank', 'topic': 'oop', 'difficulty': 'medium',
        'question_text': 'Complete the class inheritance:\n\nclass Dog ___ Animal { }',
        'code_snippet': null,
        'option_a': 'extends', 'option_b': 'implements', 'option_c': 'inherits', 'option_d': 'from',
        'correct_answer': 'A', 'explanation': 'Java uses extends for class inheritance (one class extending another). implements is used for interfaces.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'oop', 'difficulty': 'hard',
        'question_text': 'Can a Java class extend more than one class (multiple inheritance)?',
        'code_snippet': null,
        'option_a': 'Yes, always', 'option_b': 'No, Java does not support multiple inheritance of classes', 'option_c': 'Yes, but only with the multi keyword', 'option_d': 'Only from Java 11 onwards',
        'correct_answer': 'B', 'explanation': 'Java deliberately avoids multiple inheritance of classes to prevent the "diamond problem". A class can only extend one class, but it can implement multiple interfaces.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // Exceptions - 5
      {
        'language': 'java', 'type': 'mcq', 'topic': 'exceptions', 'difficulty': 'easy',
        'question_text': 'Which block is used to handle exceptions in Java?',
        'code_snippet': null,
        'option_a': 'handle', 'option_b': 'catch', 'option_c': 'error', 'option_d': 'fix',
        'correct_answer': 'B', 'explanation': 'try-catch is the exception handling mechanism in Java. Code that might throw an exception goes in try, and the handling goes in catch.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'exceptions', 'difficulty': 'easy',
        'question_text': 'Which of these is a checked exception?',
        'code_snippet': null,
        'option_a': 'NullPointerException', 'option_b': 'IOException', 'option_c': 'ArithmeticException', 'option_d': 'ArrayIndexOutOfBoundsException',
        'correct_answer': 'B', 'explanation': 'IOException is a checked exception (must be caught or declared). The others are unchecked (extend RuntimeException).',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'fillblank', 'topic': 'exceptions', 'difficulty': 'medium',
        'question_text': 'Complete the exception handling:\n\n___ {\n    int x = 10 / 0;\n} ___ (ArithmeticException e) {\n    System.out.println("Error");\n}',
        'code_snippet': null,
        'option_a': 'try / catch', 'option_b': 'catch / try', 'option_c': 'throw / catch', 'option_d': 'if / else',
        'correct_answer': 'A', 'explanation': 'The try block wraps code that may throw an exception. The catch block handles the specific exception type if it occurs.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'exceptions', 'difficulty': 'medium',
        'question_text': 'What does the finally block do?',
        'code_snippet': null,
        'option_a': 'Runs only if an exception occurs', 'option_b': 'Runs only if no exception occurs', 'option_c': 'Always runs regardless of whether an exception occurred', 'option_d': 'Ends the program',
        'correct_answer': 'C', 'explanation': 'The finally block always executes, whether an exception was caught or not, or even if a return statement was hit.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'exceptions', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'try {\n    int[] arr = new int[2];\n    arr[5] = 10;\n} catch (ArrayIndexOutOfBoundsException e) {\n    System.out.println("A");\n} catch (Exception e) {\n    System.out.println("B");\n} finally {\n    System.out.println("C");\n}',
        'option_a': 'A then C', 'option_b': 'B then C', 'option_c': 'A only', 'option_d': 'C only',
        'correct_answer': 'A', 'explanation': 'Accessing arr[5] on a size-2 array throws ArrayIndexOutOfBoundsException. The first matching catch block ("A") runs. Then finally always runs ("C").',
        'xp_reward': 20, 'is_seeded': 1
      },
      // Variables - more
      {
        'language': 'java', 'type': 'output', 'topic': 'variables', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int x = 10;\n{\n    int x = 20;\n    System.out.print(x);\n}\nSystem.out.print(x);',
        'option_a': '2010', 'option_b': '1020', 'option_c': '2020', 'option_d': 'Compiler error',
        'correct_answer': 'D', 'explanation': 'You cannot declare a local variable with the same name x in the same scope (the inner block is still within the method\'s scope). This causes a compiler error due to variable shadowing within the same method scope.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'variables', 'difficulty': 'medium',
        'question_text': 'Which of these is a valid declaration and initialization?',
        'code_snippet': null,
        'option_a': 'int a = b = c = 10;', 'option_b': 'int a, b, c = 10;', 'option_c': 'int a = 10, b = 10;', 'option_d': 'a = 10; int b;',
        'correct_answer': 'C', 'explanation': 'int a = 10, b = 10; is valid - it declares two variables and initializes both. Option A is invalid because b and c are not declared. Option B declares three but only initializes c. Option D assigns a before declaring it.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'variables', 'difficulty': 'easy',
        'question_text': 'What does this print?',
        'code_snippet': 'final int x = 5;\nx = 10;\nSystem.out.println(x);',
        'option_a': '5', 'option_b': '10', 'option_c': 'Compiler error', 'option_d': '0',
        'correct_answer': 'C', 'explanation': 'The final keyword makes x a constant that cannot be reassigned. Attempting to assign x = 10 causes a compiler error.',
        'xp_reward': 5, 'is_seeded': 1
      },
      // Data Types - more
      {
        'language': 'java', 'type': 'output', 'topic': 'data_types', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'float f = 3.14f;\ndouble d = 3.14;\nSystem.out.println(f == d);',
        'option_a': 'true', 'option_b': 'false', 'option_c': '3.14', 'option_d': 'Compiler error',
        'correct_answer': 'B', 'explanation': 'float and double have different precision. 3.14 as a float and 3.14 as a double may differ slightly due to binary representation. They are not exactly equal, so the result is false.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'data_types', 'difficulty': 'easy',
        'question_text': 'What type would you use to store a single character?',
        'code_snippet': null,
        'option_a': 'String', 'option_b': 'char', 'option_c': 'Character', 'option_d': 'byte',
        'correct_answer': 'B', 'explanation': 'char is the primitive type for a single 16-bit Unicode character. String is for sequences of characters. Character is the wrapper class. byte is for 8-bit integers.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'data_types', 'difficulty': 'medium',
        'question_text': 'Which of the following is NOT a primitive type in Java?',
        'code_snippet': null,
        'option_a': 'int', 'option_b': 'String', 'option_c': 'boolean', 'option_d': 'long',
        'correct_answer': 'B', 'explanation': 'String is a class (reference type) in Java, not a primitive. The 8 primitives are: byte, short, int, long, float, double, boolean, and char.',
        'xp_reward': 10, 'is_seeded': 1
      },
      // Operators - more
      {
        'language': 'java', 'type': 'output', 'topic': 'operators', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'System.out.println(10 + 20 + "30");\nSystem.out.println("10" + 20 + 30);',
        'option_a': '3030 and 102030', 'option_b': '3030 and 3030', 'option_c': '102030 and 102030', 'option_d': 'Compile errors',
        'correct_answer': 'A', 'explanation': 'First line: 10+20 is 30 (int addition), then 30 + "30" = "3030" (String concatenation). Second line: "10" + 20 = "1020", then "1020" + 30 = "102030".',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'operators', 'difficulty': 'easy',
        'question_text': 'What is the result of 7 & 3? (bitwise AND)',
        'code_snippet': null,
        'option_a': '4', 'option_b': '3', 'option_c': '1', 'option_d': '5',
        'correct_answer': 'B', 'explanation': 'Bitwise AND: 7 = 111, 3 = 011. 111 & 011 = 011 = 3.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'operators', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int x = 5;\nint y = x << 2;\nSystem.out.println(y);',
        'option_a': '10', 'option_b': '20', 'option_c': '7', 'option_d': '25',
        'correct_answer': 'B', 'explanation': 'The << (left shift) operator shifts bits left by 2. 5 in binary = 101, shifting left by 2 = 10100 = 20. Equivalent to multiplying by 2^2 = 4.',
        'xp_reward': 10, 'is_seeded': 1
      },
      // Strings - new topic
      {
        'language': 'java', 'type': 'output', 'topic': 'strings', 'difficulty': 'easy',
        'question_text': 'What does this print?',
        'code_snippet': 'String s = "Hello";\nSystem.out.println(s.length());',
        'option_a': '4', 'option_b': '5', 'option_c': '6', 'option_d': 'Hello',
        'correct_answer': 'B', 'explanation': 'The length() method returns the number of characters in the string. "Hello" has 5 characters.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'strings', 'difficulty': 'easy',
        'question_text': 'Which operator concatenates strings in Java?',
        'code_snippet': null,
        'option_a': '&', 'option_b': '+', 'option_c': 'concat()', 'option_d': 'append()',
        'correct_answer': 'B', 'explanation': 'The + operator is used for string concatenation in Java. concat() is also a method, but + is the standard operator.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'strings', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'String a = "Java";\nString b = "Java";\nSystem.out.println(a == b);\nSystem.out.println(a.equals(b));',
        'option_a': 'false and true', 'option_b': 'false and false', 'option_c': 'true and true', 'option_d': 'true and false',
        'correct_answer': 'C', 'explanation': 'Due to string interning, both a and b point to the same pooled String object. So == (reference equality) returns true. equals() (value equality) also returns true.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'strings', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'String s = "Hello";\ns = s + " World";\nSystem.out.println(s);',
        'option_a': 'Hello', 'option_b': 'Hello World', 'option_c': 'HelloWorld', 'option_d': 'HWorldello',
        'correct_answer': 'B', 'explanation': 'Strings are immutable. The + operator creates a new String object ("Hello World") and assigns it to s. The original "Hello" is unchanged.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'fillblank', 'topic': 'strings', 'difficulty': 'medium',
        'question_text': 'Complete the code to get a character at index 2:\n\nString s = "Code";\nchar c = s.___(2);',
        'code_snippet': null,
        'option_a': 'charAt', 'option_b': 'get', 'option_c': 'at', 'option_d': 'indexOf',
        'correct_answer': 'A', 'explanation': 'charAt(int index) returns the character at the specified index. s.charAt(2) returns \'d\' because C(0), o(1), d(2), e(3).',
        'xp_reward': 10, 'is_seeded': 1
      },
      // Arrays - more
      {
        'language': 'java', 'type': 'output', 'topic': 'arrays', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int[][] arr = {{1, 2, 3}, {4, 5, 6}};\nSystem.out.println(arr[1][2]);',
        'option_a': '2', 'option_b': '3', 'option_c': '5', 'option_d': '6',
        'correct_answer': 'D', 'explanation': 'This is a 2D array. arr[1] refers to the second row {4, 5, 6}. arr[1][2] is the third element in that row = 6.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'arrays', 'difficulty': 'easy',
        'question_text': 'What does this print?',
        'code_snippet': 'int[] arr = {1, 2, 3, 4, 5};\nSystem.out.println(arr.length);',
        'option_a': '4', 'option_b': '5', 'option_c': '6', 'option_d': '0',
        'correct_answer': 'B', 'explanation': 'The length property of an array returns its size. This array has 5 elements, so arr.length = 5.',
        'xp_reward': 5, 'is_seeded': 1
      },
      // OOP - more
      {
        'language': 'java', 'type': 'output', 'topic': 'oop', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'class Parent {\n    void show() { System.out.print("A"); }\n}\nclass Child extends Parent {\n    void show() { System.out.print("B"); }\n}\npublic class Main {\n    public static void main(String[] args) {\n        Parent obj = new Child();\n        obj.show();\n    }\n}',
        'option_a': 'A', 'option_b': 'B', 'option_c': 'AB', 'option_d': 'Compiler error',
        'correct_answer': 'B', 'explanation': 'This is polymorphism. The object is of type Child, so the overridden show() method in Child is called. Even though the reference type is Parent, the actual method invoked is determined at runtime.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'oop', 'difficulty': 'medium',
        'question_text': 'An abstract method in Java:',
        'code_snippet': null,
        'option_a': 'Has a body with implementation', 'option_b': 'Has no body and must be overridden by subclasses', 'option_c': 'Can only be called once', 'option_d': 'Is always private',
        'correct_answer': 'B', 'explanation': 'An abstract method has no body (just a signature ending with a semicolon). It must be implemented (overridden) by the first concrete subclass.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'fillblank', 'topic': 'oop', 'difficulty': 'easy',
        'question_text': 'Complete the code to create an object:\n\nclass Car { }\nCar myCar = ___ Car();',
        'code_snippet': null,
        'option_a': 'new', 'option_b': 'create', 'option_c': 'make', 'option_d': 'init',
        'correct_answer': 'A', 'explanation': 'The new keyword creates an instance of a class. So new Car() creates a new Car object and the myCar variable references it.',
        'xp_reward': 5, 'is_seeded': 1
      },
      // Conditionals - more
      {
        'language': 'java', 'type': 'output', 'topic': 'conditionals', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int x = 2;\nswitch (x) {\n    case 1: System.out.print("A");\n    case 2: System.out.print("B");\n    case 3: System.out.print("C"); break;\n    default: System.out.print("D");\n}',
        'option_a': 'B', 'option_b': 'BC', 'option_c': 'BCD', 'option_d': 'ABC',
        'correct_answer': 'B', 'explanation': 'In Java, switch cases fall through if there is no break. x=2 matches case 2, prints "B", then falls through to case 3 and prints "C", then the break stops execution.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'mcq', 'topic': 'conditionals', 'difficulty': 'medium',
        'question_text': 'What does the || (OR) logical operator return?',
        'code_snippet': null,
        'option_a': 'true only if both operands are true', 'option_b': 'true if at least one operand is true', 'option_c': 'true only if both are false', 'option_d': 'always false',
        'correct_answer': 'B', 'explanation': 'The || (logical OR) operator returns true if at least one of the operands is true. It short-circuits: if the first operand is true, the second is not evaluated.',
        'xp_reward': 10, 'is_seeded': 1
      },
      // Loops - more
      {
        'language': 'java', 'type': 'output', 'topic': 'loops', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int count = 0;\nfor (int i = 0; i < 10; i++) {\n    if (i % 2 != 0) count++;\n}\nSystem.out.println(count);',
        'option_a': '4', 'option_b': '5', 'option_c': '10', 'option_d': '0',
        'correct_answer': 'B', 'explanation': 'The loop counts odd numbers from 0 to 9. Odd numbers are: 1, 3, 5, 7, 9 = 5 numbers.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'loops', 'difficulty': 'easy',
        'question_text': 'What does this print?',
        'code_snippet': 'int i = 3;\nwhile (i > 0) {\n    System.out.print(i--);\n}',
        'option_a': '321', 'option_b': '123', 'option_c': '012', 'option_d': 'Infinite loop',
        'correct_answer': 'A', 'explanation': 'i starts at 3. First iteration prints 3 then decrements to 2. Prints 2 then 1. When i=0, the loop exits. Output: 321.',
        'xp_reward': 5, 'is_seeded': 1
      },
      // Methods - more
      {
        'language': 'java', 'type': 'mcq', 'topic': 'methods', 'difficulty': 'hard',
        'question_text': 'Which of these correctly demonstrates varargs?',
        'code_snippet': null,
        'option_a': 'void func(int... numbers)', 'option_b': 'void func(int[]... numbers)', 'option_c': 'void func(int ...numbers)', 'option_d': 'void func(int...)',
        'correct_answer': 'A', 'explanation': 'Varargs syntax is type... name. int... numbers is correct. The other options have incorrect syntax: int[]... is not valid Java, the spaces matter, and forgetting the parameter name is invalid.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'java', 'type': 'output', 'topic': 'methods', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'static void change(int x) { x = 50; }\npublic static void main(String[] args) {\n    int a = 10;\n    change(a);\n    System.out.println(a);\n}',
        'option_a': '10', 'option_b': '50', 'option_c': '0', 'option_d': 'undefined',
        'correct_answer': 'A', 'explanation': 'Java is pass-by-value. The change method gets a copy of a. Modifying x inside the method does not affect the original variable a. So a remains 10.',
        'xp_reward': 10, 'is_seeded': 1
      },
    ];

    // === C++ QUESTIONS (50) ===
    final cppQuestions = [
      // Variables - 5
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'variables', 'difficulty': 'easy',
        'question_text': 'Which keyword declares an integer variable in C++?',
        'code_snippet': null,
        'option_a': 'int', 'option_b': 'integer', 'option_c': 'var', 'option_d': 'let',
        'correct_answer': 'A', 'explanation': 'C++ uses int to declare integer variables, the same as Java. integer is not a C++ keyword.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'variables', 'difficulty': 'easy',
        'question_text': 'What is the size of int on most modern 32/64-bit systems?',
        'code_snippet': null,
        'option_a': '2 bytes', 'option_b': '4 bytes', 'option_c': '8 bytes', 'option_d': '1 byte',
        'correct_answer': 'B', 'explanation': 'On most modern systems, int is 4 bytes (32 bits). This is technically implementation-defined but 4 bytes is the de facto standard.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'variables', 'difficulty': 'medium',
        'question_text': 'What happens if you use an uninitialized local variable in C++?',
        'code_snippet': null,
        'option_a': 'It always defaults to 0', 'option_b': 'It contains garbage (undefined behavior)', 'option_c': 'Compiler error (always)', 'option_d': 'Program crashes immediately',
        'correct_answer': 'B', 'explanation': 'Unlike Java, C++ does not initialize local variables. Reading an uninitialized variable results in undefined behavior.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'fillblank', 'topic': 'variables', 'difficulty': 'easy',
        'question_text': 'Complete the declaration: ___ pi = 3.14;',
        'code_snippet': null,
        'option_a': 'double', 'option_b': 'int', 'option_c': 'char', 'option_d': 'bool',
        'correct_answer': 'A', 'explanation': '3.14 is a floating-point literal, so double is the appropriate type.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'variables', 'difficulty': 'medium',
        'question_text': 'Which keyword declares a variable that cannot be modified after initialization?',
        'code_snippet': null,
        'option_a': 'static', 'option_b': 'const', 'option_c': 'final', 'option_d': 'fixed',
        'correct_answer': 'B', 'explanation': 'const in C++ makes a variable immutable after initialization.',
        'xp_reward': 10, 'is_seeded': 1
      },
      // Pointers - 7
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'pointers', 'difficulty': 'easy',
        'question_text': 'What operator is used to get the address of a variable?',
        'code_snippet': null,
        'option_a': '*', 'option_b': '&', 'option_c': '->', 'option_d': '::',
        'correct_answer': 'B', 'explanation': 'The & (address-of) operator returns the memory address of a variable.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'pointers', 'difficulty': 'easy',
        'question_text': 'What does the * operator do when used with a pointer?',
        'code_snippet': null,
        'option_a': 'Gets the address', 'option_b': 'Dereferences the pointer (gets the value at the address)', 'option_c': 'Deletes the pointer', 'option_d': 'Creates a new pointer',
        'correct_answer': 'B', 'explanation': 'When * is applied to a pointer variable, it dereferences it accessing the value stored at the memory address.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'pointers', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int x = 10;\nint* p = &x;\n*p = 20;\ncout << x;',
        'option_a': '10', 'option_b': '20', 'option_c': 'Address of x', 'option_d': 'Compiler error',
        'correct_answer': 'B', 'explanation': 'p points to x. *p = 20 modifies the value at the address p points to, which is x. So x becomes 20.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'pointers', 'difficulty': 'medium',
        'question_text': 'What is a null pointer?',
        'code_snippet': null,
        'option_a': 'A pointer pointing to address 0', 'option_b': 'A pointer pointing to a random address', 'option_c': 'A pointer that has been deleted', 'option_d': 'A pointer to a string',
        'correct_answer': 'A', 'explanation': 'A null pointer is a pointer that points to nothing specifically address 0 (or nullptr in modern C++).',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'fillblank', 'topic': 'pointers', 'difficulty': 'medium',
        'question_text': 'Complete the pointer declaration:\n\nint* p = ___;\n(to make it a null pointer)',
        'code_snippet': null,
        'option_a': 'NULL', 'option_b': '0.0', 'option_c': '""', 'option_d': 'false',
        'correct_answer': 'A', 'explanation': 'NULL (or nullptr in C++11+) is used to initialize a pointer to null.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'pointers', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int arr[] = {10, 20, 30};\nint* p = arr;\ncout << *(p + 1);',
        'option_a': '10', 'option_b': '20', 'option_c': '30', 'option_d': 'Address',
        'correct_answer': 'B', 'explanation': 'p points to arr[0]. Pointer arithmetic: p + 1 points to arr[1]. Dereferencing with *(p + 1) gives 20.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'pointers', 'difficulty': 'hard',
        'question_text': 'What is the difference between a pointer and a reference?',
        'code_snippet': null,
        'option_a': 'A reference can be reassigned; a pointer cannot', 'option_b': 'A pointer can be null; a reference must refer to a valid object', 'option_c': 'They are exactly the same', 'option_d': 'A reference takes more memory',
        'correct_answer': 'B', 'explanation': 'A pointer can be null or reassigned to point to different addresses. A reference must be initialized to a valid object and cannot be re-seated.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // References - 4
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'references', 'difficulty': 'easy',
        'question_text': 'Which symbol declares a reference in C++?',
        'code_snippet': null,
        'option_a': '*', 'option_b': '&', 'option_c': '^', 'option_d': '@',
        'correct_answer': 'B', 'explanation': 'The & symbol in a declaration creates a reference: int& ref = x;',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'references', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int a = 5;\nint& ref = a;\nref = 10;\ncout << a;',
        'option_a': '5', 'option_b': '10', 'option_c': 'Address of a', 'option_d': 'Compiler error',
        'correct_answer': 'B', 'explanation': 'ref is a reference to a they share the same memory. Modifying ref also modifies a. So a becomes 10.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'references', 'difficulty': 'medium',
        'question_text': 'Can a reference be left uninitialized?',
        'code_snippet': null,
        'option_a': 'Yes', 'option_b': 'No, a reference must be initialized when declared', 'option_c': 'Only if it is a global variable', 'option_d': 'Only in C++17',
        'correct_answer': 'B', 'explanation': 'References must be initialized at the point of declaration. Unlike pointers, there is no "null reference" concept.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'references', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'void swap(int& a, int& b) {\n    int temp = a;\n    a = b;\n    b = temp;\n}\nint main() {\n    int x = 3, y = 7;\n    swap(x, y);\n    cout << x << y;\n}',
        'option_a': '37', 'option_b': '73', 'option_c': '33', 'option_d': '77',
        'correct_answer': 'B', 'explanation': 'The swap function takes parameters by reference, so it modifies the original variables. After swap: x=7, y=3. Output: 73.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // Arrays - 5
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'arrays', 'difficulty': 'easy',
        'question_text': 'What is the correct way to declare an array of 5 integers in C++?',
        'code_snippet': null,
        'option_a': 'int arr(5);', 'option_b': 'int arr[5];', 'option_c': 'array int arr[5];', 'option_d': 'int[5] arr;',
        'correct_answer': 'B', 'explanation': 'C++ uses square brackets after the variable name: int arr[5];',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'arrays', 'difficulty': 'easy',
        'question_text': 'What does this print?',
        'code_snippet': 'int arr[] = {5, 10, 15};\ncout << arr[1];',
        'option_a': '5', 'option_b': '10', 'option_c': '15', 'option_d': '0',
        'correct_answer': 'B', 'explanation': 'arr[0] = 5, arr[1] = 10, arr[2] = 15. Zero-indexed, so arr[1] is 10.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'arrays', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int arr[5] = {1, 2};\ncout << arr[3];',
        'option_a': '1', 'option_b': '2', 'option_c': '0', 'option_d': 'Garbage value',
        'correct_answer': 'C', 'explanation': 'When an array is partially initialized, remaining elements are zero-initialized. arr[3] was not explicitly set, so it defaults to 0.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'arrays', 'difficulty': 'medium',
        'question_text': 'What happens if you access arr[10] on an array of size 5?',
        'code_snippet': null,
        'option_a': 'Compiler error', 'option_b': 'Runtime exception is thrown', 'option_c': 'Undefined behavior', 'option_d': 'Returns 0',
        'correct_answer': 'C', 'explanation': 'C++ does not perform bounds checking on arrays. Accessing out-of-bounds elements is undefined behavior.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'arrays', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int arr[] = {2, 4, 6, 8, 10};\ncout << *(arr + 2);',
        'option_a': '2', 'option_b': '4', 'option_c': '6', 'option_d': '8',
        'correct_answer': 'C', 'explanation': 'The array name arr decays to a pointer to the first element. arr + 2 points to arr[2]. Dereferencing gives 6.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // Functions - 5
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'functions', 'difficulty': 'easy',
        'question_text': 'What is the correct function signature for a function that takes two ints and returns an int?',
        'code_snippet': null,
        'option_a': 'int func(int a, int b)', 'option_b': 'function int(int a, int b)', 'option_c': 'func(a: int, b: int) -> int', 'option_d': 'def func(a, b):',
        'correct_answer': 'A', 'explanation': 'C++ function syntax: return type + name + parameter list. int func(int a, int b) is correct.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'functions', 'difficulty': 'medium',
        'question_text': 'What are default arguments in C++?',
        'code_snippet': null,
        'option_a': 'Arguments that are always required', 'option_b': 'Parameters that take a default value if no argument is passed', 'option_c': 'Arguments that cannot be changed', 'option_d': 'Arguments passed by reference',
        'correct_answer': 'B', 'explanation': 'Default arguments allow a parameter to have a preset value. If the caller does not provide that argument, the default is used.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'functions', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int add(int a, int b = 5) { return a + b; }\nint main() {\n    cout << add(3);\n}',
        'option_a': '3', 'option_b': '8', 'option_c': '35', 'option_d': 'Compiler error',
        'correct_answer': 'B', 'explanation': 'add(3) uses the default value for b which is 5. So 3 + 5 = 8.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'functions', 'difficulty': 'medium',
        'question_text': 'What is function overloading in C++?',
        'code_snippet': null,
        'option_a': 'A function calling itself', 'option_b': 'Multiple functions with the same name but different parameter lists', 'option_c': 'A function with default arguments', 'option_d': 'A function that returns multiple values',
        'correct_answer': 'B', 'explanation': 'Function overloading allows multiple functions with the same name but different parameter types or counts.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'functions', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int fib(int n) {\n    if (n <= 1) return n;\n    return fib(n-1) + fib(n-2);\n}\nint main() {\n    cout << fib(6);\n}',
        'option_a': '5', 'option_b': '8', 'option_c': '13', 'option_d': '6',
        'correct_answer': 'B', 'explanation': 'This computes Fibonacci numbers: fib(0)=0, fib(1)=1, fib(2)=1, fib(3)=2, fib(4)=3, fib(5)=5, fib(6)=8.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // Classes - 6
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'classes', 'difficulty': 'easy',
        'question_text': 'Which keyword defines a class in C++?',
        'code_snippet': null,
        'option_a': 'struct', 'option_b': 'class', 'option_c': 'object', 'option_d': 'type',
        'correct_answer': 'B', 'explanation': 'class is the primary keyword for defining classes in C++. struct can also define a class-like type but with default public access.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'classes', 'difficulty': 'easy',
        'question_text': 'What is the default access specifier for members of a class in C++?',
        'code_snippet': null,
        'option_a': 'public', 'option_b': 'private', 'option_c': 'protected', 'option_d': 'global',
        'correct_answer': 'B', 'explanation': 'In a class, members are private by default. In a struct, they are public by default.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'fillblank', 'topic': 'classes', 'difficulty': 'medium',
        'question_text': 'Complete the class method definition outside the class:\n\nclass Dog {\npublic:\n    void bark();\n};\nvoid Dog::___() {\n    cout << "Woof!";\n}',
        'code_snippet': null,
        'option_a': 'bark', 'option_b': 'Dog.bark', 'option_c': 'bark()', 'option_d': 'Dog::bark',
        'correct_answer': 'A', 'explanation': 'When defining a member function outside the class, use ClassName::functionName. The blank is bark.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'classes', 'difficulty': 'medium',
        'question_text': 'What is a constructor?',
        'code_snippet': null,
        'option_a': 'A method called when an object is destroyed', 'option_b': 'A special method called when an object is created', 'option_c': 'A method that returns a value', 'option_d': 'A static method',
        'correct_answer': 'B', 'explanation': 'A constructor is a special member function called automatically when an object is created. It has the same name as the class and no return type.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'classes', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'class Counter {\n    int count;\npublic:\n    Counter() : count(0) {}\n    void inc() { count++; }\n    int get() { return count; }\n};\nint main() {\n    Counter c;\n    c.inc(); c.inc(); c.inc();\n    cout << c.get();\n}',
        'option_a': '0', 'option_b': '1', 'option_c': '3', 'option_d': 'Compiler error',
        'correct_answer': 'C', 'explanation': 'Counter() initializes count to 0 via the initializer list. inc() is called 3 times, incrementing count to 3. get() returns 3.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'classes', 'difficulty': 'hard',
        'question_text': 'What is the difference between class and struct in C++?',
        'code_snippet': null,
        'option_a': 'struct cannot have methods', 'option_b': 'struct members are public by default; class members are private by default', 'option_c': 'struct is only for C; class is for C++', 'option_d': 'There is no difference',
        'correct_answer': 'B', 'explanation': 'The only technical difference is the default access: struct defaults to public, class defaults to private. Both can have methods, constructors, inheritance, etc.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // Constructors - 5
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'constructors', 'difficulty': 'easy',
        'question_text': 'What is the name of a constructor in C++?',
        'code_snippet': null,
        'option_a': 'constructor', 'option_b': 'Same as the class name', 'option_c': 'init', 'option_d': '__construct',
        'correct_answer': 'B', 'explanation': 'A C++ constructor has the same name as the class and no return type (not even void).',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'constructors', 'difficulty': 'medium',
        'question_text': 'What is a copy constructor?',
        'code_snippet': null,
        'option_a': 'A constructor that copies code from another file', 'option_b': 'A constructor that initializes an object using another object of the same class', 'option_c': 'A constructor that creates two objects', 'option_d': 'A constructor with no parameters',
        'correct_answer': 'B', 'explanation': 'A copy constructor takes a reference to an object of the same class and creates a copy.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'fillblank', 'topic': 'constructors', 'difficulty': 'medium',
        'question_text': 'Complete the constructor using an initializer list:\n\nclass Box {\n    int width;\npublic:\n    Box(int w) ___ width(w) {}\n};',
        'code_snippet': null,
        'option_a': ':', 'option_b': '=', 'option_c': '->', 'option_d': '::',
        'correct_answer': 'A', 'explanation': 'The member initializer list starts with a colon : after the constructor parameters.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'constructors', 'difficulty': 'medium',
        'question_text': 'What happens if you do not define any constructor?',
        'code_snippet': null,
        'option_a': 'Compiler error', 'option_b': 'The compiler provides a default constructor', 'option_c': 'The class cannot be instantiated', 'option_d': 'The program crashes',
        'correct_answer': 'B', 'explanation': 'If no constructor is defined, the compiler generates a default (no-argument) constructor.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'constructors', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'class A {\npublic:\n    A() { cout << "A "; }\n    A(int x) { cout << "B "; }\n};\nint main() {\n    A a1;\n    A a2(5);\n}',
        'option_a': 'A A', 'option_b': 'A B', 'option_c': 'B A', 'option_d': 'B B',
        'correct_answer': 'B', 'explanation': 'A a1; calls the no-arg constructor prints "A ". A a2(5); calls the int constructor prints "B ". Output: A B.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // STL Basics - 5
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'stl_basics', 'difficulty': 'easy',
        'question_text': 'Which header file is needed to use std::vector?',
        'code_snippet': null,
        'option_a': '<array>', 'option_b': '<vector>', 'option_c': '<list>', 'option_d': '<container>',
        'correct_answer': 'B', 'explanation': '<vector> is the correct header. <array> is for std::array. <list> is for std::list.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'stl_basics', 'difficulty': 'easy',
        'question_text': 'What does this print?',
        'code_snippet': '#include <vector>\nusing namespace std;\nint main() {\n    vector<int> v = {1, 2, 3};\n    v.push_back(4);\n    cout << v.size();\n}',
        'option_a': '3', 'option_b': '4', 'option_c': '5', 'option_d': 'Compiler error',
        'correct_answer': 'B', 'explanation': 'The vector starts with 3 elements. push_back(4) adds one more. v.size() returns 4.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'stl_basics', 'difficulty': 'medium',
        'question_text': 'What does v.at(i) do that v[i] does not?',
        'code_snippet': null,
        'option_a': 'Returns a different type', 'option_b': 'Performs bounds checking and throws out_of_range if invalid', 'option_c': 'Is faster', 'option_d': 'Returns a reference',
        'correct_answer': 'B', 'explanation': 'at() performs bounds checking and throws std::out_of_range if the index is invalid. [] does no checking.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'stl_basics', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': '#include <map>\nusing namespace std;\nint main() {\n    map<string, int> m;\n    m["apple"] = 3;\n    m["banana"] = 5;\n    cout << m["apple"];\n}',
        'option_a': '0', 'option_b': '3', 'option_c': 'apple', 'option_d': 'Compiler error',
        'correct_answer': 'B', 'explanation': 'm["apple"] was set to 3. Accessing it returns 3.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'stl_basics', 'difficulty': 'hard',
        'question_text': 'Which STL container provides LIFO (Last In, First Out) behavior?',
        'code_snippet': null,
        'option_a': 'std::queue', 'option_b': 'std::stack', 'option_c': 'std::vector', 'option_d': 'std::deque',
        'correct_answer': 'B', 'explanation': 'std::stack is a LIFO container adapter the last element pushed is the first one popped.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // Memory Management - 5
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'memory_management', 'difficulty': 'easy',
        'question_text': 'Which operator allocates memory dynamically in C++?',
        'code_snippet': null,
        'option_a': 'malloc', 'option_b': 'new', 'option_c': 'alloc', 'option_d': 'create',
        'correct_answer': 'B', 'explanation': 'new is the C++ operator for dynamic memory allocation. malloc is the C way (also available but not recommended).',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'memory_management', 'difficulty': 'easy',
        'question_text': 'Which operator deallocates memory allocated with new?',
        'code_snippet': null,
        'option_a': 'free', 'option_b': 'delete', 'option_c': 'remove', 'option_d': 'release',
        'correct_answer': 'B', 'explanation': 'delete pairs with new. free pairs with malloc (C-style). Never mix new/free or malloc/delete.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'memory_management', 'difficulty': 'medium',
        'question_text': 'What is a memory leak?',
        'code_snippet': null,
        'option_a': 'Accessing freed memory', 'option_b': 'Memory that is allocated but never deallocated', 'option_c': 'Using too much stack memory', 'option_d': 'A pointer that points to wrong data',
        'correct_answer': 'B', 'explanation': 'A memory leak occurs when dynamically allocated memory (via new) is never freed (via delete).',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'memory_management', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int* p = new int(42);\nint* q = p;\ndelete p;\ncout << *q;',
        'option_a': '42', 'option_b': '0', 'option_c': 'Undefined behavior', 'option_d': 'Compiler error',
        'correct_answer': 'C', 'explanation': 'After delete p, the memory is freed. q still holds the old address (dangling pointer). Dereferencing q is undefined behavior.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'memory_management', 'difficulty': 'hard',
        'question_text': 'What is a smart pointer?',
        'code_snippet': null,
        'option_a': 'A pointer that is very fast', 'option_b': 'A pointer that automatically manages memory deallocation', 'option_c': 'A pointer that can point to any type', 'option_d': 'A pointer that cannot be null',
        'correct_answer': 'B', 'explanation': 'Smart pointers (std::unique_ptr, std::shared_ptr) automatically manage memory. They deallocate when the pointer goes out of scope.',
        'xp_reward': 20, 'is_seeded': 1
      },
      // Loops - 3
      {
        'language': 'cpp', 'type': 'output', 'topic': 'loops', 'difficulty': 'easy',
        'question_text': 'What does this print?',
        'code_snippet': 'for (int i = 0; i < 4; i++) {\n    cout << i << " ";\n}',
        'option_a': '0 1 2 3', 'option_b': '1 2 3 4', 'option_c': '0 1 2 3 4', 'option_d': '1 2 3',
        'correct_answer': 'A', 'explanation': 'Loop starts at 0, runs while i < 4, so i takes values 0, 1, 2, 3. Each is printed with a space.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'loops', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int i = 10;\nwhile (i > 0) {\n    i -= 3;\n}\ncout << i;',
        'option_a': '0', 'option_b': '1', 'option_c': '-2', 'option_d': 'Infinite loop',
        'correct_answer': 'C', 'explanation': 'i starts at 10: 10 -> 7 -> 4 -> 1 -> -2. When i=-2, the condition -2 > 0 is false. The loop stops and prints -2.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'loops', 'difficulty': 'medium',
        'question_text': 'What is a range-based for loop in C++11?',
        'code_snippet': null,
        'option_a': 'for (int i : 10)', 'option_b': 'for (int x : container)', 'option_c': 'for (container as x)', 'option_d': 'for each (x in container)',
        'correct_answer': 'B', 'explanation': 'C++11 introduced for (type var : container) syntax to iterate over all elements.',
        'xp_reward': 10, 'is_seeded': 1
      },
      // Variables - more
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'variables', 'difficulty': 'hard',
        'question_text': 'What is the value of sizeof(int) on a 64-bit system?',
        'code_snippet': null,
        'option_a': '2 bytes', 'option_b': '4 bytes', 'option_c': '8 bytes', 'option_d': 'Implementation-defined, but usually 4',
        'correct_answer': 'D', 'explanation': 'The size of int in C++ is implementation-defined. On most 64-bit systems, int remains 4 bytes for backward compatibility. This is a common interview gotcha - never assume int size.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'fillblank', 'topic': 'variables', 'difficulty': 'medium',
        'question_text': 'Complete the code to declare a variable that cannot be modified:\n\n___ int MAX = 100;',
        'code_snippet': null,
        'option_a': 'const', 'option_b': 'static', 'option_c': 'readonly', 'option_d': 'final',
        'correct_answer': 'A', 'explanation': 'const in C++ makes a variable immutable. static affects storage duration. final is not a C++ keyword (it is used in Java).',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'variables', 'difficulty': 'easy',
        'question_text': 'What does this print?',
        'code_snippet': 'int a = 10;\nint b = a;\na = 20;\ncout << b;',
        'option_a': '10', 'option_b': '20', 'option_c': '30', 'option_d': 'undefined',
        'correct_answer': 'A', 'explanation': 'b gets a copy of the value of a (which is 10 at that point). Changing a later does not affect b. So b remains 10.',
        'xp_reward': 5, 'is_seeded': 1
      },
      // Pointers - more
      {
        'language': 'cpp', 'type': 'output', 'topic': 'pointers', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int arr[] = {10, 20, 30, 40};\nint* ptr = arr;\nptr += 2;\ncout << *ptr;',
        'option_a': '10', 'option_b': '20', 'option_c': '30', 'option_d': '40',
        'correct_answer': 'C', 'explanation': 'arr decays to a pointer to arr[0]. ptr += 2 moves the pointer 2 ints forward, so it points to arr[2] = 30. *ptr dereferences to get 30.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'pointers', 'difficulty': 'medium',
        'question_text': 'What does nullptr represent?',
        'code_snippet': null,
        'option_a': 'A pointer to memory address 0', 'option_b': 'A null pointer literal in modern C++', 'option_c': 'A pointer that always crashes', 'option_d': 'A void pointer',
        'correct_answer': 'B', 'explanation': 'nullptr (C++11+) is a keyword representing a null pointer literal. It is type-safe and preferred over NULL or 0.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'fillblank', 'topic': 'pointers', 'difficulty': 'easy',
        'question_text': 'Complete the pointer dereference:\n\nint* p = &x;\ncout << ___(p); \n(to print the value pointed to by p)',
        'code_snippet': null,
        'option_a': '*', 'option_b': '&', 'option_c': '->', 'option_d': '::',
        'correct_answer': 'A', 'explanation': 'The * operator when applied to a pointer dereferences it, accessing the value at the stored address.',
        'xp_reward': 5, 'is_seeded': 1
      },
      // References - more
      {
        'language': 'cpp', 'type': 'output', 'topic': 'references', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int x = 10;\nint& ref = x;\nint y = 20;\nref = y;\ny = 30;\ncout << x;',
        'option_a': '10', 'option_b': '20', 'option_c': '30', 'option_d': 'Compiler error',
        'correct_answer': 'B', 'explanation': 'ref is a reference to x. ref = y assigns the VALUE of y (20) to x, it does NOT make ref reference y. So x becomes 20. Changing y to 30 later does not affect x.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'references', 'difficulty': 'easy',
        'question_text': 'What must a reference be initialized with?',
        'code_snippet': null,
        'option_a': 'A literal value', 'option_b': 'A variable of the same type', 'option_c': 'A pointer', 'option_d': 'Any value is fine',
        'correct_answer': 'B', 'explanation': 'A reference must be initialized with a variable (object) of the matching type. It cannot be bound to a literal value (unless it is a const reference).',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'references', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int a = 5;\nint b = 10;\nint& ref = a;\nref = b;\ncout << a << b;',
        'option_a': '55', 'option_b': '105', 'option_c': '1010', 'option_d': '510',
        'correct_answer': 'C', 'explanation': 'ref is a reference to a. ref = b assigns the value of b (10) to a, so a becomes 10. b remains 10. Output: 1010.',
        'xp_reward': 10, 'is_seeded': 1
      },
      // Functions - more
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'functions', 'difficulty': 'hard',
        'question_text': 'What does the inline keyword do?',
        'code_snippet': null,
        'option_a': 'Makes the function run faster', 'option_b': 'Suggests the compiler replace the function call with its body to avoid overhead', 'option_c': 'Makes the function thread-safe', 'option_d': 'Forces the function to be called only once',
        'correct_answer': 'B', 'explanation': 'inline is a suggestion to the compiler to replace the function call with the function body (compile-time expansion) to avoid function call overhead.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'functions', 'difficulty': 'easy',
        'question_text': 'What does this print?',
        'code_snippet': 'int square(int x) { return x * x; }\nint main() {\n    cout << square(7);\n}',
        'option_a': '14', 'option_b': '49', 'option_c': '7', 'option_d': '77',
        'correct_answer': 'B', 'explanation': 'square(7) returns 7 * 7 = 49.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'functions', 'difficulty': 'medium',
        'question_text': 'What is a lambda in C++?',
        'code_snippet': null,
        'option_a': 'A named function', 'option_b': 'An anonymous function (C++11 and later)', 'option_c': 'A special kind of class', 'option_d': 'A function template',
        'correct_answer': 'B', 'explanation': 'A lambda (C++11+) is an anonymous function defined inline, typically using syntax like [](int x) { return x * 2; }.',
        'xp_reward': 10, 'is_seeded': 1
      },
      // Classes - more
      {
        'language': 'cpp', 'type': 'output', 'topic': 'classes', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'class Base {\npublic:\n    virtual void speak() { cout << "Base"; }\n};\nclass Derived : public Base {\npublic:\n    void speak() override { cout << "Derived"; }\n};\nint main() {\n    Base* b = new Derived();\n    b->speak();\n    delete b;\n}',
        'option_a': 'Base', 'option_b': 'Derived', 'option_c': 'BaseDerived', 'option_d': 'Compiler error',
        'correct_answer': 'B', 'explanation': 'speak() is virtual, so dynamic dispatch occurs. Even though the pointer type is Base*, the actual object is Derived, so Derived::speak() is called.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'classes', 'difficulty': 'medium',
        'question_text': 'What does the virtual keyword do?',
        'code_snippet': null,
        'option_a': 'Makes a function inline', 'option_b': 'Enables runtime polymorphism (dynamic dispatch)', 'option_c': 'Makes a function private', 'option_d': 'Creates a pure virtual function',
        'correct_answer': 'B', 'explanation': 'Virtual enables dynamic binding, so the most derived version of the function is called at runtime based on the actual object type.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'fillblank', 'topic': 'classes', 'difficulty': 'easy',
        'question_text': 'Complete the inheritance declaration:\n\nclass Dog : public Animal {\n    // Dog inherits from Animal\n};\n\nHere Animal is the ___ class.',
        'code_snippet': null,
        'option_a': 'base', 'option_b': 'derived', 'option_c': 'child', 'option_d': 'friend',
        'correct_answer': 'A', 'explanation': 'Animal is the base class (parent). Dog is the derived class (child). The base class provides functionality that the derived class inherits.',
        'xp_reward': 5, 'is_seeded': 1
      },
      // STL - more
      {
        'language': 'cpp', 'type': 'output', 'topic': 'stl_basics', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': '#include <algorithm>\n#include <vector>\nusing namespace std;\nint main() {\n    vector<int> v = {3, 1, 4, 1, 5};\n    sort(v.begin(), v.end());\n    cout << v[2];\n}',
        'option_a': '1', 'option_b': '3', 'option_c': '4', 'option_d': '5',
        'correct_answer': 'B', 'explanation': 'After sort, the vector becomes {1, 1, 3, 4, 5}. v[2] is the third element (0-indexed) = 3.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'stl_basics', 'difficulty': 'medium',
        'question_text': 'Which STL container allows fast insertions/removals at both ends?',
        'code_snippet': null,
        'option_a': 'std::vector', 'option_b': 'std::deque', 'option_c': 'std::stack', 'option_d': 'std::set',
        'correct_answer': 'B', 'explanation': 'std::deque (double-ended queue) supports constant-time insertions and removals at both the beginning and the end.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'stl_basics', 'difficulty': 'easy',
        'question_text': 'Which header is needed for std::string?',
        'code_snippet': null,
        'option_a': '<cstring>', 'option_b': '<string>', 'option_c': '<char>', 'option_d': '<text>',
        'correct_answer': 'B', 'explanation': 'std::string is defined in the <string> header. <cstring> is for C-style string functions like strlen.',
        'xp_reward': 5, 'is_seeded': 1
      },
      // Memory - more
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'memory_management', 'difficulty': 'hard',
        'question_text': 'What is a unique_ptr?',
        'code_snippet': null,
        'option_a': 'A pointer that can be shared between multiple owners', 'option_b': 'A smart pointer with exclusive ownership that cannot be copied', 'option_c': 'A pointer that always points to unique memory', 'option_d': 'A regular pointer with extra features',
        'correct_answer': 'B', 'explanation': 'std::unique_ptr is a smart pointer that has exclusive ownership of the managed object. It cannot be copied (only moved), ensuring only one pointer owns the resource.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'memory_management', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': 'int* p = new int;\n*p = 42;\ncout << *p;\ndelete p;\np = nullptr;',
        'option_a': '42', 'option_b': '0', 'option_c': 'undefined', 'option_d': 'nullptr',
        'correct_answer': 'A', 'explanation': 'new int allocates memory on the heap. *p = 42 assigns the value. *p (dereference) reads the value, printing 42. Then the memory is freed with delete.',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'fillblank', 'topic': 'memory_management', 'difficulty': 'easy',
        'question_text': 'Complete the array deallocation:\n\nint* arr = new int[10];\n___[] arr;',
        'code_snippet': null,
        'option_a': 'delete', 'option_b': 'free', 'option_c': 'remove', 'option_d': 'destroy',
        'correct_answer': 'A', 'explanation': 'Arrays allocated with new[] must be deallocated with delete[] (with brackets). Using plain delete instead of delete[] causes undefined behavior.',
        'xp_reward': 5, 'is_seeded': 1
      },
      // Strings - new topic
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'strings', 'difficulty': 'easy',
        'question_text': 'What header includes std::string?',
        'code_snippet': null,
        'option_a': '<string>', 'option_b': '<str>', 'option_c': '<sstream>', 'option_d': '<text>',
        'correct_answer': 'A', 'explanation': 'std::string is part of the C++ standard library, defined in the <string> header.',
        'xp_reward': 5, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'strings', 'difficulty': 'medium',
        'question_text': 'What does this print?',
        'code_snippet': '#include <string>\nusing namespace std;\nint main() {\n    string s = "Hello";\n    s[0] = \'J\';\n    cout << s;\n}',
        'option_a': 'Hello', 'option_b': 'Jello', 'option_c': 'ello', 'option_d': 'JelloHello',
        'correct_answer': 'B', 'explanation': 'Unlike Java, C++ std::string is mutable. s[0] = \'J\' changes the first character in-place. So "Hello" becomes "Jello".',
        'xp_reward': 10, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'output', 'topic': 'strings', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': '#include <string>\nusing namespace std;\nint main() {\n    string s = "C++";\n    string s2 = s + " is " + to_string(42);\n    cout << s2;\n}',
        'option_a': 'C++ is 42', 'option_b': 'C++ is 42.000000', 'option_c': 'C++is42', 'option_d': 'Compiler error',
        'correct_answer': 'A', 'explanation': 'The + operator concatenates strings. to_string(42) converts the integer to the string "42". So s2 = "C++" + " is " + "42" = "C++ is 42".',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'strings', 'difficulty': 'medium',
        'question_text': 'What does s.size() return?',
        'code_snippet': null,
        'option_a': 'The number of characters in the string', 'option_b': 'The memory allocated for the string', 'option_c': 'The capacity of the string', 'option_d': 'The size of the string object in bytes',
        'correct_answer': 'A', 'explanation': 'size() (and the equivalent length()) return the number of characters in the string, not including the null terminator (which is handled internally).',
        'xp_reward': 10, 'is_seeded': 1
      },
      // Arrays - more
      {
        'language': 'cpp', 'type': 'output', 'topic': 'arrays', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'int arr[3][2] = {{1, 2}, {3, 4}, {5, 6}};\ncout << arr[1][0];',
        'option_a': '2', 'option_b': '3', 'option_c': '5', 'option_d': '4',
        'correct_answer': 'B', 'explanation': 'This is a 2D (3x2) array. arr[1] is the second row {3, 4}. arr[1][0] is the first element of that row = 3.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'fillblank', 'topic': 'arrays', 'difficulty': 'medium',
        'question_text': 'Complete the multidimensional array:\n\nint matrix[3][3];\nThis creates a ___ array of ints.',
        'code_snippet': null,
        'option_a': '3x3', 'option_b': '2x3', 'option_c': '3x2', 'option_d': '1D',
        'correct_answer': 'A', 'explanation': 'int matrix[3][3] declares a 3x3 two-dimensional array (3 rows, 3 columns).',
        'xp_reward': 10, 'is_seeded': 1
      },
      // Constructors - more
      {
        'language': 'cpp', 'type': 'output', 'topic': 'constructors', 'difficulty': 'hard',
        'question_text': 'What does this print?',
        'code_snippet': 'class Test {\npublic:\n    Test() { cout << "1"; }\n    Test(const Test& t) { cout << "2"; }\n};\nvoid func(Test t) {}\nint main() {\n    Test a;\n    func(a);\n}',
        'option_a': '1', 'option_b': '12', 'option_c': '11', 'option_d': '12',
        'correct_answer': 'B', 'explanation': 'Test a; calls the default constructor prints "1". func(a) passes a by value, which invokes the copy constructor prints "2". Output: 12.',
        'xp_reward': 20, 'is_seeded': 1
      },
      {
        'language': 'cpp', 'type': 'mcq', 'topic': 'constructors', 'difficulty': 'easy',
        'question_text': 'Can a constructor be private in C++?',
        'code_snippet': null,
        'option_a': 'No, constructors must always be public', 'option_b': 'Yes, but then only friend functions or other static methods can create objects', 'option_c': 'Only for classes with virtual functions', 'option_d': 'Only for abstract classes',
        'correct_answer': 'B', 'explanation': 'A private constructor restricts who can create objects. This is used in singleton pattern and factory methods where controlled instance creation is desired.',
        'xp_reward': 5, 'is_seeded': 1
      },
    ];

    // Insert all Java questions
    for (final q in javaQuestions) {
      await txn.insert('questions', q);
    }

    // Insert all C++ questions
    for (final q in cppQuestions) {
      await txn.insert('questions', q);
    }
  }

  static Future<void> _seedBadges(Transaction txn) async {
    final badges = [
      {'name': 'First Blood', 'description': 'Complete your first quiz', 'icon_code': 0xe038, 'condition_type': 'quiz_count', 'condition_value': 1, 'is_earned': 0, 'earned_at': null},
      {'name': 'On Fire', 'description': 'Reach a 3-day streak', 'icon_code': 0xe410, 'condition_type': 'streak', 'condition_value': 3, 'is_earned': 0, 'earned_at': null},
      {'name': 'Week Warrior', 'description': 'Reach a 7-day streak', 'icon_code': 0xe430, 'condition_type': 'streak', 'condition_value': 7, 'is_earned': 0, 'earned_at': null},
      {'name': 'Half Century', 'description': 'Earn 500 XP', 'icon_code': 0xe8b6, 'condition_type': 'xp', 'condition_value': 500, 'is_earned': 0, 'earned_at': null},
      {'name': 'Java Journeyman', 'description': 'Answer 50 Java questions correctly', 'icon_code': 0xe8c9, 'condition_type': 'java_correct', 'condition_value': 50, 'is_earned': 0, 'earned_at': null},
      {'name': 'C++ Cadet', 'description': 'Answer 50 C++ questions correctly', 'icon_code': 0xe8c0, 'condition_type': 'cpp_correct', 'condition_value': 50, 'is_earned': 0, 'earned_at': null},
      {'name': 'Perfect Run', 'description': 'Get 100% on a 10-question quiz', 'icon_code': 0xe8dc, 'condition_type': 'perfect_score', 'condition_value': 10, 'is_earned': 0, 'earned_at': null},
      {'name': 'Loop Lord', 'description': 'Master the "loops" topic', 'icon_code': 0xe8d4, 'condition_type': 'topic_master', 'condition_value': 1, 'is_earned': 0, 'earned_at': null},
      {'name': 'Bug Slayer', 'description': 'Correct 10 previously wrong answers', 'icon_code': 0xe868, 'condition_type': 'retry_correct', 'condition_value': 10, 'is_earned': 0, 'earned_at': null},
      {'name': 'Algorithm Ace', 'description': 'Complete all 5 algorithm visualizations', 'icon_code': 0xe930, 'condition_type': 'algo_complete', 'condition_value': 5, 'is_earned': 0, 'earned_at': null},
    ];

    for (final badge in badges) {
      await txn.insert('badges', badge);
    }
  }

}