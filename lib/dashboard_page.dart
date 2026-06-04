import 'package:flutter/material.dart';
import 'drowsiness_page.dart';
import 'lane_page.dart';
import 'collision_page.dart';
import 'speedometer_page.dart';
import 'gps_page.dart';
import 'emergency_page.dart';
import 'vehicle_model.dart';
import 'traffic_sign_page.dart';
import 'number_plate_page.dart';
import 'road_defect_page.dart';

class DashboardPage extends StatelessWidget {

  final Vehicle vehicle;

  const DashboardPage({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor:
        const Color(0xFF071D31),

        elevation:0,

        leading: IconButton(

          icon: const Icon(

            Icons.arrow_back,

            color: Colors.cyanAccent,
            size:28,
          ),

          onPressed:(){

            Navigator.pop(context);

          },
        ),

        title: const Text(

          "IMAS Dashboard",

          style: TextStyle(

            color: Colors.white,

            fontSize:22,

            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children:[

            const SizedBox(height:15),

            Text(

              vehicle.driverName,

              style: const TextStyle(

                color: Colors.white,

                fontSize:28,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height:25),

            Expanded(

              child: GridView.count(

                crossAxisCount:2,

                crossAxisSpacing:15,

                mainAxisSpacing:15,

                children:[

                  dashboardCard(

                    context,

                    Icons.face,

                    "Drowsiness Detection",

                    const DrowsinessPage(),
                  ),


                  dashboardCard(

                    context,

                    Icons.car_crash,

                    "Collision Warning",

                    const CollisionPage(),
                  ),

                  dashboardCard(

                    context,

                    Icons.speed,

                    "Speedometer",

                    const SpeedometerPage(),
                  ),

                  dashboardCard(

                    context,

                    Icons.location_on,

                    "GPS Location",

                    GPSPage(
                      vehicle: vehicle,
                    ),
                  ),

                  dashboardCard(

                    context,

                    Icons.warning,

                    "Emergency Response",

                      EmergencyPage(

                        vehicle:
                        vehicle.type,

                        driver:
                        vehicle.driverName,

                        phone:
                        vehicle.phone,
                      )
                  ),

                  dashboardCard(

                    context,

                    Icons.traffic,

                    "Traffic Sign Detection",

                    const TrafficSignPage(),
                  ),

                  dashboardCard(

                    context,

                    Icons.credit_card,

                    "Number Plate Detection",

                    const NumberPlatePage(),
                  ),
                  dashboardCard(

                    context,

                    Icons.turn_right,

                    "Lane Departure",

                    const LanePage(),
                  ),

                  dashboardCard(

                    context,

                    Icons.construction,

                    "Road Defect Detection",

                    const RoadDefectPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(

      BuildContext context,

      IconData icon,

      String title,

      Widget page){

    return InkWell(

      onTap:(){

        Navigator.push(

          context,

          MaterialPageRoute(

            builder:(_)=>page,
          ),
        );
      },

      child: Container(

        decoration: BoxDecoration(

          color:
          const Color(0xFF071D31),

          borderRadius:
          BorderRadius.circular(15),
        ),

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children:[

            Icon(

              icon,

              color:
              Colors.white,

              size:40,
            ),

            const SizedBox(
                height:10),

            Text(

              title,

              textAlign:
              TextAlign.center,

              style:
              const TextStyle(

                color:
                Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}