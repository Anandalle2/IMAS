import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'fleet_page.dart';
import 'gps_service.dart';
import 'vehicle_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'mqtt_service.dart';

class FleetMapPage extends StatefulWidget {
  const FleetMapPage({super.key});

  @override
  State<FleetMapPage> createState() => _FleetMapPageState();
}

class _FleetMapPageState extends State<FleetMapPage> {

  String selectedFilter="All";

  List vehicles=[];

  List gpsVehicles=[];
  
  final MapController _mapController = MapController();

  @override
  void initState(){

    super.initState();

    loadFleetLocations();
    
    liveLatitude.addListener(_updateLiveLocation);
    liveLongitude.addListener(_updateLiveLocation);
    liveSpeed.addListener(_updateLiveLocation);
  }

  void _updateLiveLocation() {
    if (gpsVehicles.isNotEmpty) {
      setState(() {
        gpsVehicles[0]["latitude"] = liveLatitude.value;
        gpsVehicles[0]["longitude"] = liveLongitude.value;
        gpsVehicles[0]["speed"] = liveSpeed.value;
      });
      
      _mapController.move(
        LatLng(liveLatitude.value, liveLongitude.value), 
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

  void loadFleetLocations() async{

    gpsVehicles =

    await GPSService
        .getFleetLocations();
    print(gpsVehicles);

    setState(() {});
  }

  Widget filterButton(String text){

    bool selected=
        selectedFilter==text;

    return GestureDetector(

      onTap:(){

        setState(() {

          selectedFilter=text;

        });
      },

      child: Container(

        margin:
        const EdgeInsets.only(right:10),

        padding:
        const EdgeInsets.symmetric(

          horizontal:18,
          vertical:10,
        ),

        decoration: BoxDecoration(

          color: selected
              ? Colors.cyanAccent
              : const Color(0xFF071D31),

          borderRadius:
          BorderRadius.circular(20),
        ),

        child: Text(

          text,

          style: TextStyle(

            color:
            selected
                ? Colors.black
                : Colors.white,

            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:
      const Color(0xFF02111F),

      bottomNavigationBar:
      buildBottomNav(),

      body: SafeArea(

        child: Padding(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children:[

              const SizedBox(height:10),

              const Text(

                "LIVE MAP",

                style: TextStyle(

                  color: Colors.cyanAccent,

                  letterSpacing:4,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height:10),

              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children:[

                  const Text(

                    "My Fleet",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize:45,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  Container(

                    padding:
                    const EdgeInsets.symmetric(

                      horizontal:15,
                      vertical:10,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.green
                          .withOpacity(.15),

                      borderRadius:
                      BorderRadius.circular(18),
                    ),

                    child:
                     Row(

                      children:[

                        Icon(
                          Icons.circle,
                          color: Colors.greenAccent,
                          size:10,
                        ),

                        SizedBox(width:8),

                        Text(

                          "${gpsVehicles.length} LIVE",

                          style: TextStyle(

                            color:
                            Colors.greenAccent,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height:25),

              Row(

                children:[

                  filterButton("All"),

                  filterButton("Online"),

                  filterButton("Offline"),
                ],
              ),

              const SizedBox(height:25),

              Expanded(

                child: SingleChildScrollView(

                  child: Column(

                    children:[

                      SizedBox(

                        height:350,

                        child:
                        ClipRRect(

                          borderRadius:
                          BorderRadius.circular(30),

                          child:
                          FlutterMap(
                            mapController: _mapController,

                            options: MapOptions(

                              initialCenter: LatLng(

                                (gpsVehicles.isNotEmpty && gpsVehicles[0]["latitude"] != null)
                                    ? (gpsVehicles[0]["latitude"] as num).toDouble()
                                    : 17.385044,

                                (gpsVehicles.isNotEmpty && gpsVehicles[0]["longitude"] != null)
                                    ? (gpsVehicles[0]["longitude"] as num).toDouble()
                                    : 78.486671,
                              ),

                              initialZoom: 8,
                            ),

                            children:[

                              TileLayer(

                                urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

                                userAgentPackageName:
                                'com.example.flutter_trial',
                              ),

                              MarkerLayer(

                                markers:

                                gpsVehicles.where((gps) => gps["latitude"] != null && gps["longitude"] != null).map((gps){

                                  return Marker(

                                    point: LatLng(

                                      (gps["latitude"] as num).toDouble(),

                                      (gps["longitude"] as num).toDouble(),
                                    ),

                                    width:80,

                                    height:80,

                                    child: Column(

                                      children:[

                                        const Icon(

                                          Icons.location_pin,

                                          color: Colors.red,

                                          size:40,
                                        ),

                                        Text(

                                          gps["driver"],

                                          style: const TextStyle(

                                            color: Colors.white,

                                            fontSize:10,
                                          ),
                                        )
                                      ],
                                    ),
                                  );

                                }).toList(),
                              )
                            ],
                          )
                        ),
                      ),

                      const SizedBox(height:30),

                      Column(

                        children:

                        gpsVehicles.where((v){

                          if(selectedFilter=="Online"){
                            return v["status"]=="online";
                          }

                          if(selectedFilter=="Offline"){
                            return v["status"]=="offline";
                          }

                          return true;

                        }).map((gps){

                          return Container(

                            margin:
                            const EdgeInsets.only(
                                bottom:15),

                            padding:
                            const EdgeInsets.all(25),

                            decoration:
                            BoxDecoration(

                              color:
                              const Color(0xFF071D31),

                              borderRadius:
                              BorderRadius.circular(25),
                            ),

                            child: Row(

                              children:[

                                const Icon(
                                  Icons.location_on,
                                  color:
                                  Colors.greenAccent,
                                ),

                                const SizedBox(width:15),

                                Expanded(

                                  child: Column(

                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                    children:[

                                      Text(

                                        gps["driver"],

                                        style:
                                        const TextStyle(

                                          color:
                                          Colors.white,

                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),

                                      Text(

                                        (gps["latitude"] != null && gps["longitude"] != null) 
                                            ? "Lat: ${(gps["latitude"] as num).toStringAsFixed(4)}  |  Lon: ${(gps["longitude"] as num).toStringAsFixed(4)}"
                                            : "Location unavailable",

                                        style:
                                        const TextStyle(
                                          color:
                                          Colors.grey,
                                        ),
                                      ),

                                      Text(

                                        "Speed:${gps["speed"]} km/h",

                                        style:
                                        const TextStyle(
                                          color:
                                          Colors.cyanAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );

                        }).toList(),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  int selectedIndex=2;

  Widget buildBottomNav(){

    List<IconData> icons=[

      Icons.grid_view_rounded,
      Icons.notifications_none_rounded,
      Icons.map,
      Icons.person_outline,
    ];

    return Container(

      margin: const EdgeInsets.all(12),

      height:70,

      decoration: BoxDecoration(

        color: const Color(0xFF071D31),

        borderRadius:
        BorderRadius.circular(25),

        boxShadow:[

          BoxShadow(

            color:
            Colors.black.withOpacity(.3),

            blurRadius:15,
          )
        ],
      ),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceAround,

        children:
        List.generate(

          icons.length,

              (index){

            bool selected=
                selectedIndex==index;

            return GestureDetector(

              onTap:(){

                setState(() {

                  selectedIndex=index;

                });

                if(index==0){

                  Navigator.pushReplacement(

                    context,

                    MaterialPageRoute(

                      builder:(_)=>
                      const FleetPage(),
                    ),
                  );
                }

                if(index==2){

                  Navigator.pushReplacement(

                    context,

                    MaterialPageRoute(

                      builder:(_)=>
                      const FleetMapPage(),
                    ),
                  );
                }

                if(index==3){

                  Navigator.pushReplacement(

                    context,

                    MaterialPageRoute(

                      builder:(_)=>
                      const ProfilePage(),
                    ),
                  );
                }
              },

              child:
              AnimatedContainer(

                duration:
                const Duration(
                    milliseconds:300),

                padding:
                const EdgeInsets.all(10),

                decoration:

                selected

                    ? const BoxDecoration(

                  border: Border(

                    bottom:
                    BorderSide(

                      color:
                      Color(0xFF00E5FF),

                      width:3,
                    ),
                  ),
                )

                    : null,

                child: Icon(

                  icons[index],

                  size:30,

                  color:

                  selected

                      ? Colors.cyanAccent
                      : Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}