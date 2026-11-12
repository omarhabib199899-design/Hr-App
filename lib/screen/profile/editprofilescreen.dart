import 'dart:io';

import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:cnattendance/provider/profileprovider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/editprofile';

  @override
  State<StatefulWidget> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  int genderIndex = 0;

  bool isLoading = false;

  final _form = GlobalKey<FormState>();

  late ScrollController scrollController;

  bool validateField(String value) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(hideKeyboard);
    super.initState();
  }

  hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _form.currentState?.dispose();
    scrollController.dispose();
    super.dispose();
  }

  String getGender() {
    var gender = '';
    switch (genderIndex) {
      case 0:
        gender = 'male';
        break;
      case 1:
        gender = 'female';
        break;
      case 2:
        gender = 'others';
        break;
    }

    return gender;
  }

  void validateValue() async {
    final value = _form.currentState!.validate();

    if (value) {
      isLoading = true;
      setState(() {
        EasyLoading.show(
            status: "Changing", maskType: EasyLoadingMaskType.black);
      });
      try {
        final response =
            await Provider.of<ProfileProvider>(context, listen: false)
                .updateProfile(
                    _nameController.text,
                    _emailController.text,
                    _addressController.text,
                    _dobController.text,
                    getGender(),
                    _phoneController.text,
                    File(''));

        if (!mounted) {
          return;
        }
        isLoading = false;
        setState(() {
          EasyLoading.dismiss(animation: true);
        });
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response.message)));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response.message)));
        }
      } catch (e) {
        isLoading = false;
        setState(() {
          EasyLoading.dismiss(animation: true);
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  var initial = true;

  @override
  void didChangeDependencies() {
    if (initial) {
      final profile = Provider.of<ProfileProvider>(context).profile;
      _nameController.text = profile.name;
      _emailController.text = profile.email;
      _addressController.text = profile.address;
      _phoneController.text = profile.phone;
      _dobController.text = profile.dob;

      switch (profile.gender.toLowerCase()) {
        case 'male':
          genderIndex = 0;
          break;
        case 'female':
          genderIndex = 1;
          break;
        case 'others':
          genderIndex = 2;
          break;
        default:
          genderIndex = 0;
          break;
      }
      setState(() {});
      initial = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final profile = Provider.of<ProfileProvider>(context).profile;
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Container(
        decoration: RadialDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(translate('edit_profile_screen.edit_profile')),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: HexColor("#036eb7"),
                    shape: ButtonBorder(),
                    fixedSize: Size(double.maxFinite, 55)),
                onPressed: () {
                  validateValue();
                },
                child: Text(
                  translate('edit_profile_screen.update'),
                  style: TextStyle(color: Colors.white),
                )),
          ),
          body: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 50,
                            maxWidth: 500);
                        if (image != null) {
                          setState(() {
                            EasyLoading.show(
                                status: 'Changing....',
                                maskType: EasyLoadingMaskType.black);
                            isLoading = true;
                          });
                          try {
                            await provider.updateProfile(
                                '', '', '', '', '', '', File(image.path));
                          } catch (e) {
                            print(e);
                          }
                          setState(() {
                            isLoading = false;
                            EasyLoading.dismiss(animation: true);
                          });
                        }
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(profile.avatar))),
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                color: Colors.black12,
                                padding: const EdgeInsets.all(20),
                                child: const Text('Change',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center),
                              ))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (!validateField(value!)) {
                          return "Empty Field";
                        }

                        return null;
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: translate('edit_profile_screen.fullname'),
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white24,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (!validateField(value!)) {
                          return "Empty Field";
                        }

                        return null;
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: translate('edit_profile_screen.email'),
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white24,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _addressController,
                      keyboardType: TextInputType.streetAddress,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (!validateField(value!)) {
                          return "Empty Field";
                        }

                        return null;
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: translate('edit_profile_screen.address'),
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon:
                            Icon(Icons.location_on, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white24,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (!validateField(value!)) {
                          return "Empty Field";
                        }

                        return null;
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: translate('edit_profile_screen.phone_number'),
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon:
                            Icon(Icons.phone_android, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white24,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _dobController,
                      validator: (value) {
                        if (!validateField(value!)) {
                          return "Empty Field";
                        }

                        return null;
                      },
                      keyboardType: TextInputType.datetime,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: translate('edit_profile_screen.dob'),
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.calendar_month_sharp,
                            color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white24,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                      ),
                      readOnly: true,
                      //set it true, so that user will not able to edit text
                      onTap: () async {
                        final pickedDate = await provider.isAd()
                            ? await showDatePicker(
                                context: context,
                                initialDate:
                                    DateTime.parse(_dobController.text),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2100))
                            : await picker.showNepaliDatePicker(
                                context: context,
                                initialDate:
                                    NepaliDateTime.parse(_dobController.text),
                                firstDate: NepaliDateTime(2000),
                                lastDate: NepaliDateTime(2090),
                                initialDatePickerMode: DatePickerMode.day,
                              );

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

                          if (!(await provider.isAd())) {
                            String formattedDate =
                                NepaliDateFormat('yyyy-MM-dd')
                                    .format((pickedDate as NepaliDateTime));
                            _dobController.text = formattedDate;
                          } else {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              _dobController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          }
                        } else {}
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate('edit_profile_screen.gender'),
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ToggleSwitch(
                            borderWidth: 1,
                            borderColor: [Colors.white12],
                            dividerColor: Colors.white12,
                            activeBgColor: const [Colors.white12],
                            activeFgColor: Colors.white,
                            inactiveFgColor: Colors.white,
                            inactiveBgColor: Colors.transparent,
                            minWidth: 100,
                            minHeight: 45,
                            initialLabelIndex: genderIndex,
                            totalSwitches: 3,
                            onToggle: (index) {
                              genderIndex = index!;
                            },
                            labels: [
                              translate('edit_profile_screen.male'),
                              translate('edit_profile_screen.female'),
                              translate('edit_profile_screen.other')
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
