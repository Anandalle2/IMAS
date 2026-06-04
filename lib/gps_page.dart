import 'package:flutter/material.dart';
import 'vehicle_model.dart';
import 'mqtt_service.dart';
import 'gps_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GPSPage extends StatefulWidget {

  final Vehicle vehicle;

  const GPSPage({
    super.key,
    required this.vehicle,
  });

  @override
  State<GPSPage> createState() => _GPSPageState();
}

class _GPSPageState extends State<GPSPage> {
  Map gps={};
  final MapController _mapController = MapController();

  @override
  void initState(){

    super.initState();

    loadGPS();
    
    liveLatitude.addListener(_updateLiveLocation);
    liveLongitude.addListener(_updateLiveLocation);
    liveSpeed.addListener(_updateLiveLocation);
  }

  void _updateLiveLocation() {
    setState(() {
      gps["latitude"] = liveLatitude.value;
      gps["longitude"] = liveLongitude.value;
      gps["speed"] = liveSpeed.value;
    });
    
    if (gps["latitude"] != null && gps["longitude"] != null) {
      _mapController.move(
        LatLng((gps["latitude"] as num).toDouble(), (gps["longitude"] as num).toDouble()), 
        _mapController.camera.zoom
      );
    }
  }

  @override
  void dispose() {
    liveLatitude.removeListener(_updateLiveLocation);
    liveLongitude.removeListener(_updateLiveLocation);
    liveSpeed.removeListener(_updateLiveLocation);
    super.dispose();
  }

  void loadGPS() async{

    gps=await GPSService.getLocation(
        widget.vehicle.id ?? "1"
    );

    setState((){});
  }





  Widget mapButton(
      IconData icon){

    return Container(

      height:55,
      width:55,

      decoration:
      BoxDecoration(

        color:
        const Color(0xFF081B31),

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Icon(

        icon,

        color:
        Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context){

    Vehicle v=
        widget.vehicle;

    return Scaffold(

      backgroundColor:
      Colors.black,

      body: Stack(

        children:[

          Positioned.fill(

            child: Container(

              color:
              const Color(0xFF02111F),

              child:
              CustomPaint(

                painter:
                GridPainter(),
              ),
            ),
          ),

          SafeArea(

            child: Column(

              children:[

                Padding(

                  padding:
                  const EdgeInsets.all(20),

                  child: Row(

                    children:[

                      Container(

                        decoration:
                        BoxDecoration(

                          color:
                          const Color(
                              0xFF081B31),

                          borderRadius:
                          BorderRadius.circular(
                              18),
                        ),

                        child:
                        IconButton(

                          onPressed:(){

                            Navigator.pop(
                                context);

                          },

                          icon:
                          const Icon(

                            Icons.arrow_back_ios,

                            color:
                            Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(
                          width:15),

                      Expanded(

                        child:
                        Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children:[

                            const Text(

                              "GPS TRACKING",

                              style:
                              TextStyle(

                                color:
                                Colors.white,

                                fontSize:22,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            Text(

                              v.driverName,

                              style:
                              const TextStyle(

                                color:
                                Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(

                        padding:
                        const EdgeInsets.symmetric(

                          horizontal:18,
                          vertical:10,
                        ),

                        decoration:
                        BoxDecoration(

                          color:
                          const Color(
                              0xFF081B31),

                          borderRadius:
                          BorderRadius.circular(
                              15),
                        ),

                        child:
                        ValueListenableBuilder(

                            valueListenable:
                            MQTTService.isConnected,

                            builder:
                                (context,
                                connected,
                                child){

                              return Row(

                                children:[

                                  Icon(

                                    Icons.circle,

                                    color:

                                    connected
                                        ? Colors.green
                                        : Colors.red,

                                    size:10,
                                  ),

                                  const SizedBox(
                                      width:8),

                                  Text(

                                    connected
                                        ? "ONLINE"
                                        : "OFFLINE",

                                    style:
                                    TextStyle(

                                      color:

                                      connected
                                          ? Colors.green
                                          : Colors.red,

                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  )
                                ],
                              );
                            }),
                      )
                    ],
                  ),
                ),

                Expanded(

                  child: gps.isEmpty

                      ? const Center(
                      child: CircularProgressIndicator()
                  )

                      : Padding(

                    padding: const EdgeInsets.all(20),

                    child: ClipRRect(

                      borderRadius:
                      BorderRadius.circular(25),

                      child: FlutterMap(
                        mapController: _mapController,

                        options: MapOptions(

                          initialCenter: LatLng(

                            (gps["latitude"] != null) ? (gps["latitude"] as num).toDouble() : 17.385044,

                            (gps["longitude"] != null) ? (gps["longitude"] as num).toDouble() : 78.486671,
                          ),

                          initialZoom: 13,
                        ),

                        children:[

                          TileLayer(

                            urlTemplate:

                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",

                            userAgentPackageName:
                            "com.example.flutter_trial",
                          ),

                          MarkerLayer(

                            markers:[

                              if (gps["latitude"] != null && gps["longitude"] != null)
                                Marker(

                                  point: LatLng(

                                    (gps["latitude"] as num).toDouble(),

                                    (gps["longitude"] as num).toDouble(),
                                  ),

                                width:80,

                                height:80,

                                child: const Icon(

                                  Icons.location_pin,

                                  color: Colors.red,

                                  size:50,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                Container(

                  height:220,

                  margin:
                  const EdgeInsets.all(
                      20),

                  padding:
                  const EdgeInsets.all(
                      15),

                  decoration:
                  BoxDecoration(

                    gradient:
                    const LinearGradient(

                      colors:[

                        Color(0xFF081B31),

                        Color(0xFF111827),
                      ],
                    ),

                    borderRadius:
                    BorderRadius.circular(
                        30),
                  ),

                  child: Column(

                    children:[

                      ListTile(

                        leading:
                        Container(

                          padding:
                          const EdgeInsets.all(
                              10),

                          decoration:
                          BoxDecoration(

                            color:
                            Colors.cyanAccent,

                            borderRadius:
                            BorderRadius.circular(
                                15),
                          ),

                          child:
                          const Icon(

                            Icons.directions_car,

                            color:
                            Colors.black,
                          ),
                        ),

                        title:
                        Text(

                          v.driverName,

                          style:
                          const TextStyle(

                            color:
                            Colors.white,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        subtitle: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                           children:[

                            Text(
                              "Vehicle : ${v.type}",
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            Text(
                              "Location : ${gps["location"] ?? ""}",
                              style: const TextStyle(
                                color: Colors.cyanAccent,
                              ),
                            ),

                          ],
                        ),
                      ),

                      const Divider(),

                      Row(

                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,

                        children:[

                          Column(

                            children:[

                              Text(

                                "${gps["speed"] ?? 0}",

                                style: const TextStyle(

                                  color: Colors.cyanAccent,
                                  fontSize:28,

                                ),
                              ),

                              const Text(

                                "km/h",

                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),

                          Column(

                            children:[

                              Text(

                                "${gps["latitude"] ?? "--"}",

                                style: const TextStyle(

                                  color: Colors.white,
                                  fontSize:20,
                                ),
                              ),

                              const Text(

                                "LAT",

                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),

                          Column(

                            children:[

                              Text(

                                "${gps["longitude"] ?? "--"}",

                                style: const TextStyle(

                                  color: Colors.white,
                                  fontSize:20,
                                ),
                              ),

                              const Text(

                                "LONG",

                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),

                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          Positioned(

            right:20,
            top:180,

            child:
            Column(

              children:[

                mapButton(
                    Icons.gps_fixed),

                const SizedBox(
                    height:15),

                mapButton(
                    Icons.add),

                const SizedBox(
                    height:15),

                mapButton(
                    Icons.remove),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {

  @override
  void paint(
      Canvas canvas,
      Size size){

    Paint paint=Paint()

      ..color=
      Colors.cyan.withOpacity(.08)

      ..strokeWidth=1;

    for(
    double i=0;
    i<size.width;
    i+=40){

      canvas.drawLine(

        Offset(i,0),

        Offset(i,size.height),

        paint,
      );
    }

    for(
    double i=0;
    i<size.height;
    i+=40){

      canvas.drawLine(

        Offset(0,i),

        Offset(size.width,i),

        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      CustomPainter oldDelegate){

    return false;
  }
}