class Vehicle {

  final String? id;

  final String driverName;

  final String type;

  final String regNo;

  final String deviceId;

  final String phone;

  final String vin;

  Vehicle({

    this.id,

    required this.driverName,

    required this.type,

    required this.regNo,

    required this.deviceId,

    required this.phone,

    required this.vin,

  });

  Map<String,dynamic> toMap(){

    return{

      "driverName":
      driverName,

      "phone":
      phone,

      "type":
      type,

      "regNo":
      regNo,

      "deviceId":
      deviceId,

      "vin":
      vin,
    };
  }

  factory Vehicle.fromMap(

      Map<String,dynamic> map,

      String id){

    return Vehicle(

      id:id,

      driverName:

      map["driver_name"] ??
          map["driverName"] ??
          "",

      type:

      map["vehicle_type"] != null

          ? "${map["vehicle_type"]}"
          "${map["vehicle_subtype"] != null
          ? " - ${map["vehicle_subtype"]}"
          : ""}"

          : map["type"] ?? "",

      regNo:

      map["registration_number"] ??
          map["regNo"] ??
          "",

      deviceId:

      map["device_id"] ??
          map["deviceId"] ??
          "",

      phone:

      map["phone"] ??
          "",

      vin:

      map["vin"] ??
          "",
    );
  }
}