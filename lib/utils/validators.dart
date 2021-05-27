import 'package:quiver/strings.dart';

bool checkEmail(String input) {
  if (isEmpty(input)) {
    return false;
  }

  // 邮箱正则
  String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
  return RegExp(regexEmail).hasMatch(input);
}

bool checkStringLength(String input, int requiredLength) {
  if (isEmpty(input)) return false;

  return input.length >= requiredLength;
}
