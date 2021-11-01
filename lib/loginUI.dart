import 'dart:ui';

import 'package:authentication/scan.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class loginUI extends StatefulWidget {
  const loginUI({Key key}) : super(key: key);

  @override
  _loginUIState createState() => _loginUIState();
}

class _loginUIState extends State<loginUI> {
  bool codeSent = false;
  String verifyID;
  String pinto;
  String countryCodeselect;
  TextEditingController phoneController = new TextEditingController();
  String number;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      //Color(0xffbbdefb),
                      //Color(0xff90caf9),
                      Color(0xff64b6f6),
                      Color(0xff42a5f5),
                      Color(0xff2196f3),
                      Color(0xff1e88e5)
                    ])),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 380),
                      codeSent ? buildOTP() : buildNumber(),
                      codeSent ? buildOTPbutton() : buildButton()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNumber() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text("PhoneNumber",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          SizedBox(height: 10),
          Container(
            height: 55,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CountryCodePicker(
                  initialSelection: "US",
                  onChanged: (countryCode) {
                    countryCodeselect = countryCode.toString();
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 3, left: 10),
                        hintText: "Enter your Phonenumber",
                        hintStyle:
                            TextStyle(color: Colors.black, fontSize: 16)),
                    onChanged: (phoneController) {
                      number = phoneController.toString();
                    },
                  ),
                )
              ],
            ),
          )
        ]);
  }

  Widget buildOTPbutton() {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(vertical: 25),
            width: double.infinity,
            child: ElevatedButton(
                child: Text(
                  "Verify",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  verifyPin(pinto);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black87,
                  minimumSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ))),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Didn't receive the code?",
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "Resend now",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            )
          ],
        )
      ],
    );
  }

  Widget buildButton() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25),
        width: double.infinity,
        child: ElevatedButton(
            child: Text(
              "Send OTP",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              verifyPhone();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black87,
              minimumSize: Size(300, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            )));
  }

  Widget buildOTP() {
    return Column(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("Verification code has been sent to this number",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal)),
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text("$countryCodeselect$number",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal)),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text("Please,enter the code to verify.",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal))
          ],
        ),
        SizedBox(
          height: 20,
        ),
        OTPTextField(
          length: 6,
          fieldWidth: 50,
          width: double.infinity,
          style: TextStyle(fontSize: 20),
          textFieldAlignment: MainAxisAlignment.spaceAround,
          fieldStyle: FieldStyle.box,
          otpFieldStyle: OtpFieldStyle(
              enabledBorderColor: Colors.white,
              borderColor: Colors.white,
              focusBorderColor: Colors.black),
          outlineBorderRadius: 15,
          onCompleted: (pin) {
            pinto = pin;
            verifyPin(pin);
          },
        )
      ],
    );
  }

  Future<void> verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCodeselect + number,
        verificationCompleted: (AuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String code, int resendToken) {
          setState(() {
            codeSent = true;
            verifyID = code;
          });
        },
        codeAutoRetrievalTimeout: (String verificatiionid) {
          setState(() {
            verifyID = verificatiionid;
          });
        },
        timeout: Duration(seconds: 60));
  }

  void verifyPin(String pin) async {
    PhoneAuthCredential phoneAuthCredential =
        PhoneAuthProvider.credential(verificationId: verifyID, smsCode: pin);

    try {
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      final snackBar = SnackBar(content: Text("Login Success"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.push(context, MaterialPageRoute(builder: (context) => MyAp()));
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text("${e.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
