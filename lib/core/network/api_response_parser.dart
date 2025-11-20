class ApiResponseParser {
  const ApiResponseParser(this.data);

  final dynamic data;

  Map<String, dynamic> asMap() {
    if (data is Map<String, dynamic>) {
      return data as Map<String, dynamic>;
    }
    return <String, dynamic>{};
  }

  String? message() {
    final map = asMap();
    final rawMessage = map['message'] ?? map['msg'] ?? map['error'];
    if (rawMessage is String && rawMessage.isNotEmpty) {
      return rawMessage;
    }
    return null;
  }

  String? messageAr() {
    final map = asMap();
    final raw = map['message_ar'] ?? map['messageAr'];
    if (raw is String && raw.isNotEmpty) {
      return raw;
    }
    return null;
  }

  String? messageEn() {
    final map = asMap();
    final raw = map['message_en'] ?? map['messageEn'];
    if (raw is String && raw.isNotEmpty) {
      return raw;
    }
    return null;
  }

  List<String> errors() {
    final map = asMap();
    final rawErrors = map['errors'];
    if (rawErrors is List) {
      return rawErrors.whereType<String>().toList();
    }
    if (rawErrors is Map) {
      return rawErrors.values
          .whereType<List>()
          .expand((e) => e)
          .whereType<String>()
          .toList();
    }
    return const [];
  }

  Map<String, List<String>> validationErrors() {
    final map = asMap();
    final rawErrors = map['errors'];
    if (rawErrors is Map<String, dynamic>) {
      return rawErrors.map((key, value) {
        if (value is List) {
          return MapEntry(key, value.whereType<String>().toList());
        }
        if (value is String) {
          return MapEntry(key, <String>[value]);
        }
        return MapEntry(key, <String>[]);
      });
    }
    if (rawErrors is List) {
      return {
        'general': rawErrors.whereType<String>().toList(),
      };
    }
    return const {};
  }

  dynamic unwrapData() {
    final map = asMap();
    if (map.containsKey('data')) {
      return map['data'];
    }
    return data;
  }
}
