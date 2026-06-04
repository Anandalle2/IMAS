import 'api_service.dart';

class GPSService {

  static Future<Map<String,dynamic>>
  getLocation(dynamic vehicleId) async {

    try {

      final data = await ApiService.get(
        "/tracking/$vehicleId",
      );

      return data;

    } catch(e) {

      print(e);

      return {};
    }
  }

  static Future<List<dynamic>>
  getFleetLocations() async {

    try {

      final data = await ApiService.get(
        "/fleet-tracking",
      );

      return data;

    } catch(e) {

      print(e);

      return [];
    }
  }
}