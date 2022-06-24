import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lilac_machine_test/Helper/Constants.dart';
import 'package:lilac_machine_test/Helper/sharedPref.dart';

class EditProfile extends StatefulWidget {
  final refresh;
  const EditProfile({Key? key, this.refresh}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  var FinalDateFormat;
  var formatted;
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now()) as DateTime;

    formatted = FinalDateFormat;
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var month = DateFormat.MMMM().format(selectedDate);
        FinalDateFormat = "${selectedDate.day}-$month-${selectedDate.year}";
        formatted = FinalDateFormat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Wrap(
          runSpacing: 15,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Username",
                labelStyle: const TextStyle(fontSize: 15),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(fontSize: 15),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    w(10),
                    formatted != null
                        ? Text(formatted.toString())
                        : const Text(
                            "Date Of Birth",
                            style: TextStyle(fontSize: 15),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: button(),
    );
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () async {
          if (nameController.text.toString().length >= 1) {
            await setSharedPrefrence(Name, nameController.text.toString());
          }
          if (emailController.text.toString().length >= 1) {
            await setSharedPrefrence(Email, emailController.text.toString());
          }
          if (formatted != null) {
            await setSharedPrefrence(Email, emailController.text.toString());
            await setSharedPrefrence(DOB, formatted);
          }

          widget.refresh();
          Navigator.pop(context);
        },
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: buttonGradient,
              borderRadius: BorderRadius.circular(10)),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: Text(
              "Save",
              style: size16_700W,
            ),
          ),
        ),
      ),
    );
  }
}
