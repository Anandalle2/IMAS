import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {

  final emailController =
  TextEditingController();

  bool loading=false;

  Future<void>
  resetPassword()
  async {

    if(emailController.text
        .trim()
        .isEmpty){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
              "Enter email"),
        ),
      );

      return;
    }

    try{

      setState(() {

        loading=true;

      });

      await FirebaseAuth.instance
          .sendPasswordResetEmail(

        email:
        emailController.text
            .trim(),
      );

      setState(() {

        loading=false;

      });

      showDialog(

        context:context,

        builder:(context){

          return AlertDialog(

            backgroundColor:
            const Color(
                0xFF071D31),

            title:
            const Text(

              "Mail Sent",

              style:
              TextStyle(
                color:
                Colors.white,
              ),
            ),

            content:
            const Text(

              "Password reset link sent to your email.",

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
                      context);

                  Navigator.pop(
                      context);

                },

                child:
                const Text(
                    "OK"),
              )
            ],
          );
        },
      );

    }catch(e){

      setState(() {

        loading=false;

      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(
              e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(
      BuildContext context){

    return Scaffold(

      backgroundColor:
      const Color(
          0xFF02111F),

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation:0,

        leading:
        IconButton(

          onPressed:(){

            Navigator.pop(
                context);

          },

          icon:
          const Icon(

            Icons.arrow_back_ios,

            color:
            Colors.white,
          ),
        ),
      ),

      body:
      Padding(

        padding:
        const EdgeInsets.all(
            25),

        child:
        Column(

          children:[

            const SizedBox(
                height:80),

            const Icon(

              Icons.lock_reset,

              color:
              Colors.cyanAccent,

              size:80,
            ),

            const SizedBox(
                height:25),

            const Text(

              "FORGOT PASSWORD",

              style:
              TextStyle(

                color:
                Colors.white,

                fontSize:28,

                fontWeight:
                FontWeight.bold,

                letterSpacing:2,
              ),
            ),

            const SizedBox(
                height:10),

            const Text(

              "Enter your registered email",

              style:
              TextStyle(
                color:
                Colors.grey,
              ),
            ),

            const SizedBox(
                height:50),

            Container(

              padding:
              const EdgeInsets.symmetric(
                  horizontal:20),

              decoration:
              BoxDecoration(

                color:
                const Color(
                    0xFF081B31),

                borderRadius:
                BorderRadius.circular(
                    18),

                border:
                Border.all(

                  color:
                  Colors.cyan
                      .withOpacity(.2),
                ),
              ),

              child:
              TextField(

                controller:
                emailController,

                style:
                const TextStyle(
                    color:
                    Colors.white),

                decoration:
                const InputDecoration(

                  border:
                  InputBorder.none,

                  icon:
                  Icon(

                    Icons.email,

                    color:
                    Colors.cyanAccent,
                  ),

                  hintText:
                  "Email",

                  hintStyle:
                  TextStyle(
                      color:
                      Colors.grey),
                ),
              ),
            ),

            const SizedBox(
                height:40),

            InkWell(

              onTap:
              resetPassword,

              child:
              Container(

                width:
                double.infinity,

                height:60,

                decoration:
                BoxDecoration(

                  borderRadius:
                  BorderRadius.circular(
                      20),

                  gradient:
                  const LinearGradient(

                    colors:[

                      Color(
                          0xFF00E5FF),

                      Color(
                          0xFF0095FF),
                    ],
                  ),

                  boxShadow:[

                    BoxShadow(

                      color:
                      Colors.cyan
                          .withOpacity(.5),

                      blurRadius:20,
                    )
                  ],
                ),

                child:
                Center(

                  child:

                  loading

                      ? const CircularProgressIndicator(
                    color:
                    Colors.white,
                  )

                      : const Text(

                    "Send Reset Link",

                    style:
                    TextStyle(

                      color:
                      Colors.white,

                      fontWeight:
                      FontWeight.bold,

                      fontSize:18,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}