import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'signup_page.dart';
import 'forgot_password.dart';
import 'wrapper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final email = TextEditingController();
  final password = TextEditingController();

  bool loading=false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF02111F),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF071D31),
      ),

      body: SingleChildScrollView(

        child: Padding(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            children: [

              const SizedBox(height:40),

              Container(

                padding: const EdgeInsets.all(30),

                decoration: BoxDecoration(

                  color: const Color(0xFF071D31),

                  borderRadius:
                  BorderRadius.circular(25),
                ),

                child: const Column(

                  children:[

                    Icon(
                      Icons.person,
                      size:60,
                      color: Colors.cyanAccent,
                    ),

                    SizedBox(height:20),

                    Text(

                      "Fleet Owner Login",

                      style: TextStyle(

                        color: Colors.white,

                        fontSize:30,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height:40),

            TextField(

              controller: email,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration: InputDecoration(

                hintText: "Email",

                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),

                filled: true,

                fillColor:
                const Color(0xFF071D31),

                border: OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(15),

                  borderSide:
                  BorderSide.none,
                ),

                enabledBorder:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(15),

                  borderSide:
                  BorderSide.none,
                ),

                focusedBorder:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(15),

                  borderSide:
                  const BorderSide(
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
            ),

              const SizedBox(height:20),

              TextField(

                controller: password,

                obscureText: true,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: InputDecoration(

                  hintText: "Password",

                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),

                  filled: true,

                  fillColor:
                  const Color(0xFF071D31),

                  border: OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(15),

                    borderSide:
                    BorderSide.none,
                  ),

                  enabledBorder:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(15),

                    borderSide:
                    BorderSide.none,
                  ),

                  focusedBorder:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(15),

                    borderSide:
                    const BorderSide(
                      color: Colors.cyanAccent,
                    ),
                  ),
                ),
              ),

              const SizedBox(height:30),

              SizedBox(

                width:200,

                child:
                ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    Colors.cyanAccent,

                    foregroundColor:
                    Colors.black,

                    padding:
                    const EdgeInsets.all(15),

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(25),
                    ),
                  ),

                  onPressed:() async {

                    setState(() {
                      loading=true;
                    });

                    bool ok=
                    await AuthService.login(

                        email.text,
                        password.text
                    );

                    setState(() {
                      loading=false;
                    });

                    if(!ok){

                      ScaffoldMessenger.of(context)

                          .showSnackBar(

                          const SnackBar(

                              content:
                              Text(
                                  "Invalid Email/Password"
                              )
                          ));
                    }
                  },

                  child:

                  loading

                      ?const CircularProgressIndicator(
                    color: Colors.white,
                  )

                      :const Text(

                    "Login",

                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height:20),
              SizedBox(

                width:250,

                child: ElevatedButton.icon(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    Colors.white,

                    padding:
                    const EdgeInsets.all(15),

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(25),
                    ),
                  ),

                  onPressed:() async {

                    bool ok =

                    await AuthService
                        .googleLogin();

                    if(ok){

                      Navigator.pushReplacement(

                        context,

                        MaterialPageRoute(

                          builder:(_)=>
                          const Wrapper(),
                        ),
                      );
                    }
                  },

                  icon: const Icon(

                    Icons.g_mobiledata,

                    color: Colors.red,

                    size:35,
                  ),

                  label: const Text(

                    "Sign in with Google",

                    style: TextStyle(

                      color: Colors.black,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),


              const SizedBox(height:20),

              TextButton(

                  onPressed:(){

                    Navigator.push(

                        context,

                        MaterialPageRoute(

                            builder:(_)=>
                            const SignupPage()));
                  },

                  child:
                  const Text(

                    "Create Account",

                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize:16,
                    ),
                  )
              ),

              TextButton(

                  onPressed:(){

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:(_)=>
                        const ForgotPasswordPage(),
                      ),
                    );
                  },

                  child:
                  const Text(

                    "Forgot Password",

                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize:16,
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}