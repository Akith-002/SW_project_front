import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:land_asset_valuation/application/core/validators/inspection_validator.dart';

void main() {
  group('InspectionValidator Tests', () {
    group('required field validation', () {
      test('should return null for valid non-empty input', () {
        // Act
        final result =
            InspectionValidator.required('Valid input', 'Test Field');

        // Assert
        expect(result, isNull);
      });

      test('should return error message for null input', () {
        // Act
        final result = InspectionValidator.required(null, 'Test Field');

        // Assert
        expect(result, equals('Test Field is required'));
      });

      test('should return error message for empty input', () {
        // Act
        final result = InspectionValidator.required('', 'Test Field');

        // Assert
        expect(result, equals('Test Field is required'));
      });

      test('should return error message for whitespace-only input', () {
        // Act
        final result = InspectionValidator.required('   ', 'Test Field');

        // Assert
        expect(result, equals('Test Field is required'));
      });
    });

    group('optional alphanumeric validation', () {
      test('should return null for valid input within length limit', () {
        // Act
        final result = InspectionValidator.optionalAlphaNum(
            'Valid input 123', 50, 'Test Field');

        // Assert
        expect(result, isNull);
      });

      test('should return null for empty input', () {
        // Act
        final result =
            InspectionValidator.optionalAlphaNum('', 50, 'Test Field');

        // Assert
        expect(result, isNull);
      });

      test('should return null for null input', () {
        // Act
        final result =
            InspectionValidator.optionalAlphaNum(null, 50, 'Test Field');

        // Assert
        expect(result, isNull);
      });

      test('should return error for input exceeding length limit', () {
        // Arrange
        final longInput = 'a' * 51; // 51 characters

        // Act
        final result =
            InspectionValidator.optionalAlphaNum(longInput, 50, 'Test Field');

        // Assert
        expect(result, equals('Test Field cannot exceed 50 characters'));
      });
    });

    group('dropdown validation', () {
      test('should return null for valid selection', () {
        // Act
        final result = InspectionValidator.validateDropdown(
            'Valid Selection', 'Test Dropdown');

        // Assert
        expect(result, isNull);
      });

      test('should return error message for null selection', () {
        // Act
        final result =
            InspectionValidator.validateDropdown(null, 'Test Dropdown');

        // Assert
        expect(result, equals('Please select a Test Dropdown'));
      });

      test('should return error message for empty selection', () {
        // Act
        final result =
            InspectionValidator.validateDropdown('', 'Test Dropdown');

        // Assert
        expect(result, equals('Please select a Test Dropdown'));
      });

      test('should return null for whitespace-only selection', () {
        // Act
        final result =
            InspectionValidator.validateDropdown('   ', 'Test Dropdown');

        // Assert
        expect(result, isNull);
      });
    });
  });

  group('Form Validation Integration Tests', () {
    testWidgets('should validate required text fields correctly',
        (tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                validator: (value) =>
                    InspectionValidator.required(value, 'Master File'),
              ),
            ),
          ),
        ),
      );

      // Act - Leave field empty and validate
      final isValid = formKey.currentState?.validate();

      // Assert
      expect(isValid, isFalse);
    });

    testWidgets('should pass validation with valid input', (tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                validator: (value) =>
                    InspectionValidator.required(value, 'Master File'),
              ),
            ),
          ),
        ),
      );

      // Act - Enter valid text and validate
      await tester.enterText(find.byType(TextFormField), 'MF001');
      final isValid = formKey.currentState?.validate();

      // Assert
      expect(isValid, isTrue);
    });
  });
}
