import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lilac_machine_test/Helper/Constants.dart';
import 'package:lilac_machine_test/Helper/sharedPref.dart';
import 'package:lilac_machine_test/Helper/snackbar_toast_helper.dart';
import 'package:lilac_machine_test/Screens/EditProfile.dart';
import 'package:lilac_machine_test/Screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final Function refresh;
  const ProfilePage({Key? key, required this.refresh}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var namee;
  var emaill;
  var dob;
  var load = false;
  var offLine = false;
  var imgg;
  File? image;
  @override
  void initState() {
    super.initState();
    reee();
    setState(() {});
  }

  reee() async {
    var getPath = await getSharedPrefrence(IMG);
    imgg = getPath;
    var nm = await getSharedPrefrence(Name);
    var em = await getSharedPrefrence(Email);
    var dt = await getSharedPrefrence(DOB);
    setState(() {
      namee = nm;
      emaill = em;
      dob = dt;
    });

    return "success";
  }

  Future<bool> _onBackPressed() async {
    bool goBack = false;
    widget.refresh();
    Navigator.pop(context);

    return goBack;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: GestureDetector(
              child: Icon(Icons.arrow_back_outlined, color: Colors.black),
              onTap: () {
                widget.refresh();
                Navigator.pop(context);
              },
            ),
          ),
          title: Text("My Profile"),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile(refresh: reee)),
                        );
                      },
                      icon: Icon(Icons.edit, size: 20)),
                  Text("Edit")
                ],
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h(30),
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                          child: imgg != null
                              ? Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: FileImage(File(imgg)),
                                          fit: BoxFit.cover)))
                              : Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: Image.asset(
                                        "assets/profile.png",
                                        fit: BoxFit.cover,
                                      ).image)))),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            uploadImage();
                          },
                          child: const CircleAvatar(
                              backgroundColor: darkPink,
                              radius: 18,
                              child: Icon(Icons.camera_alt, size: 16)),
                        ),
                      )
                    ],
                  ),
                  w(20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, size: 18),
                            w(10),
                            Text(namee != null ? namee.toString() : "Name",
                                style: size16_700),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.email_outlined, size: 18),
                            w(10),
                            Text(emaill != null ? emaill.toString() : "Email",
                                style: size16_700),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 18),
                            w(10),
                            Text(dob != null ? dob.toString() : "Date of Birth",
                                style: size16_700),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 50,
          child: GestureDetector(
            onTap: () {
              _showDialog();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Icon(Icons.logout), Text("Logout")],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 100);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
        var set = setSharedPrefrence(IMG, image.path);
        reee();
      });
      showToastSuccess("Photo Updated!");
    } on PlatformException catch (e) {
      showToastSuccess("Failed to pick image : $e");
    }
  }

  void _showDialog() {
    showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        title: const Text('Confirm logout?'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              print("logout");
              await FirebaseAuth.instance.signOut();
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
