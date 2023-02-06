import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wsy/Store/storehome.dart';

enum Status { Waiting, Error }

class VerifyNumber extends StatefulWidget {
  const VerifyNumber({Key? key, this.number}) : super(key: key);

  final number;

  @override
  _VerifyNumber createState() => _VerifyNumber(number);
}

class _VerifyNumber extends State<VerifyNumber> {
  final phoneNumber;
  var _textEditingController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  var _status = Status.Error;
  var _verificationId;

  _VerifyNumber(this.phoneNumber);

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
    print("This is the number i input $phoneNumber");
  }

  Future _verifyPhoneNumber() async {
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (crdential) async {},
        verificationFailed: (reificationFailed) async {},
        codeSent: (verficationId, resendingToken) async {
          setState(() {
            _verificationId = verficationId;
            print("This is the verfication ID $_verificationId");
          });
        },
        codeAutoRetrievalTimeout: (verficationId) async {});
  }

  Future _sendCodeToFirebase({String? code}) async {
    if (_verificationId != null) {
      var crdential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code!);
      print("Thsi is the code $code");

      await _auth
          .signInWithCredential(crdential)
          .then((value) {
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => StoreHome()));
          })
          .whenComplete(() {})
          .onError((error, stackTrace) {
            setState(() {
              _textEditingController.text = '';
              this._status = Status.Error;
              print("Thsi is the code $code");
            });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text("Verify Number"),
          previousPageTitle: "Edit Number",
        ),
        body: _status != Status.Waiting
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "OTP Verification",
                      style: TextStyle(
                          color: Color(0xFF08C187).withOpacity(0.7),
                          fontSize: 30),
                    ),
                  ),
                  Text(
                    "Enter OTP sent to ",
                    style: TextStyle(
                      color: CupertinoColors.secondaryLabel,
                      fontSize: 17,
                    ),
                  ),
                  Text(phoneNumber == null ? "" : phoneNumber),
                  CupertinoTextField(
                    onChanged: (value) async {
                      print(value);
                      if (value.length == 6) {
                        _sendCodeToFirebase(code: value);
                      }
                    },
                    textAlign: TextAlign.center,
                    style: TextStyle(letterSpacing: 30, fontSize: 30),
                    maxLength: 6,
                    controller: _textEditingController,
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't receive the OTP?"),
                      CupertinoButton(
                          child: Text("RESEND OTP"),
                          onPressed: () async => _verifyPhoneNumber()),
                    ],
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "OTP Verification",
                      style: TextStyle(
                        color: Color(0xFF08C187).withOpacity(0.7),
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Text("The code used is invalid!"),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Edit Number"),
                  ),
                  CupertinoButton(
                    onPressed: () {},
                    child: Text("Resend Code"),
                  )
                ],
              ));
  }
}
