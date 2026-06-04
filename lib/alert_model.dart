class AlertModel {

  final String type;
  final String severity;
  final String message;
  final String status;

  AlertModel({

    required this.type,
    required this.severity,
    required this.message,
    required this.status,

  });

  factory AlertModel.fromJson(
      Map<String,dynamic> json){

    return AlertModel(

      type:
      json["alert_type"] ?? "",

      severity:
      json["severity"] ?? "",

      message:
      json["message"] ?? "",

      status:
      json["status"] ?? "",

    );
  }

}