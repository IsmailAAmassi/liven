import 'dart:async';

import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/app_api.dart';
import '../../../../core/network/endpoint_constants.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/models/settings_data.dart';
import '../../domain/models/terms_data.dart';
import '../../domain/repositories/settings_repository.dart';

class RealSettingsService implements SettingsRepository {
  RealSettingsService({
    required AppApi api,
    required LocalStorageService storage,
  })  : _api = api,
        _storage = storage;

  final AppApi _api;
  final LocalStorageService _storage;

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
    final result = await _api.get<Map<String, dynamic>>(
      Endpoints.settings,
      parser: _asMap,
    );

    return result.when(
      success: (payload) async {
        final data = _parseSettingsPayload(payload);
        if (data != null) {
          await _cacheSettings(data);
          return ApiSuccess(data);
        }
        return const ApiError(ApiFailure(messageKey: 'settings_load_error'));
      },
      failure: (error) => ApiError(_mapFailure(error, fallback: 'settings_load_error')),
    );
  }

  Future<TermsResult> _loadTermsFromApi() async {
    final result = await _api.get<Map<String, dynamic>>(
      Endpoints.terms,
      parser: _asMap,
    );

    return result.when(
      success: (payload) async {
        final data = _parseTermsPayload(payload);
        if (data != null) {
          await _cacheTerms(data);
          return ApiSuccess(data);
        }
        return const ApiError(ApiFailure(messageKey: 'terms_load_error'));
      },
      failure: (error) => ApiError(_mapFailure(error, fallback: 'terms_load_error')),
    );
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

  SettingsData? _parseSettingsPayload(Map<String, dynamic> payload) {
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

  TermsData? _parseTermsPayload(Map<String, dynamic> payload) {
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

  ApiException _mapFailure(ApiException error, {required String fallback}) {
    if (error is UnknownApiException) {
      return ApiFailure(statusCode: error.statusCode, messageKey: fallback);
    }
    return error;
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    return <String, dynamic>{};
  }
}
