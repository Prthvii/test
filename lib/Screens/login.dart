import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lilac_machine_test/Helper/Constants.dart';
import 'package:lilac_machine_test/Screens/otpScreen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController numberController = new TextEditingController();

  bool isTap = false;
  bool enableBttn = false;
  @override
  Future<bool> _onBackPressed() {
    SystemNavigator.pop();

    return Future<bool>.value(true);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.1),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Image.asset("assets/logo.png"),
              ),
              const Text("Enter Your Phone Number", style: size18_700),
              h(20),
              Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                          keyboardType: TextInputType.number,
                          controller: numberController,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black),
                          onChanged: (v) {
                            if (numberController.text.length == 10) {
                              setState(() {
                                enableBttn = true;
                              });
                            }
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          decoration: InputDecoration(
                              labelText: "Mobile Number",
                              labelStyle: size14_400Grey,
                              prefixText: "+91  ",
                              prefixStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black),
                              filled: true,
                              fillColor: textFieldGrey,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: textFieldGrey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: textFieldGrey, width: 2.0)))),
                      h(20),
                      enableBttn == false
                          ? Opacity(
                              opacity: 0.5,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    gradient: buttonGradient,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  child: const Text(
                                    "Login",
                                    style: size16_700W,
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OTPScreen(
                                          mob: numberController.text
                                              .toString())),
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    gradient: buttonGradient,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  child: isTap == true
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          "Login",
                                          style: size16_700W,
                                        ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
