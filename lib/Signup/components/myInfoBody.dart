import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forsa/Signup/components/infoBackground.dart';
import 'package:forsa/Widgets/Language.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forsa/DialogBox/errorDialog.dart';
import 'package:forsa/DialogBox/loadingDialog.dart';
import 'package:forsa/Login/login_screen.dart';
import 'package:forsa/Widgets/already_have_an_account_acheck.dart';
import 'package:forsa/Widgets/rounded_button.dart';
import 'package:forsa/Widgets/rounded_input_field.dart';
import 'package:forsa/Widgets/rounded_password_field.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:forsa/globalVar.dart';

import '../../HomeScreen.dart';


class myInfoBody extends StatefulWidget {




  @override
  _myInfoBodyState createState() => _myInfoBodyState();
}

class _myInfoBodyState extends State<myInfoBody> {

  String userPhotoUrl = "";

  File _image;
  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;




  PickedFile imageofCamera , pickedimageGallery;
  File pickedimagewithpath ,  image2gallery;




  FirebaseAuth auth = FirebaseAuth.instance;

  QuerySnapshot items;



 /* getMyData(){
    FirebaseFirestore.instance.collection('users')
        .doc(userId).get().then((results) {
      setState(() {
        userImageUrl = results.data()['imgPro'];
        getUserName = results.data()['userName'];
        getUseremail = results.data()['email'];
        getUserNumber = results.data()['userNumber'];
        _nameController.text = getUserName ;

        _emailController.text = getUseremail;

            _passwordController.text = getUserPassword;
            _phoneController.text = getUserNumber;

      });
    });
  }

*/



  Future<void> captureAndPickImage() async {
    //  _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final  imageofCamera =  await ImagePicker().pickImage(
        source: ImageSource.camera
    );


    pickedimagewithpath = File(imageofCamera.path);

    setState(() {
      _image = pickedimagewithpath;
    });

  }


  Future<void> galleryPickImage() async {
    //  _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final pickedimageGallery =  await ImagePicker().pickImage(
        source: ImageSource.gallery
    );


    pickedimagewithpath = File( pickedimageGallery.path);


    setState(() {
      _image = pickedimagewithpath;
    });


  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please select a profile picture.'),
                Text('Would you like to select from gallery or to Capture a new photo ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Camera'),
              onPressed: () {
                captureAndPickImage();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Gallery'),
              onPressed: () {



                //  _imageFile =  ImagePicker.pickImage(source: ImageSource.gallery) as File;
                galleryPickImage();
                Navigator.of(context).pop();

              },


            ),
          ],
        );
      },
    );
  }


  checkFields () async
  {

    if(_emailController.text.isEmpty) {_emailController.text = getUseremail;

    }
    ;

    if(_nameController.text.isEmpty) {_nameController.text = getUserName;

    }
    ;
    if(_passwordController.text.isEmpty) {_passwordController.text = getUserPassword;

    }
    ;
    if(_phoneController.text.isEmpty) {_phoneController.text = getUserNumber;

    }
    ;






         upload();


  }


  upload() async{

    print("object");
    showDialog(
        context: context,
        builder: (_){
          return LoadingAlertDialog();
        });
   if (_image == null)  { userPhotoUrl = userImageUrl;
   saveUserData();}
   else{
     String fileName = DateTime
         .now()
         .millisecondsSinceEpoch
         .toString();

     firebaseStorage.Reference reference =
     firebaseStorage.FirebaseStorage.instance.ref().child(fileName);
     firebaseStorage.UploadTask uploadTask = reference.putFile(_image);
     firebaseStorage.TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {

     });

     await storageTaskSnapshot.ref.getDownloadURL().then((url){
       userPhotoUrl = url;
       saveUserData();
     });
   }


  }


  void saveUserData(){
    Map<String, dynamic> userData = {
      'userName': _nameController.text.trim(),
      'uId': userId,
      'password': _passwordController.text.trim(),
      'email': _emailController.text.trim(),
      'userNumber': _phoneController.text.trim(),
      'imgPro': userPhotoUrl,
      'time': DateTime.now(),
      'status': "approved",
    };

    FirebaseFirestore.instance.collection('users').doc(userId).set(userData);
    Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
    Navigator.pushReplacement(context, newRoute);
  }

/*

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



  }



*/


  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;


    return infoBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: (){
                  _showMyDialog();
                },
                child: CircleAvatar(
                  radius: _screenWidth * 0.20,
                  backgroundColor: Colors.deepPurple[100],
                  backgroundImage:

                  _image==null?null:FileImage(_image),
              /*    NetworkImage(

                      userImageUrl )
                  , */



                  child: _image == null ?



                  Icon(
                    Icons.add_photo_alternate,
                    size: _screenWidth * 0.20,
                    color: Colors.white,
                  )

                      : null,
                )

            ),
            SizedBox(height: _screenHeight * 0.01),


                RoundedInputField(
              hintText: getUserName,
              icon: Icons.person,
              onChanged: (value)
              {

              _nameController.text = value;
              },
            ),
            RoundedInputField(
              hintText: getUseremail,
              icon: Icons.person,
              onChanged: (value)
              {
                _emailController.text = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value)
              {
                _passwordController.text = value;
              },
            ),





            RoundedInputField(
              hintText: getUserNumber,
              icon: Icons.phone,
              onChanged: (value)
              {
                _phoneController.text = value;
              },
            ),
            RoundedButton(
              text: "Update Info",
              press: ()
              {
                checkFields();
              },
            ),
            SizedBox(height: _screenHeight * 0.03,),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),

          ],










        ),
      ),
    );



  }
}
