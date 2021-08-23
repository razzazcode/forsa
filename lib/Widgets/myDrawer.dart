
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forsa/Signup/myInfo.dart';
import 'package:forsa/Signup/components/myInfoBody.dart';
import 'package:forsa/Signup/signup_screen.dart';
import 'package:forsa/Welcome/welcome_screen.dart';
import 'package:forsa/globalVar.dart';
import 'package:forsa/profileScreen.dart';

import '../HomeScreen.dart';


class MyDrawer extends StatefulWidget {
  @override
  _MyDrawer createState() => _MyDrawer();
}





class _MyDrawer extends State<MyDrawer> {



  FirebaseAuth auth = FirebaseAuth.instance;

  QuerySnapshot items;



  getMyData(){
    FirebaseFirestore.instance.collection('users').doc(userId).get().then((results) {
      setState(() {
        userImageUrl = results.data()['imgPro'];
        getUserName = results.data()['userName'];

        getUserNumber = results.data()['userNumber'];

        getUseremail = results.data()['email'];

      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 //   getUserAddress();

    userId = FirebaseAuth.instance.currentUser.uid;
    userEmail = FirebaseAuth.instance.currentUser.email;

    FirebaseFirestore.instance.collection('items')
        .where("status", isEqualTo: "approved")
        .orderBy("time", descending: true)
        .get().then((results) {
      setState(() {
        items = results;
      });
    });

    getMyData();

  }



  Future<void> _showMyDialogSignOut() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logging Out ... ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please Confirm ...'),
                Text('Would you like to SignOut of Your account  and close the App?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(

              child: Text('Log Out '),
              onPressed: () {
                auth.signOut().then((_){


                   getUseremail = "please enter your email address here";
                   getUserNumber = "please enter your phone number here like +1 0123456789";




                  Route toWelcomeScreen = MaterialPageRoute(builder: (_) => WelcomeScreen());
                  Navigator.pushReplacement(context, toWelcomeScreen);
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel...'),
              onPressed: () {

                Navigator.of(context).pop();

              },


            ),
          ],
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(


        children: [

          Container(
            padding: EdgeInsets.only(top: 25.0 , bottom: 10.0),

            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [ Colors.pink , Colors.lightGreenAccent ],
                begin: const FractionalOffset(0.0, 0.0),
    end: const FractionalOffset(1.0, 0.0),
    stops: [0.0 , 1.0],
    tileMode: TileMode.clamp,),
),

child: Column (

  children: [
    Material(

      borderRadius: BorderRadius.all(Radius.circular(80.0)),
      elevation: 8.0,

      child: Container(

        height: 160.0,
        width: 160.0,
        child: CircleAvatar (

          backgroundImage: NetworkImage(

              userImageUrl
          ),

        ),
      ),
    ),
SizedBox(height: 10.0,),
                Text(

                  getUserName,
   style: TextStyle( color : Colors.white , fontSize: 35.0 , fontFamily: "Signatra"),
                ),



              ],
            ),
          ),


          SizedBox(height: 12.0,),
          Container(
    padding: EdgeInsets.only(top: 25.0 , bottom: 10.0),

    decoration: new BoxDecoration(
    gradient: new LinearGradient(
    colors: [ Colors.pink , Colors.lightGreenAccent ],
    begin: const FractionalOffset(0.0, 0.0),
    end: const FractionalOffset(1.0, 0.0),
    stops: [0.0 , 1.0],
    tileMode: TileMode.clamp,),
    ),

            child: Column(
              children: [
                ListTile(

                  leading: Icon(Icons.person , color: Colors.white,),
    title : Text( "Profile" , style:  TextStyle(color : Colors.white),),



                  onTap: () {

                    Route route = MaterialPageRoute(builder: (c) => myInfo());

                    Navigator.pushReplacement(context, route);
                  },

                ),

                Divider(height: 10.0, color: Colors.white, thickness: 6.0, ),



                ListTile(

                  leading: Icon(Icons.reorder , color: Colors.white,),
                  title : Text( "My Orders" , style:  TextStyle(color : Colors.white),),



                  onTap: () {

                    Route route = MaterialPageRoute(builder: (c) => HomeScreen());

                    Navigator.pushReplacement(context, route);
                  },

                ),

                Divider(height: 10.0, color: Colors.white, thickness: 6.0, ) ,
                ListTile(

                  leading: Icon(Icons.shopping_cart , color: Colors.white,),
                  title : Text( "My Cart" , style:  TextStyle(color : Colors.white),),



                  onTap: () {

                    Route route = MaterialPageRoute(builder: (c) => HomeScreen());

                    Navigator.pushReplacement(context, route);
                  },

                ),

                Divider(height: 10.0, color: Colors.white, thickness: 6.0, ),
                ListTile(

                  leading: Icon(Icons.search , color: Colors.white,),
                  title : Text( "Search" , style:  TextStyle(color : Colors.white),),



                  onTap: () {

                    Route route = MaterialPageRoute(builder: (c) => HomeScreen());

                    Navigator.pushReplacement(context, route);
                  },

                ),

                Divider(height: 10.0, color: Colors.white, thickness: 6.0, ) ,
                ListTile(

                  leading: Icon(Icons.add_location_alt , color: Colors.white,),
                  title : Text( "Add New Address" , style:  TextStyle(color : Colors.white),),



                  onTap: () {

                    Route route = MaterialPageRoute(builder: (c) => HomeScreen());

                    Navigator.pushReplacement(context, route);
                  },

                ),

                Divider(height: 10.0, color: Colors.white, thickness: 6.0, ) ,
                ListTile(

                  leading: Icon(Icons.exit_to_app , color: Colors.white,),
                  title : Text( "LogOut" , style:  TextStyle(color : Colors.white),),



                  onTap: () {

                    _showMyDialogSignOut();
                  },

                ),

                Divider(height: 10.0, color: Colors.white, thickness: 6.0, ) ,



              ],
            ),



          ),

        ],

      ),
    );
  }
}
