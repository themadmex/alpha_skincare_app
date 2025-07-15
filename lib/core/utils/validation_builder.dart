// Validation result
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final List<String> errors;

  const ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.errors = const [],
  });

  const ValidationResult.valid() : this(isValid: true);

  const ValidationResult.invalid(String error) : this(
    isValid: false,
    errorMessage: error,
    errors: const [],
  );

  const ValidationResult.multipleErrors(List<String> errors) : this(
    isValid: false,
    errorMessage: errors.isNotEmpty ? errors.first : null,
    errors: errors,
  );
}

// Base validator interface
abstract class Validator {
  ValidationResult validate(String? value);
}

// Specific validators
class RequiredValidator implements Validator {
  final String? fieldName;

  const RequiredValidator({this.fieldName});

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult.invalid('${fieldName ?? 'This field'} is required');
    }
    return const ValidationResult.valid();
  }
}

class EmailValidator implements Validator {
  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.valid(); // Let required validator handle this
    }

    const emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailRegex).hasMatch(value)) {
      return const ValidationResult.invalid('Please enter a valid email address');
    }

    return const ValidationResult.valid();
  }
}

class PasswordValidator implements Validator {
  final int minLength;
  final bool requireUppercase;
  final bool requireLowercase;
  final bool requireNumber;
  final bool requireSpecialChar;

  const PasswordValidator({
    this.minLength = 6,
    this.requireUppercase = false,
    this.requireLowercase = false,
    this.requireNumber = false,
    this.requireSpecialChar = false,
  });

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.valid(); // Let required validator handle this
    }

    final errors = <String>[];

    if (value.length < minLength) {
      errors.add('Password must be at least $minLength characters long');
    }

    if (value.length > 128) {
      errors.add('Password must be less than 128 characters');
    }

    if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      errors.add('Password must contain at least one uppercase letter');
    }

    if (requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      errors.add('Password must contain at least one lowercase letter');
    }

    if (requireNumber && !value.contains(RegExp(r'[0-9]'))) {
      errors.add('Password must contain at least one number');
    }

    if (requireSpecialChar && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      errors.add('Password must contain at least one special character');
    }

    return errors.isEmpty
        ? const ValidationResult.valid()
        : ValidationResult.multipleErrors(errors);
  }
}

class LengthValidator implements Validator {
  final int? minLength;
  final int? maxLength;
  final String? fieldName;

  const LengthValidator({
    this.minLength,
    this.maxLength,
    this.fieldName,
  });

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.valid(); // Let required validator handle this
    }

    if (minLength != null && value.length < minLength!) {
      return ValidationResult.invalid(
          '${fieldName ?? 'This field'} must be at least $minLength characters long'
      );
    }

    if (maxLength != null && value.length > maxLength!) {
      return ValidationResult.invalid(
          '${fieldName ?? 'This field'} must be less than $maxLength characters'
      );
    }

    return const ValidationResult.valid();
  }
}

class RegexValidator implements Validator {
  final String pattern;
  final String errorMessage;

  const RegexValidator({
    required this.pattern,
    required this.errorMessage,
  });

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.valid(); // Let required validator handle this
    }

    if (!RegExp(pattern).hasMatch(value)) {
      return ValidationResult.invalid(errorMessage);
    }

    return const ValidationResult.valid();
  }
}

class AgeValidator implements Validator {
  final int minAge;
  final int maxAge;

  const AgeValidator({
    this.minAge = 13,
    this.maxAge = 120,
  });

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.valid(); // Let required validator handle this
    }

    final age = int.tryParse(value);
    if (age == null) {
      return const ValidationResult.invalid('Please enter a valid age');
    }

    if (age < minAge) {
      return ValidationResult.invalid('You must be at least $minAge years old');
    }

    if (age > maxAge) {
      return const ValidationResult.invalid('Please enter a valid age');
    }

    return const ValidationResult.valid();
  }
}

class ConfirmPasswordValidator implements Validator {
  final String? originalPassword;

  const ConfirmPasswordValidator({this.originalPassword});

  @override
  ValidationResult validate(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.invalid('Please confirm your password');
    }

    if (value != originalPassword) {
      return const ValidationResult.invalid('Passwords do not match');
    }

    return const ValidationResult.valid();
  }
}

// Validation builder with fluent interface
class ValidationBuilder {
  final List<Validator> _validators = [];

  ValidationBuilder required({String? fieldName}) {
    _validators.add(RequiredValidator(fieldName: fieldName));
    return this;
  }

  ValidationBuilder email() {
    _validators.add(const EmailValidator());
    return this;
  }

  ValidationBuilder password({
    int minLength = 6,
    bool requireUppercase = false,
    bool requireLowercase = false,
    bool requireNumber = false,
    bool requireSpecialChar = false,
  }) {
    _validators.add(PasswordValidator(
      minLength: minLength,
      requireUppercase: requireUppercase,
      requireLowercase: requireLowercase,
      requireNumber: requireNumber,
      requireSpecialChar: requireSpecialChar,
    ));
    return this;
  }

  ValidationBuilder strongPassword({int minLength = 8}) {
    _validators.add(PasswordValidator(
      minLength: minLength,
      requireUppercase: true,
      requireLowercase: true,
      requireNumber: true,
      requireSpecialChar: true,
    ));
    return this;
  }

  ValidationBuilder length({int? min, int? max, String? fieldName}) {
    _validators.add(LengthValidator(
      minLength: min,
      maxLength: max,
      fieldName: fieldName,
    ));
    return this;
  }

  ValidationBuilder regex(String pattern, String errorMessage) {
    _validators.add(RegexValidator(
      pattern: pattern,
      errorMessage: errorMessage,
    ));
    return this;
  }

  ValidationBuilder age({int min = 13, int max = 120}) {
    _validators.add(AgeValidator(minAge: min, maxAge: max));
    return this;
  }

  ValidationBuilder confirmPassword(String? originalPassword) {
    _validators.add(ConfirmPasswordValidator(originalPassword: originalPassword));
    return this;
  }

  ValidationBuilder phoneNumber() {
    _validators.add(const RegexValidator(
      pattern: r'^\+?[1-9]\d{1,14}$',
      errorMessage: 'Please enter a valid phone number',
    ));
    return this;
  }

  ValidationBuilder username() {
    _validators.add(const LengthValidator(minLength: 3, maxLength: 20, fieldName: 'Username'));
    _validators.add(const RegexValidator(
      pattern: r'^[a-zA-Z0-9_]+$',
      errorMessage: 'Username can only contain letters, numbers, and underscores',
    ));
    return this;
  }

  ValidationBuilder url() {
    _validators.add(const RegexValidator(
      pattern: r'^https?://.+\..+',
      errorMessage: 'Please enter a valid URL',
    ));
    return this;
  }

  ValidationBuilder number() {
    _validators.add(const RegexValidator(
      pattern: r'^\d+(\.\d+)?$',
      errorMessage: 'Please enter a valid number',
    ));
    return this;
  }

  ValidationBuilder custom(Validator validator) {
    _validators.add(validator);
    return this;
  }

  // Build the validator function
  String? Function(String?) build() {
    return (String? value) {
      for (final validator in _validators) {
        final result = validator.validate(value);
        if (!result.isValid) {
          return result.errorMessage;
        }
      }
      return null;
    };
  }

  // Build with multiple error support
  ValidationResult Function(String?) buildWithMultipleErrors() {
    return (String? value) {
      final errors = <String>[];

      for (final validator in _validators) {
        final result = validator.validate(value);
        if (!result.isValid) {
          if (result.errors.isNotEmpty) {
            errors.addAll(result.errors);
          } else if (result.errorMessage != null) {
            errors.add(result.errorMessage!);
          }
        }
      }

      return errors.isEmpty
          ? const ValidationResult.valid()
          : ValidationResult.multipleErrors(errors);
    };
  }
}

// Pre-built common validators
class CommonValidators {
  static String? Function(String?) get email => ValidationBuilder().required().email().build();

  static String? Function(String?) get password => ValidationBuilder().required().password().build();

  static String? Function(String?) get strongPassword => ValidationBuilder().required().strongPassword().build();

  static ValidationBuilder get name => ValidationBuilder()
      .required(fieldName: 'Name')
      .length(min: 2, max: 50, fieldName: 'Name')
      .regex(r'^[a-zA-Z\s\-\'\.]+$', 'Name contains invalid characters')
      .build();

  static String? Function(String?) get username => ValidationBuilder().required().username().build();

  static String? Function(String?) get phoneNumber => ValidationBuilder().required().phoneNumber().build();

  static String? Function(String?) get age => ValidationBuilder().required().age().build();

  static String? Function(String?) get url => ValidationBuilder().required().url().build();

  static String? Function(String?) confirmPassword(String? originalPassword) {
    return ValidationBuilder()
        .required()
        .confirmPassword(originalPassword)
        .build();
  }

  // App-specific validators
  static String? Function(String?) get skinType => ValidationBuilder()
      .required(fieldName: 'Skin type')
      .regex(r'^(normal|dry|oily|combination|sensitive)$', 'Please select a valid skin type')
      .build();

  static String? Function(String?) get gender => ValidationBuilder()
      .required(fieldName: 'Gender')
      .regex(r'^(male|female|other|prefer_not_to_say)$', 'Please select a valid gender')
      .build();
}

// Custom validators for specific use cases
class CustomValidator implements Validator {
  final ValidationResult Function(String?) _validationFunction;

  const CustomValidator(this._validationFunction);

  @override
  ValidationResult validate(String? value) {
    return _validationFunction(value);
  }
}

// Helper for creating custom validators
ValidationResult Function(String?) customValidator(bool Function(String?) test, String errorMessage) {
  return (String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.valid();
    }

    return test(value)
        ? const ValidationResult.valid()
        : ValidationResult.invalid(errorMessage);
  };
}