import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wsy/Config/config.dart';
import '../DialogBox/errorDialog.dart';
import '../DialogBox/loadingDialog.dart';
import '../Store/storehome.dart';
import '../Widgets/customTextField.dart';
import '../global/global.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

BestTutorSite _site = BestTutorSite.male;

enum BestTutorSite { male, female }

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _ageTextEditingController =
      TextEditingController();
  final TextEditingController _genderEdtiginController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      TextEditingController();
  final TextEditingController _phoneNumberTextEditingController =
      TextEditingController();
  static const String _title = 'Radio Button Example';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  XFile? imageXFile;
  File? image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    image = (File(imageXFile!.path));
    setState(() {
      imageXFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 25.0,
          ),
          InkWell(
            onTap: () {
              _getImage();
            },
            child: CircleAvatar(
              radius: _screenWidth * 0.15,
              backgroundColor: Colors.white,
              backgroundImage:
                  imageXFile == null ? null : FileImage(File(imageXFile!.path)),
              child: imageXFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      size: MediaQuery.of(context).size.width * 0.20,
                      color: Colors.grey,
                    )
                  : null,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _nameTextEditingController,
                  data: Icons.person,
                  hintText: "Name",
                  isObsecure: false,
                ),
                CustomTextField(
                  controller: _emailTextEditingController,
                  data: Icons.email,
                  hintText: "Email",
                  isObsecure: false,
                ),
                CustomTextField(
                  controller: _ageTextEditingController,
                  data: Icons.numbers,
                  hintText: "Phone Number",
                  isObsecure: false,
                ),
                CustomTextField(
                  controller: _phoneNumberTextEditingController,
                  data: Icons.person_remove_alt_1_rounded,
                  hintText: "Age",
                  isObsecure: false,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Male'),
                        leading: Radio(
                          value: BestTutorSite.male,
                          groupValue: _site,
                          onChanged: (value) {
                            setState(() {
                              _site = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        title: const Text('Female'),
                        leading: Radio(
                          value: BestTutorSite.female,
                          groupValue: _site,
                          onChanged: (value) {
                            setState(() {
                              _site = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                CustomTextField(
                  controller: _passwordTextEditingController,
                  data: Icons.lock,
                  hintText: "Password",
                  isObsecure: true,
                ),
                CustomTextField(
                  controller: _cPasswordTextEditingController,
                  data: Icons.lock,
                  hintText: "Confirm Password",
                  isObsecure: true,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              uploadAndSaveImage();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan,
            ),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Sign up",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Container(
            height: 4.0,
            width: _screenWidth * 0.8,
            color: Colors.cyan,
          ),
          const SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Future<void> uploadAndSaveImage() async {
    _passwordTextEditingController.text == _cPasswordTextEditingController.text
        ? _emailTextEditingController.text.isNotEmpty &&
                _passwordTextEditingController.text.isNotEmpty &&
                _cPasswordTextEditingController.text.isNotEmpty &&
                _nameTextEditingController.text.isNotEmpty
            ? uploadToStorage()
            : displayDialog("Please fill up the registration form..")
        : displayDialog("Password do not match.");
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingAlertDialog(
            message: "Registering, Please wait....",
          );
        });

    String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();
    if (imageXFile == null) {
      print("image is null");
    } else {
      fStorage.Reference reference = fStorage.FirebaseStorage.instance
          .ref()
          .child("usersImages")
          .child(imageFileName);
      fStorage.UploadTask uploadTask = reference.putFile(image!);
      fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      await taskSnapshot.ref.getDownloadURL().then((url) {
        userImageUrl = url;
      });
    }
    _registerUser();
  }

  User? firebaseUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async {
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((_auth) {
      firebaseUser = _auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    saveUserInfoToFireStor(firebaseUser!).then((value) {
      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (c) => StoreHome());
      Navigator.pushReplacement(context, route);
    });
  }

  Future saveUserInfoToFireStor(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "phoneNumber": _ageTextEditingController.text.trim(),
      "age": int.parse(_phoneNumberTextEditingController.text.trim()),
      "gender": _site.name.toString(),
      "url": userImageUrl,
      wsy.userCartList: ["garbageValue"],
    });

    //Save Data Locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(wsy.userUID, fUser.uid);
    await sharedPreferences.setString(wsy.userEmail, fUser.email.toString());
    await sharedPreferences.setString(wsy.userAvatarUrl, userImageUrl);
    await sharedPreferences.setString(
        wsy.userName, _nameTextEditingController.text.trim());
    await sharedPreferences.setInt(
        wsy.age, int.parse(_phoneNumberTextEditingController.text.trim()));
    await sharedPreferences.setString(
        wsy.phoneNumber, _ageTextEditingController.text.trim());
    await sharedPreferences.setString(wsy.gender, _site.name.toString());
    await sharedPreferences.setStringList(wsy.userCartList, ["garbageValue"]);
  }
}
