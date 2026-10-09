// author: juraj.suchan@gmail.com

DateTime? parseApiTime(Object? value) {
  if (value is! String) return null;
  return DateTime.tryParse(value);
}

int? asInt(Object? v) =>
    v is num ? v.toInt() : (v is String ? int.tryParse(v) : null);

String? asString(Object? v) => v?.toString();

bool asBool(Object? v, {bool fallback = false}) => v is bool ? v : fallback;

Map<String, dynamic>? asMap(Object? v) =>
    v is Map ? Map<String, dynamic>.from(v) : null;

List<Map<String, dynamic>> asMapList(Object? v) => v is List
    ? v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
    : const [];
