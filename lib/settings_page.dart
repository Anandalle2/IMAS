import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState
    extends State<SettingsPage>{

  bool notifications=true;
  bool enableIDAS = true;

  String drivingMode = "Normal";

  bool liveStream = false;

  String camera = "Front Camera";

  String resolution = "1080p";

  bool laneWarning = true;

  double sensitivity = 50;

  bool fcw = true;

  int speedLimit = 90;

  bool blindSpot = false;

  double blindSpotRange = 50;

  bool trafficSigns = true;

  bool wifiAuto = false;

  bool gpsTracking = true;

  bool cloudSync = true;

  bool bluetooth = false;



  @override
  void initState(){

    super.initState();

    loadSettings();
  }

  Future loadSettings() async{

    final prefs=
    await SharedPreferences
        .getInstance();

    setState(() {

      notifications=
          prefs.getBool(
              "notifications")
              ?? true;



    });
  }

  Future saveNotifications(
      bool value) async{

    final prefs=
    await SharedPreferences
        .getInstance();

    prefs.setBool(
        "notifications",
        value);
  }



  Widget tile(

      IconData icon,

      String title,

      Widget trailing,

      VoidCallback? onTap){

    return GestureDetector(

      onTap:onTap,

      child:Container(

        margin:
        const EdgeInsets.only(
            bottom:18),

        padding:
        const EdgeInsets.all(
            20),

        decoration:
        BoxDecoration(

          color:
          const Color(
              0xFF071D31),

          borderRadius:
          BorderRadius.circular(
              20),
        ),

        child:
        Row(

          children:[

            Icon(

              icon,

              color:
              Colors.cyan,
            ),

            const SizedBox(
                width:18),

            Expanded(

              child:
              Text(

                title,

                style:
                const TextStyle(

                  color:
                  Colors.white,

                  fontSize:17,
                ),
              ),
            ),

            trailing
          ],
        ),
      ),
    );
  }

  void changePasswordDialog(){

    TextEditingController
    currentController=
    TextEditingController();

    TextEditingController
    newController=
    TextEditingController();

    TextEditingController
    confirmController=
    TextEditingController();

    showDialog(

        context:context,

        builder:(context){

          return AlertDialog(

            backgroundColor:
            const Color(
                0xFF071D31),

            title:
            const Text(

              "Change Password",

              style:
              TextStyle(
                color:
                Colors.white,
              ),
            ),

            content:
            Column(

              mainAxisSize:
              MainAxisSize.min,

              children:[

                TextField(

                  controller:
                  currentController,

                  obscureText:true,

                  style:
                  const TextStyle(
                    color:
                    Colors.white,
                  ),

                  decoration:
                  const InputDecoration(

                    hintText:
                    "Current Password",
                  ),
                ),

                const SizedBox(
                    height:15),

                TextField(

                  controller:
                  newController,

                  obscureText:true,

                  style:
                  const TextStyle(
                    color:
                    Colors.white,
                  ),

                  decoration:
                  const InputDecoration(

                    hintText:
                    "New Password",
                  ),
                ),

                const SizedBox(
                    height:15),

                TextField(

                  controller:
                  confirmController,

                  obscureText:true,

                  style:
                  const TextStyle(
                    color:
                    Colors.white,
                  ),

                  decoration:
                  const InputDecoration(

                    hintText:
                    "Confirm Password",
                  ),
                )
              ],
            ),

            actions:[

              TextButton(

                onPressed:(){

                  Navigator.pop(
                      context);

                },

                child:
                const Text(
                  "Cancel",
                ),
              ),

              ElevatedButton(

                onPressed:() async{

                  if(

                  newController.text!=
                      confirmController.text){

                    ScaffoldMessenger.of(
                        context)

                        .showSnackBar(

                        const SnackBar(

                          content:
                          Text(
                            "Passwords don't match",
                          ),
                        ));
                    return;
                  }

                  try{

                    await FirebaseAuth
                        .instance.currentUser!
                        .updatePassword(

                        newController.text);

                    Navigator.pop(
                        context);

                    ScaffoldMessenger.of(
                        context)

                        .showSnackBar(

                        const SnackBar(

                          content:
                          Text(
                            "Password changed successfully",
                          ),

                          backgroundColor:
                          Colors.green,
                        ));
                  }

                  catch(e){

                    ScaffoldMessenger.of(
                        context)

                        .showSnackBar(

                        SnackBar(
                          content:
                          Text("$e"),
                        ));
                  }

                },

                child:
                const Text(
                  "Update",
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(
      BuildContext context){

    return Scaffold(

      backgroundColor:
      Colors.black,

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        iconTheme:
        const IconThemeData(

          color: Colors.white,
        ),

        title:
        const Text(

          "Settings",

          style: TextStyle(

            color: Colors.white,

            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body:
      Padding(

        padding:
        const EdgeInsets.all(
            20),

        child: SingleChildScrollView(
          child: Column(

          children:[

            tile(

              Icons.notifications,

              "Notifications",

              Switch(

                value:
                notifications,

                activeColor:
                Colors.cyan,

                onChanged:(v){

                  setState(() {

                    notifications=v;

                  });

                  saveNotifications(v);

                },
              ),

                  (){},
            ),


            tile(

              Icons.security,

              "Privacy & Security",

              const Icon(

                Icons.arrow_forward_ios,

                color:
                Colors.grey,

                size:18,
              ),

                  (){

                showDialog(

                    context:
                    context,

                    builder:
                        (_){

                      return AlertDialog(

                        backgroundColor:
                        const Color(
                            0xFF071D31),

                        title:
                        const Text(

                          "Privacy",

                          style:
                          TextStyle(
                              color:
                              Colors.white),
                        ),

                        content:
                        const Text(

                          "IMAS encrypts and protects fleet data.",

                          style:
                          TextStyle(
                              color:
                              Colors.grey),
                        ),
                      );
                    });
              },
            ),

            tile(

              Icons.info,

              "About IMAS",

              const Text(

                "v1.0",

                style:
                TextStyle(
                  color:
                  Colors.cyan,
                ),
              ),

                  (){

                showAboutDialog(

                  context:
                  context,

                  applicationName:
                  "IMAS",

                  applicationVersion:
                  "1.0.0",

                  children:[

                    const Text(

                        "Intelligent Monitoring and Assistance System"),
                  ],
                );
              },
            ),
            tile(

              Icons.lock,

              "Change Password",

              const Icon(

                Icons.arrow_forward_ios,

                color:
                Colors.grey,

                size:18,
              ),

                  (){

                changePasswordDialog();

              },
            ),

            const SizedBox(height: 10),

            Container(

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFF071D31),
                borderRadius: BorderRadius.circular(20),
              ),


                child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children:[

                  const Text(

                    "System Settings",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SwitchListTile(

                    title: const Text(
                      "Enable IDAS",
                      style: TextStyle(color: Colors.white),
                    ),

                    value: enableIDAS,

                    activeColor: Colors.cyan,

                    onChanged:(v){

                      setState(() {

                        enableIDAS=v;

                      });
                    },
                  ),

                  DropdownButton<String>(

                    value: drivingMode,

                    isExpanded: true,

                    dropdownColor: const Color(0xFF071D31),

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),

                    iconEnabledColor: Colors.white,

                    items: const [

                      DropdownMenuItem(
                        value: "Normal",
                        child: Text(
                          "Normal",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      DropdownMenuItem(
                        value: "Eco",
                        child: Text(
                          "Eco",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      DropdownMenuItem(
                        value: "Sport",
                        child: Text(
                          "Sport",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],

                    onChanged: (v) {

                      setState(() {

                        drivingMode = v!;

                      });

                    },
                  )
                ],
              ),
            ),


            const SizedBox(height:20),

            Container(

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFF071D31),
                borderRadius: BorderRadius.circular(20),
              ),


                child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children:[

                  const Text(

                    "Camera & Video Settings",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 18,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SwitchListTile(

                    title: const Text(

                      "Enable Live Stream",

                      style: TextStyle(
                          color: Colors.white),
                    ),

                    value: liveStream,

                    onChanged:(v){

                      setState(() {

                        liveStream=v;

                      });
                    },
                  ),

                  DropdownButton<String>(

                    value: camera,

                    isExpanded: true,

                    dropdownColor: const Color(0xFF071D31),

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),

                    iconEnabledColor: Colors.white,

                    items: const [

                      DropdownMenuItem(
                        value: "Front Camera",
                        child: Text(
                          "Front Camera",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      DropdownMenuItem(
                        value: "Rear Camera",
                        child: Text(
                          "Rear Camera",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],

                    onChanged: (v) {

                      setState(() {

                        camera = v!;

                      });

                    },
                  ),
                ],
              ),
            ),


            const SizedBox(height:20),

            Container(

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFF071D31),
                borderRadius: BorderRadius.circular(20),
              ),


                child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children:[

                  const Text(

                    "Alert Settings",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize:18,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SwitchListTile(

                    title: const Text(

                      "Lane Departure Warning",

                      style: TextStyle(
                          color: Colors.white),
                    ),

                    value: laneWarning,

                    onChanged:(v){

                      setState(() {

                        laneWarning=v;

                      });
                    },
                  ),

                  const Text(

                    "Sensitivity",

                    style: TextStyle(
                        color: Colors.white),
                  ),

                  Slider(

                    value: sensitivity,

                    min:0,

                    max:100,

                    activeColor: Colors.cyan,

                    onChanged:(v){

                      setState(() {

                        sensitivity=v;

                      });
                    },
                  ),

                  SwitchListTile(

                    title: const Text(

                      "Forward Collision Warning",

                      style: TextStyle(
                          color: Colors.white),
                    ),

                    value: fcw,

                    onChanged:(v){

                      setState(() {

                        fcw=v;

                      });
                    },
                  ),

                  TextField(

                    style:
                    const TextStyle(
                        color: Colors.white),

                    decoration:
                    const InputDecoration(

                      labelText:
                      "Speed Limit",

                      labelStyle:
                      TextStyle(
                          color: Colors.white),
                    ),

                    onChanged:(v){

                      setState(() {

                        speedLimit=
                            int.tryParse(v) ?? 90;

                      });

                    },
                  ),
                ],
              ),
            ),


            const SizedBox(height:20),

            Container(

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFF071D31),
                borderRadius: BorderRadius.circular(20),
              ),


                child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children:[

                  const Text(

                    "Connectivity",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize:18,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  CheckboxListTile(

                    title: const Text(

                      "Auto Connect WiFi",

                      style: TextStyle(
                          color: Colors.white),
                    ),

                    value: wifiAuto,

                    onChanged:(v){

                      setState(() {

                        wifiAuto=v!;

                      });
                    },
                  ),

                  CheckboxListTile(

                    title: const Text(

                      "GPS Tracking",

                      style: TextStyle(
                          color: Colors.white),
                    ),

                    value: gpsTracking,

                    onChanged:(v){

                      setState(() {

                        gpsTracking=v!;

                      });
                    },
                  ),

                  CheckboxListTile(

                    title: const Text(

                      "Cloud Sync",

                      style: TextStyle(
                          color: Colors.white),
                    ),

                    value: cloudSync,

                    onChanged:(v){

                      setState(() {

                        cloudSync=v!;

                      });
                    },
                  ),

                  CheckboxListTile(

                    title: const Text(

                      "Bluetooth Pairing",

                      style: TextStyle(
                          color: Colors.white),
                    ),

                    value: bluetooth,

                    onChanged:(v){

                      setState(() {

                        bluetooth=v!;

                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height:20),

            tile(

              Icons.logout,

              "Logout",

              const Icon(

                Icons.arrow_forward_ios,

                color: Colors.red,

                size:18,
              ),

                  () async{

                bool? confirm=

                await showDialog(

                  context:context,

                  builder:(context){

                    return AlertDialog(

                      backgroundColor:
                      const Color(
                          0xFF071D31),

                      title:
                      const Text(

                        "Logout",

                        style:
                        TextStyle(
                          color:
                          Colors.white,
                        ),
                      ),

                      content:
                      const Text(

                        "Are you sure you want to logout?",

                        style:
                        TextStyle(
                          color:
                          Colors.white70,
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
                              "Cancel"),
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
                              "Logout"),
                        ),
                      ],
                    );
                  },
                );

                if(confirm==true){

                  await FirebaseAuth
                      .instance
                      .signOut();

                  Navigator.pushNamedAndRemoveUntil(

                    context,

                    '/',

                        (route)=>false,
                  );
                }
              },
            ),


          ],
        ),
      ),
      ),
    );
  }
}