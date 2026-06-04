import 'package:flutter/material.dart';
import 'api_service.dart';

class AlertService {

  static ValueNotifier<
  List<Map<String,dynamic>>>

  alerts=

  ValueNotifier([]);

  static void addAlert({

    required String vehicle,

    required String status,

  }){

    bool alreadyExists=

    alerts.value.any(

            (alert)=>

        alert["vehicle"]==vehicle &&

            alert["type"]==

                (status=="DROWSY"

                    ? "DMS"

                    : status=="SOS"

                    ? "SOS"

                    : "FCW")

    );

    if(alreadyExists){
      return;
    }

    List<Map<String,dynamic>>
    current=

    List.from(alerts.value);

    current.insert(0,{

      "vehicle":
      vehicle,

      "type":

      status=="DROWSY"

          ? "DMS"

          : status=="SOS"

          ? "SOS"

          : "FCW",

      "title":

      status=="DROWSY"

          ? "Driver Drowsy"

          : status=="SOS"

          ? "SOS Emergency Activated"

          : "Collision Warning",

      "critical":
      true,

      "time":
      "NOW",

      "icon":

      status=="DROWSY"

          ? Icons.face

          : status=="SOS"

          ? Icons.sos

          : Icons.car_crash,
    });

    alerts.value=current;
    final alertType=

    status=="DROWSY"

        ? "Driver Drowsy"

        : status=="SOS"

        ? "SOS Emergency Activated"

        : "Collision Warning";

    final source=

    status=="DROWSY"

        ? "DMS"

        : status=="SOS"

        ? "SOS"

        : "FCW";


    ApiService.post(

        "/add-alert",

        {

          "vehicle_id":1,

          "alert_type":
          alertType,

          "severity":
          "High",

          "message":
          alertType,

          "source":
          source,

          "status":
          "active"

        });
  }
  // GET ALERTS FROM BACKEND
  static Future<
      List<Map<String,dynamic>>>

  getAlerts() async {

    try{

      final data=

      await ApiService.get(
          "/alerts"
      );

      print(
          "ALERTS:"
      );

      print(data);

      return List<Map<String,dynamic>>
          .from(data);

    }

    catch(e){

      print(
          "ALERT ERROR:"
      );

      print(e);

      return [];

    }

  }

}