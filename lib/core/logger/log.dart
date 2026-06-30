import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// 调试日志
  static void debug(dynamic message) {
    if (!kDebugMode) return;
    _logger.d(message);
  }

  /// 普通信息日志
  static void info(dynamic message) {
    if (!kDebugMode) return;
    _logger.i(message);
  }

  /// 警告日志
  static void warning(dynamic message) {
    if (!kDebugMode) return;
    _logger.w(message);
  }

  /// 错误日志
  static void error(dynamic message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// 打印较长文本，避免控制台截断
  static void longText(String text, {int chunkSize = 800}) {
    if (!kDebugMode) return;

    for (int i = 0; i < text.length; i += chunkSize) {
      final end = i + chunkSize < text.length ? i + chunkSize : text.length;
      _logger.d(text.substring(i, end));
    }
  }

  /// 格式化打印 JSON 字符串
  static void jsonText(String jsonText, {int chunkSize = 800}) {
    if (!kDebugMode) return;

    try {
      final obj = jsonDecode(jsonText);
      final prettyJson = const JsonEncoder.withIndent('  ').convert(obj);
      longText(prettyJson, chunkSize: chunkSize);
    } catch (_) {
      longText(jsonText, chunkSize: chunkSize);
    }
  }

  /// 打印接口响应
  static void apiResponse(String tag, String response) {
    if (!kDebugMode) return;

    info('[$tag] response:');
    jsonText(response);
  }

  /// 打印接口请求
  static void apiRequest(String tag, dynamic params) {
    if (!kDebugMode) return;

    info('[$tag] request: $params');
  }
}
