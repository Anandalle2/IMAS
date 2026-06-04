  import 'package:flutter/material.dart';
  import 'mqtt_service.dart';

  class SpeedometerPage extends StatefulWidget {
    const SpeedometerPage({super.key});

    @override
    State<SpeedometerPage> createState() =>
        _SpeedometerPageState();
  }

  class _SpeedometerPageState
      extends State<SpeedometerPage> {

    int currentSpeed=0;

    int selectedLimit=80;

    bool alertShown=false;

    List<int> limits=[
      40,60,80,100,120
    ];
    @override
    void initState(){

      super.initState();

      liveSpeed.addListener((){

        setState(() {

          currentSpeed=
              liveSpeed.value;


          checkLimit();

        });

      });
    }
    void checkLimit(){

      if(

      currentSpeed>
          selectedLimit &&

          alertShown==false

      ){

        alertShown=true;

        Future.delayed(
            Duration.zero,(){

          showDialog(

            context:context,

            builder:(context){

              return AlertDialog(

                backgroundColor:
                const Color(
                    0xFF071D31),

                title:
                const Text(

                  "⚠ Overspeed Alert",

                  style:
                  TextStyle(
                    color:
                    Colors.red,
                  ),
                ),

                content:
                Text(

                  "Driver crossed $selectedLimit km/h",

                  style:
                  const TextStyle(
                    color:
                    Colors.white,
                  ),
                ),

                actions:[

                  TextButton(

                    onPressed:(){

                      Navigator.pop(context);

                    },

                    child:
                    const Text(
                        "OK"),
                  )
                ],
              );
            },
          );
        });
      }
      else if(

      currentSpeed
          <=
          selectedLimit

      ){

        alertShown=false;

      }
    }

    Widget statCard(
        String value,
        String title,
        Color color){

      return Container(

          margin:
          const EdgeInsets.only(
              right:8),

          padding:
          const EdgeInsets.all(
              12),

          decoration:
          BoxDecoration(

            color:
            const Color(
                0xFF081B31),

            borderRadius:
            BorderRadius.circular(
                22),
          ),

          child:
          Column(

            children:[

              Text(

                value,

                style:
                TextStyle(

                  color:color,

                  fontSize:22,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height:8),

              Text(

                title,

                textAlign:
                TextAlign.center,

                style:
                const TextStyle(

                  color:
                  Colors.grey,

                  fontSize:11,
                ),
              )
            ],
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

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children:[

                Row(

                  children:[

                    GestureDetector(

                      onTap:(){

                        Navigator.pop(context);

                      },

                      child:Container(

                        padding:
                        const EdgeInsets.all(14),

                        decoration:
                        BoxDecoration(

                          color:
                          const Color(0xFF081B31),

                          borderRadius:
                          BorderRadius.circular(18),
                        ),

                        child:
                        const Icon(

                          Icons.arrow_back,

                          color:Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width:12),

                    Expanded(

                      child:
                      Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children:[

                          const Text(

                            "SPEEDOMETER",

                            maxLines:1,

                            overflow:
                            TextOverflow.ellipsis,

                            style:
                            TextStyle(

                              color:
                              Colors.white,

                              fontSize:18,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          Text(

                            "Vehicle Live",

                            style:
                            TextStyle(

                              color:
                              Colors.grey,

                              fontSize:11,
                            ),
                          )
                        ],
                      ),
                    ),

                    Container(

                      padding:
                      const EdgeInsets.symmetric(

                        horizontal:10,
                        vertical:8,
                      ),

                      decoration:
                      BoxDecoration(

                        border:
                        Border.all(
                          color:
                          Colors.white12,
                        ),

                        borderRadius:
                        BorderRadius.circular(15),
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
                                  width:6),

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
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                    height:30),

                Container(

                  height:380,

                  width:
                  double.infinity,

                  decoration:
                  BoxDecoration(

                    color:
                    const Color(
                        0xFF081B31),

                    borderRadius:
                    BorderRadius.circular(
                        35),
                  ),

                  child:
                  Column(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children:[

                      SizedBox(

                        height:220,

                        width:280,

                        child:
                        Stack(

                          alignment:
                          Alignment.center,

                          children:[

                            SizedBox(

                              height:220,
                              width:220,

                              child:
                              TweenAnimationBuilder(

                                tween:
                                Tween<double>(

                                  begin:0,

                                  end:
                                  currentSpeed/120,
                                ),

                                duration:
                                const Duration(
                                    milliseconds:700),

                                builder:
                                    (_,value,child){

                                  return CircularProgressIndicator(

                                    strokeWidth:12,

                                    value:
                                    value,

                                    backgroundColor:
                                    Colors.white10,

                                    valueColor:
                                    AlwaysStoppedAnimation(

                                      currentSpeed>
                                          selectedLimit

                                          ? Colors.redAccent

                                          : Colors.cyanAccent,
                                    ),
                                  );
                                },
                              ),
                            ),

                            Column(

                              mainAxisSize:
                              MainAxisSize.min,

                              children:[

                                Icon(

                                  Icons.speed,

                                  size:40,

                                  color:

                                  currentSpeed>
                                      selectedLimit

                                      ? Colors.red

                                      : Colors.cyanAccent,
                                ),

                                const SizedBox(
                                    height:10),

                                Text(

                                  "$currentSpeed",

                                  style:
                                  TextStyle(

                                    color:

                                    currentSpeed>
                                        selectedLimit

                                        ? Colors.red

                                        : Colors.green,

                                    fontSize:60,

                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                    height:5),

                                const Text(

                                  "km/h",

                                  style:
                                  TextStyle(

                                    color:
                                    Colors.grey,

                                    fontSize:20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height:20),

                      Container(

                        padding:
                        const EdgeInsets.symmetric(

                          horizontal:22,
                          vertical:10,
                        ),

                        decoration:
                        BoxDecoration(

                          color:
                          const Color(
                              0xFF031B33),

                          borderRadius:
                          BorderRadius.circular(
                              30),

                          border:
                          Border.all(
                            color:
                            Colors.cyan,
                          ),
                        ),

                        child:
                        Text(

                          "LIMIT $selectedLimit km/h",

                          style:
                          const TextStyle(

                            color:
                            Colors.cyan,

                            fontSize:18,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 25),
                      
                      ValueListenableBuilder<double>(
                        valueListenable: liveLatitude,
                        builder: (context, lat, _) {
                          return ValueListenableBuilder<double>(
                            valueListenable: liveLongitude,
                            builder: (context, lon, _) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  statCard(
                                    lat.toStringAsFixed(4),
                                    "Latitude",
                                    Colors.greenAccent,
                                  ),
                                  statCard(
                                    lon.toStringAsFixed(4),
                                    "Longitude",
                                    Colors.orangeAccent,
                                  ),
                                ],
                              );
                            }
                          );
                        }
                      ),
                      
                    ],
                  )
                ),

                const SizedBox(
                    height:30),

                const Text(

                  "SPEED LIMIT",

                  style:
                  TextStyle(

                    color:
                    Colors.cyan,

                    letterSpacing:4,
                  ),
                ),

                const SizedBox(
                    height:20),

                Row(

                  children:

                  limits.map(

                        (speed){

                      bool selected=
                          speed==
                              selectedLimit;

                      return Expanded(

                        child:
                        GestureDetector(

                          onTap:(){

                            setState(() {

                              selectedLimit=
                                  speed;
                              checkLimit();

                            });
                          },

                          child:
                          Container(

                            height:80,

                            margin:
                            const EdgeInsets.only(
                                right:10),

                            decoration:
                            BoxDecoration(

                              color:

                              selected

                                  ? Colors.cyan
                                  : const Color(
                                  0xFF081B31),

                              borderRadius:
                              BorderRadius.circular(
                                  20),
                            ),

                            child:
                            Center(

                              child:
                              Text(

                                "$speed",

                                style:
                                TextStyle(

                                  color:

                                  selected

                                      ? Colors.black
                                      : Colors.white,

                                  fontSize:30,

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );

                    },
                  ).toList(),
                ),


              ],
            ),
          ),
        ),
      );
    }
  }