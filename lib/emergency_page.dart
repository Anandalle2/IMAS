import 'dart:convert';
import 'package:flutter/material.dart';
import 'mqtt_service.dart';
import 'alert_service.dart';
import 'package:mqtt_client/mqtt_client.dart';

class EmergencyPage extends StatefulWidget {

  final String vehicle;

  final String driver;

  final String phone;


  const EmergencyPage({

    super.key,

    required this.vehicle,
    required this.driver,
    required this.phone,
  });

  @override
  State<EmergencyPage> createState() =>
      _EmergencyPageState();
}

class _EmergencyPageState
    extends State<EmergencyPage>{

  bool activated=false;

  void triggerSOS() async{

    bool? confirm=

    await showDialog(

        context:context,

        builder:(context){

          return AlertDialog(

            backgroundColor:
            const Color(0xFF071D31),

            title:
            const Text(

              "Emergency Alert",

              style:
              TextStyle(
                color:Colors.white,
              ),
            ),

            content:
            const Text(

              "Do you want to send emergency alert?",

              style:
              TextStyle(
                color:Colors.white70,
              ),
            ),

            actions:[

              TextButton(

                onPressed:(){

                  Navigator.pop(
                      context,
                      false);

                },

                child:
                const Text(
                  "No",
                ),
              ),

              ElevatedButton(

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.red,
                ),

                onPressed:(){

                  Navigator.pop(
                      context,
                      true);

                },

                child:
                const Text(
                  "Yes",
                ),
              )
            ],
          );
        });

    if(confirm!=true)return;

    setState((){

      activated=true;

    });

    bool alreadyExists=

    AlertService.alerts.value.any(

            (alert)=>

        alert["type"]=="SOS"

            &&

            alert["vehicle"]==
                widget.vehicle

    );

    if(!alreadyExists){

      AlertService.addAlert(

        vehicle:
        widget.vehicle,

        status:
        "SOS",
      );
    }

    final builder=
    MqttClientPayloadBuilder();

    builder.addString(

        jsonEncode({

          "vehicle":
          widget.vehicle,

          "driver":
          widget.driver,

          "phone":
          widget.phone,

          "status":
          "SOS",

          "time":
          DateTime.now()
              .toString()

        })
    );

    MQTTService.client.publishMessage(

      "imas/sos",

      MqttQos.atLeastOnce,

      builder.payload!,
    );

    ScaffoldMessenger.of(context)

        .showSnackBar(

      const SnackBar(

        backgroundColor:
        Colors.red,

        content:
        Text(
          "Emergency Alert Sent",
        ),
      ),
    );
  }

  Widget serviceCard(

      String title,
      String number,
      IconData icon,
      Color color){

    return Expanded(

      child:Container(

        margin:
        const EdgeInsets.only(
            right:10),

        padding:
        const EdgeInsets.all(
            15),

        decoration:
        BoxDecoration(

          color:
          const Color(
              0xFF081B31),

          borderRadius:
          BorderRadius.circular(
              25),
        ),

        child:
        Column(

          children:[

            CircleAvatar(

              radius:30,

              backgroundColor:
              color,

              child:
              Icon(
                icon,
                color:
                Colors.white,
              ),
            ),

            const SizedBox(
                height:12),

            Text(

              title,

              style:
              const TextStyle(
                color:
                Colors.white,
              ),
            ),

            Text(

              number,

              style:
              TextStyle(

                color:
                color,

                fontSize:28,

                fontWeight:
                FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context){

    return Scaffold(

      backgroundColor:
      Colors.black,

      body:
      SafeArea(

        child:
        SingleChildScrollView(

          padding:
          const EdgeInsets.all(
              20),

          child:
          Column(

            children:[

              Row(

                children:[

                  IconButton(

                    onPressed:(){

                      Navigator.pop(context);

                    },

                    icon:
                    const Icon(

                      Icons.arrow_back,

                      color:
                      Colors.white,
                    ),
                  ),

                  const SizedBox(
                      width:10),

                  Expanded(

                    child:
                    Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children:[

                        const Text(

                          "EMERGENCY RESPONSE",

                          maxLines:1,

                          overflow:
                          TextOverflow.ellipsis,

                          style:
                          TextStyle(

                            color:
                            Colors.white,

                            fontSize:24,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        Text(

                          widget.vehicle,

                          style:
                          const TextStyle(

                            color:
                            Colors.grey,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(
                  height:40),

              GestureDetector(

                onLongPress:
                triggerSOS,

                child:
                Container(

                  height:240,
                  width:240,

                  decoration:
                  BoxDecoration(

                    shape:
                    BoxShape.circle,

                    gradient:
                    RadialGradient(

                      colors:[

                        Colors.red,

                        Colors.red.shade900,
                      ],
                    ),

                    boxShadow:[

                      BoxShadow(

                        color:
                        Colors.red
                            .withAlpha(120),

                        blurRadius:
                        40,

                        spreadRadius:
                        20,
                      )
                    ],
                  ),

                  child:
                  const Column(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children:[

                      Icon(

                        Icons.sos,

                        color:
                        Colors.white,

                        size:70,
                      ),

                      SizedBox(
                          height:15),

                      Text(

                        "SOS",

                        style:
                        TextStyle(

                          color:
                          Colors.white,

                          fontSize:40,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(
                  height:20),

              const Text(

                "HOLD TO ACTIVATE",

                style:
                TextStyle(

                  color:
                  Colors.grey,

                  letterSpacing:4,
                ),
              ),

              const SizedBox(
                  height:30),

              Container(

                padding:
                const EdgeInsets.all(
                    20),

                decoration:
                BoxDecoration(

                  color:
                  const Color(
                      0xFF081B31),

                  borderRadius:
                  BorderRadius.circular(
                      25),
                ),

                child:
                Row(

                  children:[

                    const CircleAvatar(

                      radius:35,

                      backgroundColor:
                      Colors.cyan,

                      child:
                      Icon(
                        Icons.local_shipping,
                      ),
                    ),

                    const SizedBox(
                        width:20),

                    Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children:[

                        Text(

                          widget.vehicle,

                          style:
                          const TextStyle(

                            color:
                            Colors.white,

                            fontSize:28,
                          ),
                        ),

                        Text(

                          widget.driver,

                          style:
                          const TextStyle(
                            color:
                            Colors.grey,
                          ),
                        ),

                        Text(

                          widget.phone,

                          style:
                          const TextStyle(

                            color:
                            Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(
                  height:40),

              const Row(

                children:[

                  SizedBox(

                    height:30,
                    width:5,

                    child:
                    DecoratedBox(

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.red,

                        borderRadius:
                        BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width:12),

                  Text(

                    "EMERGENCY CONTACTS",

                    style:
                    TextStyle(

                      color:
                      Colors.redAccent,

                      fontSize:18,

                      fontWeight:
                      FontWeight.bold,

                      letterSpacing:4,
                    ),
                  )
                ],
              ),

              const SizedBox(
                  height:20),

              Row(

                children:[

                  serviceCard(
                    "Police",
                    "100",
                    Icons.shield,
                    Colors.blue,
                  ),

                  serviceCard(
                    "Ambulance",
                    "108",
                    Icons.medical_services,
                    Colors.red,
                  ),
                ],
              ),

              const SizedBox(
                  height:10),

              Row(

                children:[

                  serviceCard(
                    "Fire",
                    "101",
                    Icons.local_fire_department,
                    Colors.orange,
                  ),

                  serviceCard(
                    "Help",
                    "112",
                    Icons.support_agent,
                    Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}