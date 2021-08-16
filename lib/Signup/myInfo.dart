
import 'package:flutter/material.dart';
import 'package:forsa/HomeScreen.dart';
import 'package:forsa/Signup/components/myInfoBody.dart';

class myInfo extends StatelessWidget {






  @override
  Widget build(BuildContext context) {
    return Scaffold(





      appBar: AppBar(
        leading:  IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: (){
          Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
          Navigator.pushReplacement(context, newRoute);
        }
    ),

        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.deepPurple[300],
                  Colors.deepPurple,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp
            ),
          ),
        ),
      ),






      body: myInfoBody(),
    );
  }


}
