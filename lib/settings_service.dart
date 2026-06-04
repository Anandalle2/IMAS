import 'api_service.dart';

class SettingsService {

  static Future<Map<String,dynamic>>
  getSettings(int userId) async {

    return await ApiService.get(
        "/settings/$userId"
    );
  }

  static Future updateSettings(
      int userId,
      Map<String,dynamic> data) async {

    await ApiService.put(
        "/settings/$userId",
        data
    );
  }
}