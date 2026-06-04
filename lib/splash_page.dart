import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'wrapper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() =>
      _SplashPageState();
}

class _SplashPageState
    extends State<SplashPage> {

  @override
  void initState() {

    super.initState();

    Timer(

      const Duration(
        seconds:3,
      ),

          (){

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

              builder:(_)=>
              const Wrapper(),
          ),
        );
      },
    );
  }

  @override
  Widget build(
      BuildContext context){

    return Scaffold(

      backgroundColor:
      const Color(
          0xFF02111F),

      body: Container(

        width:
        double.infinity,

        decoration:
        const BoxDecoration(

          gradient:
          LinearGradient(

            begin:
            Alignment.topCenter,

            end:
            Alignment.bottomCenter,

            colors:[

              Color(0xFF031526),

              Color(0xFF02111F),

              Colors.black,
            ],
          ),
        ),

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children:[

            ShaderMask(

              shaderCallback:
                  (bounds){

                return const LinearGradient(

                  colors:[

                    Colors.white,

                    Colors.cyanAccent,
                  ],
                ).createShader(
                    bounds);
              },

              child: const Text(

                "IMAS",

                style:
                TextStyle(

                  fontSize:90,

                  fontWeight:
                  FontWeight.bold,

                  color:
                  Colors.white,

                  letterSpacing:10,
                ),
              ),
            ),

            const SizedBox(
                height:20),

            const Text(

              "Intelligent Mobility Assistance",

              textAlign:
              TextAlign.center,

              style:
              TextStyle(

                color:
                Colors.white,

                fontSize:26,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const Text(

              "System",

              style:
              TextStyle(

                color:
                Colors.white,

                fontSize:26,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
                height:120),

            SizedBox(

              width:120,

              child:
              LinearProgressIndicator(

                backgroundColor:
                Colors.white10,

                color:
                Colors.cyanAccent,
              ),
            ),

            const SizedBox(
                height:15),

            const Text(

              "v1.0.0",

              style:
              TextStyle(

                color:
                Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}