import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'add_vehicle_page.dart';
import 'dashboard_page.dart';
import 'fleet_map_page.dart';
import 'vehicle_model.dart';
import 'vehicle_service.dart';
import 'alerts_page.dart';
import 'mqtt_service.dart';

class FleetPage extends StatefulWidget {
  const FleetPage({super.key});

  @override
  State<FleetPage> createState() => _FleetPageState();
}

class _FleetPageState extends State<FleetPage> {
  late Future<List<Vehicle>> vehiclesFuture;
  @override
  void initState(){

    super.initState();

    MQTTService.connect(); // Connect to MQTT broker on startup

    vehiclesFuture =
        VehicleService.getVehicles();
  }

  int selectedIndex=0;

  String getUserName(){

    final user= null; // Bypassed Firebase

    if(user==null){
      return "User";
    }

    return (user.displayName!=null &&
        user.displayName!.isNotEmpty)

        ? user.displayName!

        : (user.email ?? "")
        .split("@")[0];
  }

  Widget vehicleCard(Vehicle v){

    return InkWell(

      onTap:(){

        Navigator.push(

          context,

          MaterialPageRoute(

              builder:(_)=>DashboardPage(

                vehicle:v,
              )
          ),
        );
      },

      child: Container(

        margin: const EdgeInsets.symmetric(
          horizontal:10,
          vertical:8,
        ),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(

          color: const Color(0xFF071D31),

          borderRadius:
          BorderRadius.circular(20),
        ),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children:[

            Row(

              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children:[

                Text(

                  v.driverName,

                  style: const TextStyle(

                    color: Colors.cyanAccent,

                    fontSize:24,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                IconButton(

                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),

                  onPressed:(){

                    showDialog(

                      context: context,

                      builder:(context){

                        return AlertDialog(

                          backgroundColor:
                          const Color(0xFF071D31),

                          title: const Text(

                            "Delete Vehicle",

                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),

                          content: Text(

                            "Delete ${v.driverName}?",

                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),

                          actions:[

                            TextButton(

                              onPressed:(){

                                Navigator.pop(context);

                              },

                              child: const Text(
                                "Cancel",
                              ),

                            ),

                            ElevatedButton(

                              style:
                              ElevatedButton.styleFrom(

                                backgroundColor:
                                Colors.red,

                              ),

                              onPressed: () async {

                                print(
                                    "DELETE ID=${v.id}"
                                );

                                await VehicleService
                                    .deleteVehicle(
                                    v.id ?? ""
                                );

                                Navigator.pop(
                                    context
                                );

                                vehiclesFuture =
                                    VehicleService
                                        .getVehicles();

                                setState(() {});

                              },

                              child: const Text(
                                "Delete",
                              ),

                            )

                          ],
                        );
                      },
                    );
                  },
                )
              ],
            ),

            Text(
              "Vehicle: ${v.regNo}",
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),

            const SizedBox(
              height:4,
            ),

            Text(
              "Type: ${v.type}",
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),

            const SizedBox(
              height:4,
            ),

            Text(
              "Device: ${v.deviceId}",
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),







            const SizedBox(height:12),

            Container(

              padding:
              const EdgeInsets.symmetric(

                horizontal:15,
                vertical:6,
              ),

              decoration:
              BoxDecoration(

                color:
                Colors.cyan
                    .withOpacity(.25),

                borderRadius:
                BorderRadius.circular(20),
              ),

              child:
              const Text(

                "Online",

                style:
                TextStyle(
                  color:
                  Colors.cyanAccent,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:
      const Color(0xFF02111F),

      appBar: AppBar(

        automaticallyImplyLeading: false,

        elevation:0,

        backgroundColor:
        const Color(0xFF071D31),

        title: const Text(

          "Fleet",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions:[

          Container(

            margin:
            const EdgeInsets.only(right:10),

            padding:
            const EdgeInsets.symmetric(
              horizontal:12,
              vertical:6,
            ),

            decoration: BoxDecoration(

              color:
              Colors.cyan.withOpacity(.15),

              borderRadius:
              BorderRadius.circular(20),
            ),

            child: const Row(

              children:[

                Icon(
                  Icons.circle,
                  color: Colors.greenAccent,
                  size:10,
                ),

                SizedBox(width:6),

                Text(
                  "Live",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),


        ],
      ),

      floatingActionButton:
      Container(

        decoration:
        BoxDecoration(

          borderRadius:
          BorderRadius.circular(
              30),

          boxShadow:[

            BoxShadow(

              color:
              Colors.cyan
                  .withOpacity(.5),

              blurRadius:20,

              spreadRadius:2,
            )
          ],
        ),

        child:
        FloatingActionButton(

          backgroundColor:
          Colors.cyan,

          foregroundColor:
          Colors.black,

            onPressed:() async {

              await Navigator.push(

                context,

                MaterialPageRoute(

                  builder:(_)=>
                  const AddVehiclePage(),
                ),
              );

              setState(() {

                vehiclesFuture=
                    VehicleService
                        .getVehicles();

              });

            },

          child:
          const Icon(Icons.add),
        ),
      ),

      body:
      SingleChildScrollView(

        child:
        Column(

          children:[

            Padding(

              padding:
              const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children:[

                  Text(

                    "Hello, ${getUserName()}",

                    style:
                    const TextStyle(

                      color:
                      Colors.white,

                      fontSize:34,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height:8),

                  const Text(

                    "Fleet Management Portal",

                    style:
                    TextStyle(

                      color:
                      Colors.grey,

                      fontSize:18,
                    ),
                  ),
                ],
              ),
            ),

            FutureBuilder<List<Vehicle>>(

              future: vehiclesFuture,

              builder:
                  (context,snapshot){

                    int total=

                    snapshot.hasData

                        ? snapshot.data!.length

                        : 0;

                return Padding(

                  padding:
                  const EdgeInsets.all(
                      12),

                  child: Column(

                    children:[

                      Container(

                        width:
                        double.infinity,

                        padding:
                        const EdgeInsets.all(
                            20),

                        decoration:
                        BoxDecoration(

                          color:
                          const Color(
                              0xFF111827),

                          borderRadius:
                          BorderRadius.circular(
                              20),
                        ),

                        child: Row(

                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                          children:[

                            Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children:[

                                const Text(

                                  "Total Vehicles",

                                  style:
                                  TextStyle(
                                    color:
                                    Colors.grey,
                                  ),
                                ),

                                const SizedBox(
                                    height:8),

                                Text(

                                  "$total",

                                  style:
                                  const TextStyle(

                                    color:
                                    Colors.white,

                                    fontSize:34,

                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const Icon(

                              Icons.local_shipping,

                              color:
                              Colors.cyanAccent,

                              size:45,
                            )
                          ],
                        ),
                      ),

                      const SizedBox(
                          height:15),

                      Row(

                        children:[

                          Expanded(
                            child:
                            statCard(
                              "Online",
                              "$total",
                              Icons.circle,
                            ),
                          ),

                          const SizedBox(
                              width:10),

                          Expanded(
                            child:
                            statCard(
                              "Offline",
                              "0",
                              Icons.wifi_off,
                            ),
                          ),

                          const SizedBox(
                              width:10),

                          Expanded(
                            child:
                            statCard(
                              "Alerts",
                              "0",
                              Icons.warning,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            FutureBuilder<List<Vehicle>>(

              future: vehiclesFuture,

              builder:
                  (context,snapshot){

                    if(snapshot.connectionState ==
                        ConnectionState.waiting){

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if(snapshot.hasError){

                      return Center(
                        child: Text(
                          "Error loading vehicles",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }

                    if(!snapshot.hasData ||
                        snapshot.data!.isEmpty){

                      return Center(
                        child: Text(
                          "No vehicles found",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }

                return ListView.builder(

                  shrinkWrap:true,

                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount:
                  snapshot.data!.length,

                  itemBuilder:
                      (context,index){

                    return vehicleCard(
                        snapshot.data![index]);
                  },
                );
              },
            ),

            const SizedBox(
                height:100),
          ],
        ),
      ),

      bottomNavigationBar:
      buildBottomNav(),
    );
  }

  Widget statCard(
      String title,
      String value,
      IconData icon){

    return Container(

      padding:
      const EdgeInsets.all(15),

      decoration:
      BoxDecoration(

        color:
        const Color(0xFF111827),

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Column(

        children:[

          Icon(
            icon,
            color:
            Colors.cyanAccent,
          ),

          const SizedBox(height:8),

          Text(

            value,

            style:
            const TextStyle(

              color:
              Colors.white,

              fontSize:22,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          Text(

            title,

            style:
            const TextStyle(
              color:
              Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget buildBottomNav(){

    List<IconData> icons=[

      Icons.grid_view_rounded,
      Icons.notifications_none_rounded,
      Icons.map_outlined,
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
                if(index==1){

                  Navigator.pushReplacement(

                    context,

                    MaterialPageRoute(
                      builder:(_)=>AlertPage(),
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