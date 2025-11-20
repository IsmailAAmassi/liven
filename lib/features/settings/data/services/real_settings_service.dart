import 'dart:async';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_error_mapper.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/models/settings_data.dart';
import '../../domain/models/terms_data.dart';
import '../../domain/repositories/settings_repository.dart';

class RealSettingsService implements SettingsRepository {
  RealSettingsService({
    required ApiClient apiClient,
    required LocalStorageService storage,
    required ApiErrorMapper errorMapper,
  })  : _apiClient = apiClient,
        _storage = storage,
        _errorMapper = errorMapper;

  final ApiClient _apiClient;
  final LocalStorageService _storage;
  final ApiErrorMapper _errorMapper;

  static const _settingsPath = '/mobile/setting/tabs';
  static const _termsPath = '/mobile/setting/conditions';

  @override
  Future<SettingsResult> fetchSettings({bool forceRefresh = false}) async {
    final cached = await _readCachedSettings();
    if (!forceRefresh && cached != null) {
      unawaited(_refreshSettingsSilently());
      return ApiSuccess(cached);
    }

    final result = await _loadSettingsFromApi();
    if (result is ApiError<SettingsData> && cached != null) {
      // Prefer stale-but-usable data when the network fails.
      return ApiSuccess(cached);
    }
    return result;
  }

  @override
  Future<TermsResult> fetchTerms({bool forceRefresh = false}) async {
    final cached = await _readCachedTerms();
    if (!forceRefresh && cached != null) {
      unawaited(_refreshTermsSilently());
      return ApiSuccess(cached);
    }

    final result = await _loadTermsFromApi();
    if (result is ApiError<TermsData> && cached != null) {
      return ApiSuccess(cached);
    }
    return result;
  }

  Future<SettingsResult> _loadSettingsFromApi() async {
    try {
      final response = await _apiClient.get(_settingsPath);
      if (response.isSuccessful) {
        final data = _parseSettingsPayload(response.data);
        if (data != null) {
          await _cacheSettings(data);
          return ApiSuccess(data);
        }
      }
      final failure = _mapFailure(
        response.statusCode,
        response.data,
        fallback: 'settings_load_error',
      );
      return ApiError(failure);
    } catch (_) {
      return const ApiError(ApiFailure(messageKey: 'settings_load_error'));
    }
  }

  Future<TermsResult> _loadTermsFromApi() async {
    try {
      final response = await _apiClient.get(_termsPath);
      if (response.isSuccessful) {
        final data = _parseTermsPayload(response.data);
        if (data != null) {
          await _cacheTerms(data);
          return ApiSuccess(data);
        }
      }
      final failure = _mapFailure(
        response.statusCode,
        response.data,
        fallback: 'terms_load_error',
      );
      return ApiError(failure);
    } catch (_) {
      return const ApiError(ApiFailure(messageKey: 'terms_load_error'));
    }
  }

  Future<void> _refreshSettingsSilently() async {
    final result = await _loadSettingsFromApi();
    if (result is ApiSuccess<SettingsData>) {
      await _cacheSettings(result.data);
    }
  }

  Future<void> _refreshTermsSilently() async {
    final result = await _loadTermsFromApi();
    if (result is ApiSuccess<TermsData>) {
      await _cacheTerms(result.data);
    }
  }

  SettingsData? _parseSettingsPayload(dynamic payload) {
    if (payload is! Map<String, dynamic>) {
      return null;
    }
    final status = payload['status'];
    if (status is bool && status == false) {
      return null;
    }
    final data = payload['data'];
    if (data is Map<String, dynamic>) {
      return SettingsData.fromJson(data);
    }
    return null;
  }

  TermsData? _parseTermsPayload(dynamic payload) {
    if (payload is! Map<String, dynamic>) {
      return null;
    }
    final status = payload['status'];
    if (status is bool && status == false) {
      return null;
    }
    final data = payload['data'];
    if (data is Map<String, dynamic>) {
      return TermsData.fromJson(data);
    }
    return null;
  }

  Future<SettingsData?> _readCachedSettings() async {
    final cached = await _storage.getSettingsCache();
    if (cached == null) {
      return null;
    }
    try {
      return SettingsData.fromJson(cached);
    } catch (_) {
      return null;
    }
  }

  Future<void> _cacheSettings(SettingsData data) {
    return _storage.saveSettingsCache(data.toJson());
  }

  Future<TermsData?> _readCachedTerms() async {
    final cached = await _storage.getTermsCache();
    if (cached == null) {
      return null;
    }
    try {
      return TermsData.fromJson(cached);
    } catch (_) {
      return null;
    }
  }

  Future<void> _cacheTerms(TermsData data) {
    return _storage.saveTermsCache(data.toJson());
  }

  ApiFailure _mapFailure(int? statusCode, dynamic body, {required String fallback}) {
    final mapped = _errorMapper.map(statusCode, body);
    if (mapped.messageKey == 'error_unknown') {
      return ApiFailure(statusCode: statusCode, messageKey: fallback);
    }
    return mapped;
  }
}
