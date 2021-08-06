import 'package:flutter/material.dart';
import 'package:image_slider/image_slider.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class ImageSliderScreen extends StatefulWidget {

  final String title, urlImage1, urlImage2, urlImage3, urlImage4, urlImage5;
  final String itemColor, userNumber, description, address ,itemid , sellerId;
  final double lat, lng;







  ImageSliderScreen({
    this.title,
    this.urlImage1,
    this.urlImage2,
    this.urlImage3,
    this.urlImage4,
    this.urlImage5,
    this.itemColor,
    this.userNumber,
    this.description,
    this.address,
    this.lat,
    this.lng,
    this.itemid,
    this.sellerId,
  });


  @override
  _ImageSliderScreenState createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> with SingleTickerProviderStateMixin {

  TabController tabController;
  static List<String> links = [];


  User currentUser;

  FirebaseAuth auth = FirebaseAuth.instance;
  String userName;
  String itemModel;
  String uidd ;
  String reportDescription;
  QuerySnapshot items;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLinks();
    tabController = TabController(length: 5, vsync: this);
  }

  getLinks(){
    links.add(widget.urlImage1);
    links.add(widget.urlImage2);
    links.add(widget.urlImage3);
    links.add(widget.urlImage4);
    links.add(widget.urlImage5);
  }


  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }}

  Future<bool> showDialogForUpdateData(selectedDoc) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text("Update   Data", style: TextStyle(fontSize: 24, fontFamily: "Bebas", letterSpacing: 2.0),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter Your Name',
                    ),
                    onChanged: (value){
                      setState(() {
                        this.userName = value;
                      });
                    },
                  ),
                  SizedBox(height: 5.0),

                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter Item Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        this.itemModel = value;
                      });
                    },
                  ),
                  SizedBox(height: 5.0),

                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Write Report Description',
                    ),
                    onChanged: (value) {
                      setState(() {
                        this.reportDescription = value;
                      });
                    },
                  ),
                  SizedBox(height: 5.0),
                ],
              ),
              actions: [
                ElevatedButton(
                  child: Text(
                    "Cancel",
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: Text(
                    "Report Now",
                  ),
                  onPressed: () {
                 //   Navigator.pop(context);

                    Map<String, dynamic> itemData = {
                      'reporterName': this.userName,

                      'itemModel': this.itemModel,
                      'reportdescription': this.reportDescription,
                      'reporterId': FirebaseAuth.instance.currentUser.uid,
                    };

   FirebaseFirestore.instance.collection('items').doc(selectedDoc)
        .collection('Reports')
       .add(itemData).then((value) {
                      print("Data updated successfully.");
                    }).catchError((onError){
                      print(onError);
                    });
                    Navigator.pop(context);

                  },
                ),
              ],
            ),
          );
        }
    );
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontFamily: "Varela", letterSpacing: 2.0),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 6.0, right: 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_pin, color: Colors.deepPurple),
                  SizedBox(width: 4.0,),
                  Expanded(
                    child: Text(
                      widget.address,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontFamily: "Varela", letterSpacing: 2.0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2),
              ),
              child: ImageSlider(
                showTabIndicator: false,
                tabIndicatorColor: Colors.lightBlue,
                tabIndicatorSelectedColor: Color.fromARGB(255, 0, 0, 255),
                tabIndicatorHeight: 16,
                tabIndicatorSize: 16,
                tabController: tabController,
                curve: Curves.fastOutSlowIn,
                width: MediaQuery.of(context).size.width,
                height: 220,
                autoSlide: false,
                duration: new Duration(seconds: 6),
                allowManualSlide: true,

                children: links.map((String link){
                  return new ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      link,
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      fit: BoxFit.fill,
                    ),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                tabController.index == 0
                ? Container(
                  width: 0,
                  height: 0,
                ): ElevatedButton(
                    child: Text("Previous", style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      tabController.animateTo(tabController.index - 1);
                      setState(() {
                      });
                    },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                  ),
                ),
                tabController.index == 4 ?
                Container(
                  width: 0,
                  height: 0,
                ): ElevatedButton(
                  onPressed: () {
                    tabController.animateTo(4);
                    setState(() {});
                  },
                  child: Text("Skip", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                  ),
                ),
                tabController.index == 4 ?
                Container(
                  width: 0,
                  height: 0,
                ): ElevatedButton(
                  onPressed: () {
                    tabController.animateTo(tabController.index + 1);
                    setState(() {});
                  },
                  child: Text("Next", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.brush_outlined),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Align(
                          child: Text(widget.itemColor),
                          alignment: Alignment.topLeft,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        child:  Icon(Icons.phone_android),

                      onTap: ()
                      {
                        setState(() {
                          _makePhoneCall('tel:'+widget.userNumber);
                        });
                      },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Align(
                          child: Text(widget.userNumber),
                          alignment: Alignment.topRight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Text(
                widget.description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 368,),
                child: ElevatedButton(
                  child: Text('Check Seller Location'),
                  onPressed: ()
                  {
                    MapsLauncher.launchCoordinates(widget.lat, widget.lng);
                  },
                ),
              ),
            ),
            SizedBox(height: 20,),

            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 368,),
                child: ElevatedButton(
                  child: Text('report product'),
                  onPressed: ()
                  {
                    showDialogForUpdateData(widget.itemid);
                  },
                ),
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }



}














