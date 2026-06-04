import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'wrapper.dart';
import 'splash_page.dart';

void main() async {

  WidgetsFlutterBinding
      .ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // Force logout whenever app starts
  // await FirebaseAuth.instance.signOut();

  runApp(
      const MyApp());
}

class MyApp
    extends StatelessWidget {

  const MyApp({
    super.key,
  });

  @override
  Widget build(
      BuildContext context){

    return const MaterialApp(

      debugShowCheckedModeBanner:
      false,

      home:
      SplashPageWrapper(),
    );
  }
}

class SplashPageWrapper
    extends StatefulWidget {

  const SplashPageWrapper({
    super.key,
  });

  @override
  State<SplashPageWrapper>
  createState()=>

      _SplashPageWrapperState();
}

class _SplashPageWrapperState
    extends State<SplashPageWrapper>{

  @override
  void initState(){

    super.initState();

    Future.delayed(

      const Duration(
          seconds:3),

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

    return const SplashPage();
  }
}