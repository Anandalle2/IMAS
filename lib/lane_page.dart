import 'package:flutter/material.dart';

class LanePage extends StatelessWidget {
  const LanePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF02111F),

      appBar: AppBar(

        backgroundColor:
        const Color(0xFF071D31),

        elevation:0,

        leading: IconButton(

          onPressed:(){

            Navigator.pop(context);

          },

          icon: const Icon(

            Icons.arrow_back,

            color: Colors.cyanAccent,
          ),
        ),

        title: const Text(

          "Lane Departure",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(

        child: Padding(

          padding:
          const EdgeInsets.all(25),

          child: Container(

            width: double.infinity,

            padding:
            const EdgeInsets.all(30),

            decoration:
            BoxDecoration(

              color:
              const Color(0xFF071D31),

              borderRadius:
              BorderRadius.circular(30),

              border: Border.all(

                color:
                Colors.cyan.withOpacity(.2),
              ),
            ),

            child: const Column(

              mainAxisSize:
              MainAxisSize.min,

              children:[

                Icon(

                  Icons.construction,

                  color:
                  Colors.orangeAccent,

                  size:80,
                ),

                SizedBox(height:25),

                Text(

                  "Coming in Version 2",

                  textAlign:
                  TextAlign.center,

                  style:
                  TextStyle(

                    color:
                    Colors.white,

                    fontSize:30,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                SizedBox(height:15),

                Text(

                  "Lane Departure Detection will be integrated in the next release with real-time AI tracking and alerts.",

                  textAlign:
                  TextAlign.center,

                  style:
                  TextStyle(

                    color:
                    Colors.grey,

                    fontSize:16,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}