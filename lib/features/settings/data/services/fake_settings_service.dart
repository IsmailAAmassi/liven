import 'dart:async';

import '../../../../core/network/api_result.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/models/settings_data.dart';
import '../../domain/models/terms_data.dart';
import '../../domain/repositories/settings_repository.dart';

class FakeSettingsService implements SettingsRepository {
  FakeSettingsService({required LocalStorageService storage}) : _storage = storage;

  final LocalStorageService _storage;

  static const _delay = Duration(milliseconds: 250);

  static const _defaultSettings = SettingsData(
    baseUrl: 'https://liven-sa.com',
    appUrl: 'https://app.liven-sa.com',
    paths: SettingsPaths(
      ticketsPath: '/inquiries-list',
      profilePath: '/profile',
      homePath: '/',
      foodPlanPath: '/food-plan',
      weightStatisticsPath: '/weight-statistics',
    ),
  );

  static const _defaultTerms = TermsData(
    id: 1,
    htmlContent:
        '<h2>Demo Terms</h2><p>These are placeholder terms for local development.</p>',
  );

  @override
  Future<SettingsResult> fetchSettings({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _readCachedSettings();
      if (cached != null) {
        return ApiSuccess(cached);
      }
    }
    await Future.delayed(_delay);
    await _cacheSettings(_defaultSettings);
    return const ApiSuccess(_defaultSettings);
  }

  @override
  Future<TermsResult> fetchTerms({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _readCachedTerms();
      if (cached != null) {
        return ApiSuccess(cached);
      }
    }
    await Future.delayed(_delay);
    await _cacheTerms(_defaultTerms);
    return const ApiSuccess(_defaultTerms);
  }

  Future<SettingsData?> _readCachedSettings() async {
    final cached = await _storage.getSettingsCache();
    if (cached == null) {
      return null;
    }
    return SettingsData.fromJson(cached);
  }

  Future<void> _cacheSettings(SettingsData data) {
    return _storage.saveSettingsCache(data.toJson());
  }

  Future<TermsData?> _readCachedTerms() async {
    final cached = await _storage.getTermsCache();
    if (cached == null) {
      return null;
    }
    return TermsData.fromJson(cached);
  }

  Future<void> _cacheTerms(TermsData data) {
    return _storage.saveTermsCache(data.toJson());
  }
}
