import '../../../../core/network/api_result.dart';
import '../models/settings_data.dart';
import '../models/terms_data.dart';

typedef SettingsResult = ApiResult<SettingsData>;
typedef TermsResult = ApiResult<TermsData>;

abstract interface class SettingsRepository {
  Future<SettingsResult> fetchSettings({bool forceRefresh = false});

  Future<TermsResult> fetchTerms({bool forceRefresh = false});
}
