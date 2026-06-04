import 'vehicle_model.dart';

class VehicleService {
  // In-memory mock database for vehicles since the backend API doesn't support it yet
  static final List<Vehicle> _mockVehicles = [];
  static int _nextId = 1;

  // ADD VEHICLE
  static Future addVehicle(Vehicle vehicle) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    _mockVehicles.add(
      Vehicle(
        id: (_nextId++).toString(),
        driverName: vehicle.driverName,
        type: vehicle.type,
        regNo: vehicle.regNo,
        vin: vehicle.vin,
        deviceId: vehicle.deviceId,
        phone: vehicle.phone,
      )
    );
  }

  // GET VEHICLES
  static Future<List<Vehicle>> getVehicles() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockVehicles);
  }

  // DELETE VEHICLE
  static Future deleteVehicle(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockVehicles.removeWhere((v) => v.id == id);
  }
}