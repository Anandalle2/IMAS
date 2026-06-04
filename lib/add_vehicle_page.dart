  import 'package:flutter/material.dart';

  import 'vehicle_model.dart';
  import 'vehicle_service.dart';

  class AddVehiclePage extends StatefulWidget {
    const AddVehiclePage({super.key});

    @override
    State<AddVehiclePage> createState() =>
        _AddVehiclePageState();
  }

  class _AddVehiclePageState
      extends State<AddVehiclePage> {
    String selectedVehicle="";

    String selectedSubType="";

    List<String> subTypes=[];

    Map<String,List<String>>
    vehicleSubTypes={

      "Bus":[

        "Sleeper",
        "Semi Sleeper",
        "Electric",
        "Luxury Coach",
        "Seater"

      ],

      "Truck":[

        "Mini Truck",

        "Container",

        "Tipper",

        "Flat Bed",

        "Tanker",

        "Refrigerator"
      ],

      "Van":[

        "Van"
      ]

    };

    final driverController =
    TextEditingController();

    final vehicleController =
    TextEditingController();

    final regController =
    TextEditingController();

    final vinController =
    TextEditingController();

    final deviceController =
    TextEditingController();
    String selectedType="Car";

    final phoneController=
    TextEditingController();

    final vehicleNameController=
    TextEditingController();

    List<Map<String,dynamic>>
    vehicleTypes=[



      {
        "title":"Bus",
        "icon":
        Icons.directions_bus
      },

      {
        "title":"Truck",
        "icon":
        Icons.local_shipping
      },



      {
        "title":"Van",
        "icon":
        Icons.airport_shuttle
      },
    ];

    Widget buildField(

        String title,

        TextEditingController
        controller,

        IconData icon,

        String hint

        ){

      return Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children:[

          Text(

            title,

            style:
            const TextStyle(

              color:
              Colors.white,

              fontSize:16,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
              height:8),

          TextField(

            controller:
            controller,

            style:
            const TextStyle(
              color:
              Colors.white,
            ),

            decoration:
            InputDecoration(

              prefixIcon:
              Icon(
                icon,
                color:
                Colors.cyan,
              ),

              hintText:
              hint,

              hintStyle:
              const TextStyle(
                color:
                Colors.grey,
              ),

              filled:true,

              fillColor:
              const Color(
                  0xFF071D31),

              border:
              OutlineInputBorder(

                borderRadius:
                BorderRadius.circular(
                    18),

                borderSide:
                BorderSide.none,
              ),
            ),
          ),

          const SizedBox(
              height:20)
        ],
      );
    }

    @override
    Widget build(BuildContext context){

      return Scaffold(

        backgroundColor:
        const Color(0xFF02111F),

        appBar: AppBar(

          elevation:0,

          backgroundColor:
          const Color(0xFF071D31),

          leading:
          IconButton(

            onPressed:(){

              Navigator.pop(
                  context);

            },

            icon:
            const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),

        body:
        Padding(

          padding:
          const EdgeInsets.all(20),

          child:
          SingleChildScrollView(

            child:
            Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children:[

                const SizedBox(
                    height:20),

                const Text(

                  "Add Vehicle",

                  style:
                  TextStyle(

                    color:
                    Colors.white,

                    fontSize:40,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height:35),

                const Text(

                  "Register to your fleet",

                  style:
                  TextStyle(
                    color:
                    Colors.grey,
                    fontSize:18,
                  ),
                ),

                const SizedBox(
                    height:35),

                Row(

                  children:[

                    Container(

                      padding:
                      const EdgeInsets.all(
                          12),

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
                        Icons.directions_car,
                        color:
                        Colors.cyan,
                      ),
                    ),

                    const SizedBox(
                        width:15),

                    const Text(

                      "VEHICLE DETAILS",

                      style:
                      TextStyle(

                        color:
                        Colors.grey,

                        letterSpacing:4,
                      ),
                    )
                  ],
                ),

                const SizedBox(
                    height:25),

                Wrap(

                  spacing:10,
                  runSpacing:10,

                  children:

                  vehicleTypes.map((v){

                    bool selected=

                        selectedType==
                            v["title"];

                    return GestureDetector(

                      onTap:(){

                        setState(() {

                          selectedType=
                          v["title"];

                          selectedVehicle=
                          v["title"];

                          subTypes=

                          vehicleSubTypes[
                          selectedVehicle]!;

                          selectedSubType=
                          subTypes[0];

                          vehicleController.text=
                              selectedVehicle;
                        });
                      },

                      child:
                      Container(

                        padding:
                        const EdgeInsets.symmetric(

                          horizontal:18,
                          vertical:15,
                        ),

                        decoration:
                        BoxDecoration(

                          color:

                          selected

                              ? Colors.cyan
                              : const Color(
                              0xFF071D31),

                          borderRadius:
                          BorderRadius.circular(
                              18),
                        ),

                        child:
                        Row(

                          mainAxisSize:
                          MainAxisSize.min,

                          children:[

                            Icon(

                              v["icon"],

                              color:

                              selected

                                  ? Colors.black
                                  : Colors.white,
                            ),

                            const SizedBox(
                                width:8),

                            Text(

                              v["title"],

                              style:
                              TextStyle(

                                color:

                                selected

                                    ? Colors.black
                                    : Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(
                    height:25),

                buildField(
                    "Vehicle Name",
                    vehicleNameController,
                    Icons.badge,
                    "Swift Dzire"
                ),

                if(subTypes.isNotEmpty)...[

                  const Text(

                    "Vehicle Type",

                    style:
                    TextStyle(

                      color:
                      Colors.white,

                      fontSize:16,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height:10),

                  Container(

                    padding:
                    const EdgeInsets.symmetric(
                        horizontal:15),

                    decoration:
                    BoxDecoration(

                      color:
                      const Color(
                          0xFF071D31),

                      borderRadius:
                      BorderRadius.circular(
                          18),
                    ),

                    child:

                    DropdownButton<String>(

                      dropdownColor:
                      const Color(
                          0xFF071D31),

                      value:
                      selectedSubType,

                      isExpanded:true,

                      underline:
                      Container(),

                      style:
                      const TextStyle(
                        color:
                        Colors.white,
                      ),

                      items:

                      subTypes.map((e){

                        return DropdownMenuItem(

                          value:e,

                          child:
                          Text(e),
                        );

                      }).toList(),

                      onChanged:(v){

                        setState(() {

                          selectedSubType=v!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(
                      height:20),
                ],

                buildField(
                    "Registration Number",
                    regController,
                    Icons.confirmation_number,
                    "MH12AB1234"
                ),

                buildField(
                    "Device ID",
                    deviceController,
                    Icons.memory,
                    "IMAS-JET-001"
                ),

                const SizedBox(
                    height:20),

                Row(

                  children:[

                    Container(

                      padding:
                      const EdgeInsets.all(
                          12),

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
                        Icons.person,
                        color:
                        Colors.cyan,
                      ),
                    ),

                    const SizedBox(
                        width:15),

                    const Text(

                      "DRIVER DETAILS",

                      style:
                      TextStyle(

                        color:
                        Colors.grey,

                        letterSpacing:4,
                      ),
                    )
                  ],
                ),

                const SizedBox(
                    height:25),

                buildField(
                    "Driver Name",
                    driverController,
                    Icons.person,
                    "Rajesh Kumar"
                ),

                buildField(
                    "Driver Phone",
                    phoneController,
                    Icons.phone,
                    "+91 9876543210"
                ),

                const SizedBox(
                    height:25),

                Row(

                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children:[

                    ElevatedButton(

                      style:
                      ElevatedButton
                          .styleFrom(

                        backgroundColor:
                        Colors.cyan,

                        foregroundColor:
                        Colors.black,

                        padding:
                        const EdgeInsets.symmetric(

                          horizontal:30,
                          vertical:15,
                        ),

                        shape:
                        RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(
                              30),
                        ),
                      ),

                      onPressed:() async{

                        if(

                        vehicleNameController
                            .text.isEmpty ||

                            driverController
                                .text.isEmpty ||

                            regController
                                .text.isEmpty ||

                            phoneController
                                .text.isEmpty ||

                            deviceController
                                .text.isEmpty ||

                            selectedVehicle
                                .isEmpty

                        ){

                          ScaffoldMessenger
                              .of(context)

                              .showSnackBar(

                              const SnackBar(

                                backgroundColor:
                                Colors.red,

                                content:
                                Text(
                                  "Fill all details",
                                ),
                              ));

                          return;
                        }

                        Vehicle v=

                        Vehicle(

                          driverName:
                          driverController.text,

                          type:
                          "$selectedVehicle - $selectedSubType",

                          regNo:
                          regController.text,

                          deviceId:
                          deviceController.text,

                          phone:
                          phoneController.text,

                          vin:"", // add this

                        );

                        await VehicleService
                            .addVehicle(v);

                        ScaffoldMessenger.of(
                            context)

                            .showSnackBar(

                            const SnackBar(

                              content:
                              Text(
                                "Vehicle Added Successfully",
                              ),
                            ));

                        Navigator.pop(
                            context);
                      },

                      child:
                      const Text(
                        "Save Vehicle",
                      ),
                    ),

                    ElevatedButton(

                      style:
                      ElevatedButton
                          .styleFrom(

                        backgroundColor:
                        const Color(
                            0xFF071D31),

                        foregroundColor:
                        Colors.white,

                        padding:
                        const EdgeInsets.symmetric(

                          horizontal:30,
                          vertical:15,
                        ),

                        shape:
                        RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(
                              30),
                        ),
                      ),

                      onPressed:(){

                        Navigator.pop(
                            context);

                      },

                      child:
                      const Text(
                        "Cancel",
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }