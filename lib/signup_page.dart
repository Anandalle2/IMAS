import 'package:flutter/material.dart';
import 'auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() =>
      _SignupPageState();
}

class _SignupPageState
    extends State<SignupPage> {

  TextEditingController fullName=
  TextEditingController();

  TextEditingController email=
  TextEditingController();

  TextEditingController password=
  TextEditingController();

  TextEditingController
  confirmPassword=
  TextEditingController();

  bool accepted=false;

  String matchText="";

  Widget customField(

      String hint,

      IconData icon,

      TextEditingController c,

      {bool obscure=false}){

    return Container(

      margin:
      const EdgeInsets.only(
          bottom:18),

      padding:
      const EdgeInsets.symmetric(
          horizontal:15),

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

        controller:c,

        obscureText:
        obscure,

        style:
        const TextStyle(
            color:
            Colors.white),

        decoration:
        InputDecoration(

          border:
          InputBorder.none,

          icon:
          Icon(

            icon,

            color:
            Colors.cyanAccent,
          ),

          hintText:
          hint,

          hintStyle:
          const TextStyle(
            color:
            Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context){

    return Scaffold(

      backgroundColor:
      const Color(
          0xFF02111F),

      appBar: AppBar(

        elevation:0,

        backgroundColor:
        Colors.transparent,

        leading:
        IconButton(

          icon:
          const Icon(

            Icons.arrow_back_ios,

            color:
            Colors.white,
          ),

          onPressed:(){

            Navigator.pop(
                context);

          },
        ),
      ),

      body:
      SingleChildScrollView(

        padding:
        const EdgeInsets.all(
            25),

        child:
        Column(

          children:[

            const SizedBox(
                height:20),

            const Text(

              "CREATE ACCOUNT",

              style:
              TextStyle(

                color:
                Colors.white,

                fontSize:30,

                fontWeight:
                FontWeight.bold,

                letterSpacing:2,
              ),
            ),

            const SizedBox(
                height:10),

            const Text(

              "Join IMAS Fleet Platform",

              style:
              TextStyle(

                color:
                Colors.grey,
              ),
            ),

            const SizedBox(
                height:50),

            customField(

              "Full Name",

              Icons.person,

              fullName,
            ),

            customField(

              "Email",

              Icons.email,

              email,
            ),

            customField(

              "Password",

              Icons.lock,

              password,

              obscure:true,
            ),

            customField(

              "Confirm Password",

              Icons.lock_outline,

              confirmPassword,

              obscure:true,
            ),

            Text(

              matchText,

              style:
              TextStyle(

                color:

                matchText
                    =="Password matches"

                    ? Colors.green

                    : Colors.red,
              ),
            ),

            Row(

              children:[

                Checkbox(

                  value:
                  accepted,

                  activeColor:
                  Colors.cyanAccent,

                  onChanged:(v){

                    setState(() {

                      accepted=v!;
                    });
                  },
                ),

                const Expanded(

                  child:
                  Text(

                    "Accept Terms & Conditions",

                    style:
                    TextStyle(
                      color:
                      Colors.grey,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(
                height:25),

            InkWell(

              onTap:() async {

                if(!accepted){

                  ScaffoldMessenger
                      .of(context)

                      .showSnackBar(

                    const SnackBar(

                      content:
                      Text(
                          "Accept terms first"),
                    ),
                  );

                  return;
                }

                if(password.text!=
                    confirmPassword.text){

                  ScaffoldMessenger
                      .of(context)

                      .showSnackBar(

                    const SnackBar(

                      content:
                      Text(
                          "Passwords don't match"),
                    ),
                  );

                  return;
                }

                bool ok=

                await AuthService.signup(

                  email.text,

                  password.text,

                  fullName.text,
                );

                if(ok){

                  showDialog(

                    context:
                    context,

                    builder:
                        (context){

                      return AlertDialog(

                        backgroundColor:
                        const Color(
                            0xFF071D31),

                        title:
                        const Text(

                          "Success",

                          style:
                          TextStyle(
                            color:
                            Colors.white,
                          ),
                        ),

                        content:
                        const Text(

                          "Account created successfully",

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
                }

                else{

                  ScaffoldMessenger
                      .of(context)

                      .showSnackBar(

                    const SnackBar(

                      content:
                      Text(
                          "Signup failed"),
                    ),
                  );
                }
              },

              child:
              Container(

                height:60,

                width:
                double.infinity,

                decoration:
                BoxDecoration(

                  borderRadius:
                  BorderRadius.circular(
                      18),

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
                const Center(

                  child:
                  Text(

                    "Create Account",

                    style:
                    TextStyle(

                      color:
                      Colors.white,

                      fontSize:18,

                      fontWeight:
                      FontWeight.bold,
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