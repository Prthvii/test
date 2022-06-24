import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lilac_machine_test/Helper/Constants.dart';
import 'package:lilac_machine_test/Screens/home.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_button/timer_button.dart';

class OTPScreen extends StatefulWidget {
  final mob;
  const OTPScreen({Key? key, this.mob}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  String? verificationId;

  @override
  void initState() {
    super.initState();
    this._verifyPhone();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter OTP sent to +91 " + widget.mob.toString(),
                style: size16_700),
            h(MediaQuery.of(context).size.height * 0.1),
            otp(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                height: 30,
                child: TimerButton(
                  label: "Resend OTP",
                  color: darkPink,
                  resetTimerOnPressed: true,
                  buttonType: ButtonType.TextButton,
                  timeOutInSeconds: 120,
                  onPressed: () async {
                    print("aaaaaaaa");
                    _verifyPhone();
                  },
                  disabledColor: Colors.white,
                  // color: BlckColor,
                  disabledTextStyle:
                      new TextStyle(fontSize: 12.0, color: Colors.grey),
                  activeTextStyle: new TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  otp() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: PinCodeTextField(
        appContext: context,
        autovalidateMode: AutovalidateMode.always,
        backgroundColor: Colors.transparent,
        controller: otpController,
        length: 6,
        enablePinAutofill: true,
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        textStyle: const TextStyle(color: Color(0xff2F455C), fontSize: 18),
        pinTheme: PinTheme(
          inactiveFillColor: Colors.white,
          activeFillColor: Colors.white,
          selectedFillColor: Colors.white,
          borderWidth: 1,
          shape: PinCodeFieldShape.underline,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 46,
          fieldWidth: 37,
        ),
        cursorColor: Colors.black54,
        cursorHeight: 20,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        autoFocus: true,
        autoDisposeControllers: false,
        keyboardType: TextInputType.number,
        onCompleted: (value) async {
          try {
            await FirebaseAuth.instance
                .signInWithCredential(PhoneAuthProvider.credential(
                    verificationId: verificationId.toString(), smsCode: value))
                .then((value) async {
              if (value.user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => home()),
                );
              }
            });
          } catch (e) {}
          print('OTP: $value');
        },
        onChanged: (value) {},
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          return true;
        },
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.mob}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => home()),
              );
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            verificationId = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    print(forceResendingToken);
  }
}
