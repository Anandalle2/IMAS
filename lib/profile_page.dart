import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'vehicle_model.dart';
import 'vehicle_service.dart';
import 'fleet_page.dart';
import 'fleet_map_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int selectedIndex=3;

  String getUserName(){

    final user= null;

    String email=
        user?.email ?? "";

    return email.split("@")[0];
  }

  Widget tile(
      IconData icon,
      String title,
      String value,
      ){

    return Container(

      margin:
      const EdgeInsets.only(bottom:15),

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color:
        const Color(0xFF071D31),

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Row(

        children:[

          Icon(
            icon,
            color: Colors.grey,
          ),

          const SizedBox(width:20),

          Expanded(

            child: Text(

              title,

              style: const TextStyle(

                color: Colors.white,

                fontSize:20,
              ),
            ),
          ),

          Text(

            value,

            style: const TextStyle(

              color: Colors.cyan,

              fontSize:18,
            ),
          )
        ],
      ),
    );
  }
  void editProfileDialog(){

    final controller=TextEditingController();

    controller.text=
        FirebaseAuth.instance.currentUser
            ?.displayName ??
            getUserName();

    showDialog(

      context: context,

      builder:(context){

        return AlertDialog(

          backgroundColor:
          const Color(0xFF071D31),

          title: const Text(

            "Edit Profile",

            style: TextStyle(
              color: Colors.white,
            ),
          ),

          content: TextField(

            controller: controller,

            style:
            const TextStyle(
              color: Colors.white,
            ),

            decoration:
            const InputDecoration(

              hintText:
              "Enter name",

              hintStyle:
              TextStyle(
                color:
                Colors.grey,
              ),
            ),
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

                await FirebaseAuth
                    .instance
                    .currentUser
                    ?.updateDisplayName(
                  controller.text,
                );

                await FirebaseAuth
                    .instance
                    .currentUser
                    ?.reload();

                setState(() {});

                Navigator.pop(context);
              },

              child:
              const Text(
                "Save",
              ),
            )
          ],
        );
      },
    );
  }
  void changePasswordDialog(){

    TextEditingController
    currentController =
    TextEditingController();

    TextEditingController
    newController =
    TextEditingController();

    TextEditingController
    confirmController =
    TextEditingController();

    showDialog(

      context: context,

      builder:(context){

        return AlertDialog(

          backgroundColor:
          const Color(0xFF071D31),

          shape:
          RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(
                25),
          ),

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
          SizedBox(

            height:230,

            child:
            Column(

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

                    labelText:
                    "Current Password",

                    labelStyle:
                    TextStyle(
                      color:
                      Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(
                    height:10),

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

                    labelText:
                    "New Password",

                    labelStyle:
                    TextStyle(
                      color:
                      Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(
                    height:10),

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

                    labelText:
                    "Confirm Password",

                    labelStyle:
                    TextStyle(
                      color:
                      Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          actions:[

            TextButton(

              onPressed:(){

                Navigator.pop(
                    context);

              },

              child:
              const Text(
                  "Cancel"),
            ),

            ElevatedButton(

              onPressed:() async {

                try{

                  if(newController.text
                      !=
                      confirmController.text){

                    ScaffoldMessenger
                        .of(context)

                        .showSnackBar(

                      const SnackBar(

                        content:
                        Text(
                            "Passwords do not match"),
                      ),
                    );

                    return;
                  }

                  final user=
                  FirebaseAuth
                      .instance
                      .currentUser!;

                  AuthCredential credential=

                  EmailAuthProvider
                      .credential(

                    email:
                    user.email!,

                    password:
                    currentController
                        .text,
                  );

                  await user
                      .reauthenticateWithCredential(
                      credential);

                  await user
                      .updatePassword(

                    newController.text,
                  );

                  Navigator.pop(
                      context);

                  ScaffoldMessenger
                      .of(context)

                      .showSnackBar(

                    const SnackBar(

                      backgroundColor:
                      Colors.green,

                      content:
                      Text(
                        "Password changed successfully",
                      ),
                    ),
                  );

                }

                catch(e){

                  ScaffoldMessenger
                      .of(context)

                      .showSnackBar(

                    SnackBar(

                      content:
                      Text(
                          e.toString()),
                    ),
                  );
                }
              },

              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                Colors.cyanAccent,
              ),

              child:
              const Text(

                "Update",

                style:
                TextStyle(
                  color:
                  Colors.black,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){

    final user=
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      backgroundColor:
      const Color(0xFF02111F),

      bottomNavigationBar:
      buildBottomNav(),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding:
            const EdgeInsets.all(25),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children:[

                const SizedBox(height:20),

                Row(

                  children:[

                    const Text(

                      "Profile",

                      style: TextStyle(

                        color: Colors.white,

                        fontSize:50,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    GestureDetector(

                      onTap:(){

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder:(_)=>
                            const SettingsPage(),
                          ),
                        );

                      },

                      child:

                      Container(

                        padding:
                        const EdgeInsets.all(12),

                        decoration:
                        BoxDecoration(

                          color:
                          const Color(
                              0xFF071D31),

                          borderRadius:
                          BorderRadius.circular(
                              15),
                        ),

                        child:
                        const Icon(

                          Icons.settings,

                          color:
                          Colors.white,

                          size:26,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height:30),

                Container(

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

                        CircleAvatar(

                          radius:45,

                          backgroundColor:
                          Colors.cyan.withOpacity(.2),

                          child: Text(

                            getUserName()[0]
                                .toUpperCase(),

                            style:
                            const TextStyle(

                              fontSize:40,

                              color:
                              Colors.cyan,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width:25),

                        Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children:[

                            Text(

                              user?.displayName?.isNotEmpty == true

                                  ? user!.displayName!

                                  : getUserName(),

                              style:
                              const TextStyle(

                                color: Colors.white,

                                fontSize:30,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            Text(

                              user?.email ?? "",

                              style:
                              const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height:10),

                            Container(

                              padding:
                              const EdgeInsets.symmetric(

                                horizontal:15,
                                vertical:8,
                              ),

                              decoration:
                              BoxDecoration(

                                color:
                                Colors.cyan.withOpacity(.2),

                                borderRadius:
                                BorderRadius.circular(20),
                              ),

                              child:
                              const Text(

                                "Fleet Owner",

                                style:
                                TextStyle(
                                  color:
                                  Colors.cyan,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        IconButton(

                          onPressed:(){

                            editProfileDialog();

                          },

                          icon: const Icon(

                            Icons.edit,

                            color: Colors.cyan,

                            size:28,
                          ),
                        ),
                      ],
                    ),
                ),

                const SizedBox(height:30),

                const Text(

                  "ACCOUNT",

                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing:3,
                  ),
                ),

                const SizedBox(height:15),



                tile(

                  Icons.person_outline,

                  "Display Name",

                  user?.displayName?.isNotEmpty == true

                      ? user!.displayName!

                      : getUserName(),
                ),
                tile(
                  Icons.email_outlined,
                  "Email Address",
                  user?.email ?? "",
                ),

                tile(
                  Icons.verified_user_outlined,
                  "Email Verified",
                  user!.emailVerified
                      ? "Verified"
                      : "Not verified",
                ),

                const SizedBox(height:25),

                const Text(

                  "STATS",

                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing:3,
                  ),
                ),

                const SizedBox(height:15),

                FutureBuilder<List<Vehicle>>(

                  future:
                  VehicleService.getVehicles(),

                  builder:
                      (context,snapshot){

                    int total=

                        snapshot.data
                            ?.length ??0;

                    return tile(

                      Icons.directions_car,

                      "Vehicles in my fleet",

                      "$total",
                    );
                  },
                ),
                const SizedBox(height:25),

                const Text(

                  "APP",

                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing:3,
                  ),
                ),

                const SizedBox(height:15),

                tile(
                  Icons.info_outline,
                  "IMAS Version",
                  "1.0.0",
                ),

                tile(
                  Icons.shield_outlined,
                  "Role",
                  "Fleet Owner",
                ),


                const SizedBox(height:100)
              ],
            ),
          ),
        ),
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

                if(index==selectedIndex){
                  return;
                }

                setState(() {

                  selectedIndex=index;

                });

                // Dashboard
                if(index==0){

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder:(_)=>
                      const FleetPage(),
                    ),
                  );
                }

                // Map
                else if(index==2){

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder:(_)=>
                      const FleetMapPage(),
                    ),
                  );
                }

              },

              child:
              AnimatedContainer(

                duration:
                const Duration(
                  milliseconds:300,
                ),

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