import 'package:flutter/material.dart';

class TrafficSignPage extends StatelessWidget {

  const TrafficSignPage({super.key});

  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor:
        const Color(0xFF071D31),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        title: const Text(
          "Traffic Sign Detection",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: const Center(

        child: Text(

          "Coming Soon",

          style: TextStyle(

            color: Colors.white,

            fontSize: 28,

            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),
    );
  }
}