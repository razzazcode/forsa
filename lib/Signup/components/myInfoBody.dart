import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forsa/DialogBox/errorDialog.dart';
import 'package:forsa/DialogBox/loadingDialog.dart';
import 'package:forsa/Login/login_screen.dart';
import 'package:forsa/Signup/components/background.dart';
import 'package:forsa/Widgets/already_have_an_account_acheck.dart';
import 'package:forsa/Widgets/rounded_button.dart';
import 'package:forsa/Widgets/rounded_input_field.dart';
import 'package:forsa/Widgets/rounded_password_field.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:forsa/globalVar.dart';

import '../../HomeScreen.dart';


class myInfoBody extends StatefulWidget {


  String sellerId;
  myInfoBody({this.sellerId});

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











  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File file = File(pickedFile.path);

    setState(() {
      _image = file;
    });
  }

  upload() async{
    showDialog(
        context: context,
        builder: (_){
          return LoadingAlertDialog();
        });

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
      _register();
    });

  }

  void _register() async{
    User currentUser;

    await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()
    ).then((auth){
      currentUser = auth.user;
      userId = currentUser.uid;
      userEmail = currentUser.email;
      getUserName = _nameController.text.trim();

      saveUserData();

    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (con){
        return ErrorAlertDialog(
          message: error.message.toString(),
        );
      });
    });

    if(currentUser != null){
      Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, newRoute);
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

  }


  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;


    return SignupBackground(
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
                  backgroundImage: _image==null?null:FileImage(_image),
                  child: _image == null
                      ? Icon(
                    Icons.add_photo_alternate,
                    size: _screenWidth * 0.20,
                    color: Colors.white,
                  )
                      : null,
                )),
            SizedBox(height: _screenHeight * 0.01),
            RoundedInputField(
              hintText: "Name",
              icon: Icons.person,
              onChanged: (value)
              {
                _nameController.text = value;
              },
            ),
            RoundedInputField(
              hintText: "Email",
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
              hintText: "Phone",
              icon: Icons.phone,
              onChanged: (value)
              {
                _phoneController.text = value;
              },
            ),
            RoundedButton(
              text: "SIGNUP",
              press: ()
              {
                upload();
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
