import 'package:flutter/material.dart';
import 'fleet_page.dart';
import 'fleet_map_page.dart';
import 'profile_page.dart';
import 'vehicle_service.dart';
import 'vehicle_model.dart';
import 'alert_service.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {

  String selected="ALL";
  int selectedIndex=1;

  Widget filterButton(
      String text,
      Color color){

    bool active=
        selected==text;

    return GestureDetector(

      onTap:(){

        setState(() {

          selected=text;

        });
      },

      child: Container(

        padding:
        const EdgeInsets.symmetric(
            horizontal:14,
            vertical:10),

        decoration:
        BoxDecoration(

          color:
          active
              ? color.withOpacity(.2)
              : const Color(0xFF081B31),

          borderRadius:
          BorderRadius.circular(15),

          border:
          Border.all(color:color),
        ),

        child: Text(

          text,

          style: TextStyle(

            color:color,

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
      Colors.black,

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

              const Text(

                "ALERT CENTER",

                style: TextStyle(

                  color:
                  Colors.cyanAccent,

                  letterSpacing:4,
                ),
              ),

              const SizedBox(height:10),

              const Text(

                "Camera Alerts",

                style: TextStyle(

                  color: Colors.white,

                  fontSize:30,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height:25),

              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children:[

                  filterButton(
                      "ALL",
                      Colors.white),

                  filterButton(
                      "DMS",
                      Colors.orange),

                  filterButton(
                      "FCW",
                      Colors.cyanAccent),

                  filterButton(
                      "CRITICAL",
                      Colors.pinkAccent),
                ],
              ),

              const SizedBox(height:25),

              Expanded(

                child:
                FutureBuilder(

                  future:
                  AlertService.getAlerts(),

                  builder:
                      (context,snapshot){

                    if(!snapshot.hasData){

                      return const Center(

                        child:
                        CircularProgressIndicator(),

                      );

                    }

                    List alerts=
                    snapshot.data!;

                    List filtered=
                    alerts.where((a){

                      if(selected=="ALL"){
                        return true;
                      }

                      if(selected=="CRITICAL"){

                        return a["severity"]=="High";

                      }

                      return a["source"]==
                          selected;

                    }).toList();

                    if(filtered.isEmpty){

                      return const Center(

                        child: Text(

                          "No alerts yet",

                          style: TextStyle(

                            color: Colors.grey,

                            fontSize:25,

                          ),
                        ),
                      );

                    }

                    return ListView.builder(

                      itemCount:
                      filtered.length,

                      itemBuilder:
                          (context,index){

                        final a=
                        filtered[index];

                        return Container(

                          margin:
                          const EdgeInsets.only(
                            bottom:15,
                          ),

                          padding:
                          const EdgeInsets.all(
                            18,
                          ),

                          decoration:
                          BoxDecoration(

                            color:
                            const Color(
                                0xFF081B31),

                            borderRadius:
                            BorderRadius.circular(
                                20),

                          ),

                          child: Row(

                            children:[

                              CircleAvatar(

                                backgroundColor:

                                a["source"]=="SOS"

                                    ? Colors.red

                                    : a["severity"]=="High"

                                    ? Colors.pink

                                    : Colors.cyan,

                                child:
                                const Icon(

                                  Icons.warning,

                                  color:
                                  Colors.white,

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

                                    Text(

                                      a["alert_type"]
                                          ?? "",

                                      style:
                                      const TextStyle(

                                        color:
                                        Colors.cyanAccent,

                                        fontWeight:
                                        FontWeight.bold,

                                      ),

                                    ),

                                    const SizedBox(
                                        height:5),

                                    Text(

                                      a["message"]
                                          ?? "",

                                      style:
                                      const TextStyle(

                                        color:
                                        Colors.white,

                                      ),

                                    ),

                                    Text(

                                      a["status"]
                                          ?? "",

                                      style:
                                      const TextStyle(

                                        color:
                                        Colors.grey,

                                      ),

                                    ),

                                  ],

                                ),

                              ),

                              Text(

                                a["source"]
                                    ?? "",

                                style:
                                const TextStyle(

                                  color:
                                  Colors.orange,

                                ),

                              )

                            ],

                          ),

                        );

                      },

                    );

                  },

                ),

              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomNav(){

    List<IconData> icons=[

      Icons.grid_view_rounded,
      Icons.notifications,
      Icons.map_outlined,
      Icons.person_outline,
    ];

    return Container(

      margin:
      const EdgeInsets.all(12),

      height:70,

      decoration:
      BoxDecoration(

        color:
        const Color(0xFF071D31),

        borderRadius:
        BorderRadius.circular(25),
      ),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceAround,

        children:
        List.generate(

          icons.length,

              (index){

            bool selectedTab=
                selectedIndex==index;

            return GestureDetector(

              onTap:(){

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

              child: Icon(

                icons[index],

                size:30,

                color:

                selectedTab

                    ? Colors.cyanAccent
                    : Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
}