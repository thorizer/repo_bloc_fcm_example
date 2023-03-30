/* We are using package:formz to create reusable and standard models 
for the username and password. For simplicity, 
we are just validating the username to ensure that 
it is not empty but in practice you can enforce special character usage
, length, etc...*/

import 'package:formz/formz.dart';

enum UsernameValidationError { empty }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([String value = '']) : super.dirty(value);

  @override
  UsernameValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : UsernameValidationError.empty;
  }
}
