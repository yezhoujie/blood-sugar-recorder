///业务错误信息.
class ErrorData {
  static final Map<String, int> errorCodeMap = {
    "NOT_FOUND": 404,
    "INTERNAL_ERROR": 500,
  };

  int code;
  String message;
  StackTrace? stack;

  ErrorData({
    required this.code,
    required this.message,
    this.stack,
  });
}
