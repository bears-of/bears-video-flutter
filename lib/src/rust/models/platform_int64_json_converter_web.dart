BigInt fromJson(Object value) => BigInt.parse(value.toString());

String toJson(BigInt value) => value.toString();

BigInt fromInt(int value) => BigInt.from(value);
