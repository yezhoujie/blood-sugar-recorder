import 'dart:convert';

import 'package:crypto/crypto.dart';

String doSHA256Encode(String plantText) {
  String salt = '1234456';
  var byte = utf8.encode(plantText + salt);
  var digest = sha256.convert(byte);
  return digest.toString();
}
