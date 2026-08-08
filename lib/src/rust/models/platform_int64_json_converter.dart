import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:json_annotation/json_annotation.dart';

import 'platform_int64_json_converter_io.dart'
    if (dart.library.js_interop) 'platform_int64_json_converter_web.dart'
    as platform;

class PlatformInt64JsonConverter
    implements JsonConverter<PlatformInt64, Object> {
  const PlatformInt64JsonConverter();

  @override
  PlatformInt64 fromJson(Object json) => platform.fromJson(json);

  @override
  Object toJson(PlatformInt64 object) => platform.toJson(object);
}

PlatformInt64 platformInt64FromInt(int value) => platform.fromInt(value);
