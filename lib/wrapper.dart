import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'fleet_page.dart';
import 'login_page.dart';

class Wrapper
    extends StatelessWidget{

  const Wrapper(
      {super.key});

  @override
  Widget build(
      BuildContext context){

    return const FleetPage();
  }
}