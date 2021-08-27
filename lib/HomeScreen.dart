import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forsa/Widgets/Language.dart';
import 'package:forsa/Widgets/SubCategory.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:forsa/SearchProduct.dart';
import 'package:forsa/globalVar.dart';
import 'package:forsa/imageSliderScreen.dart';
import 'package:forsa/profileScreen.dart';
import 'package:forsa/uploadAdScreen.dart';
import 'package:timeago/timeago.dart' as tAgo;

import 'Widgets/myDrawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;

  QuerySnapshot items;



  getMyData(){
    FirebaseFirestore.instance.collection('users').doc(userId)
        .get().then((results) {
      setState(() {
        userImageUrl = results.data()['imgPro'];
        getUserName = results.data()['userName'];
      });
    });
  }

  getUserAddress() async{
    Position newPostiton = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    position = newPostiton;

    placemarks = await placemarkFromCoordinates

            (position.latitude, position.longitude);

    Placemark placemark = placemarks[0];

    String newCompleteAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, '
        '${placemark.subThoroughfare} ${placemark.locality},  '
        '${placemark.subAdministrativeArea}, '
        '${placemark.administrativeArea} ${placemark.postalCode}, '
        '${placemark.country}'
    ;
    completeAddress = newCompleteAddress;
    print(completeAddress);

    return completeAddress;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserAddress();

    userId = FirebaseAuth.instance.currentUser.uid;
    userEmail = FirebaseAuth.instance.currentUser.email;

    FirebaseFirestore.instance.collection('items')
        .doc(itemsCtegory)
        .collection(itemsSubCategory)
    .where("status", isEqualTo: "approved")
    .orderBy("time", descending: true)
    .get().then((results) {
      setState(() {
        items = results;
      });
    });

    getMyData();

  }



  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    Widget showItemsList(){
      if(items != null){
        return ListView.builder(
          itemCount: items.docs.length,
            padding: EdgeInsets.all(8.0),
            itemBuilder: (context, i){
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
 children: [
   Padding(
     padding: const EdgeInsets.all(8.0),
     child: ListTile(
       leading: GestureDetector(
         onTap: (){
           Route newRoute = MaterialPageRoute(builder: (_) => ProfileScreen(sellerId: items.docs[i].get('uId'),));
           Navigator.pushReplacement(context, newRoute);
         },
         child: Container(
           width: 60,
           height: 60,
           decoration: BoxDecoration(
             shape: BoxShape.circle,
             image: DecorationImage(
                 image: NetworkImage(items.docs[i].get('imgPro'),),
                 fit: BoxFit.fill
             ),
           ),
         ),
       ),
       title: GestureDetector(
         onTap: (){
           Route newRoute = MaterialPageRoute(builder: (_) => ProfileScreen(sellerId: items.docs[i].get('uId'),));
           Navigator.pushReplacement(context, newRoute);
         },
           child: Text(items.docs[i].get('userName'))
       ),
       trailing: items.docs[i].get('uId') == userId ?
           Row(
             mainAxisSize: MainAxisSize.min,
             children: [
               GestureDetector(
                 onTap: (){
                   if(items.docs[i].get('uId') == userId){

                   }
                 },
                 child: Icon(Icons.edit_outlined,),
               ),
               SizedBox(width: 20,),
               GestureDetector(
                 onDoubleTap: (){
                   if(items.docs[i].get('uId') == userId){
                     FirebaseFirestore.instance.collection('items')
                         .doc(itemsCtegory)
                         .collection(itemsSubCategory).doc(items.docs[i].id).delete();
                     Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => HomeScreen()));
                   }
                 },
                 child: Icon(Icons.delete_forever_sharp)
               ),
             ],
           ):Row(
             mainAxisSize: MainAxisSize.min,
             children: [],
           ),
     ),
   ),

   GestureDetector(
     onDoubleTap: (){
       Route newRoute = MaterialPageRoute(builder: (_) => ImageSliderScreen(
         title: items.docs[i].get('itemModel'),
         itemColor: items.docs[i].get('itemColor'),
         userNumber:  items.docs[i].get('userNumber'),
         description: items.docs[i].get('description'),
         lat:  items.docs[i].get('lat'),
         lng: items.docs[i].get('lng'),
         address: items.docs[i].get('address'),
         urlImage1: items.docs[i].get('urlImage1'),
         urlImage2: items.docs[i].get('urlImage2'),
         urlImage3: items.docs[i].get('urlImage3'),
         urlImage4: items.docs[i].get('urlImage4'),
         urlImage5: items.docs[i].get('urlImage5'),
         itemid:items.docs[i].id,
         sellerId:items.docs[i].get('uId'),
       ));
       Navigator.pushReplacement(context, newRoute);
     },
     child: Padding(
       padding: const EdgeInsets.all(16.0),
       child: Image.network(items.docs[i].get('urlImage1'), fit: BoxFit.fill,),
     ),
   ),
   Padding(
     padding: const EdgeInsets.only(left: 10.0),
     child: Text(
       '\$ '+items.docs[i].get('itemPrice'),
       style: TextStyle(
         fontFamily: "Bebas",
         letterSpacing: 2.0,
         fontSize: 24,
       ),
     ),
   ),
   Padding(
       padding: const EdgeInsets.only(left: 15.0, right: 15.0),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Row(
           children: [
             Icon(Icons.image_sharp),
             Padding(
               padding: const EdgeInsets.only(left: 10.0),
               child: Align(
                 child: Text(items.docs[i].get('itemModel')),
                 alignment: Alignment.topLeft,
               ),
             ),
           ],
         ),
         Row(
           children: [
             Icon(Icons.watch_later_outlined),
             Padding(
               padding: const EdgeInsets.only(left: 10.0),
               child: Align(
                 child: Text(tAgo.format((items.docs[i].get('time')).toDate())),
                 alignment: Alignment.topLeft,
               ),
             ),
           ],
         ),
       ],
     ),
   ),
   SizedBox(height: 10.0,),
 ],
                ),
              );
            },
        );
      }
      else{
        return Text('Loading...');
      }
    }

    return Scaffold(
      appBar: AppBar(
        /*   leading: MyDrawer(),
             IconButton(
          icon: Icon(Icons.refresh, color: Colors.white),
          onPressed: (){
            Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
            Navigator.pushReplacement(context, newRoute);
          },
        ),


        */
        actions: <Widget>[



          IconButton(
            onPressed: (){
              Route newRoute = MaterialPageRoute(builder: (_) => SearchProduct());
              Navigator.pushReplacement(context, newRoute);
            },
           tooltip: "gkgjgj",
            alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(00.0),
              icon: Icon(Icons.search, color: Colors.white),

          ),



          IconButton(
              onPressed: (){
                Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
            Navigator.pushReplacement(context, newRoute);
              },
         icon: Icon(Icons.refresh, color: Colors.white),

       ),





          DropdownButton(
            underline: SizedBox(),
            icon: Icon(
              Icons.language,
              color: Colors.white,
            ),
            items: getLanguages.map((Language lang) {
              return new DropdownMenuItem<String>(
                value: lang.languageCode,
                child: new Text(lang.name),
              );
            }).toList(),

            onChanged: (val) {
              itemsCtegory = val;


              Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
              Navigator.pushReplacement(context, newRoute);
              print(val);
            },

            hint: Text("Category"),

          ),

          DropdownButton(
            underline: SizedBox(),
            icon: Icon(
              Icons.arrow_drop_down_circle_rounded,
              color: Colors.white,
            ),
            items: getSubCategory.map((SubCategory subcat) {
              return new DropdownMenuItem<String>(
                value: subcat.SubCategoryCode,
                child: new Text(subcat.name),
              );
            }).toList(),

            onChanged: (val) {
              itemsSubCategory = val;

              print(val);
            },
hint: Text("SubCategory"),

          ),

          Padding(
            padding: const EdgeInsets.all(05.0),),


        ],
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
        title: Text(getUserName),
        centerTitle: true,
      ),

      drawer: MyDrawer(),



      body: Center(
        child: Container(
          width: _screenWidth,
          child: showItemsList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Post',
        child: Icon(Icons.add),
        onPressed: (){
          Route newRoute = MaterialPageRoute(builder: (_) => UploadAdScreen());
          Navigator.pushReplacement(context, newRoute);
        },
      ),
    );
  }
}
