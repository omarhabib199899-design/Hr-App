import 'dart:ui';

import 'package:cnattendance/model/auth.dart';
import 'package:cnattendance/screen/dashboard/dashboard_screen.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/customqrscanner.dart';
import 'package:cnattendance/widget/showlanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  bool initial = true;

  @override
  State<StatefulWidget> createState() => loginScreenState();
}

class loginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _form = GlobalKey<FormState>();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void didChangeDependencies() {
    if (widget.initial) {
      widget.initial = false;
      context.read<Auth>().resetAppUrl();
      context.read<Auth>().getAppUrl();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _form.currentState!.dispose();
    super.dispose();
  }

  var _isLoading = false;

  bool validateField(String value) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  validateValue() async {
    final value = _form.currentState!.validate();
    if (value) {
      loginUser();
    }
  }

  Future<void> scanQr() async {
    final result = await showCustomQrScanner(context);
    if (result != null && result.trim().isNotEmpty) {
      print('User typed: $result');
      context.read<Auth>().saveAppUrl(result ?? "");
    }
  }

  /*Future<void> loadQR() async {
    final MobileScannerController controller = MobileScannerController();

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      var analyzed = await controller.analyzeImage(image.path);
      if (analyzed != null) {
        if (analyzed.barcodes.isNotEmpty) {
          try {
            var image = analyzed.barcodes[0].displayValue;
            context.read<Auth>().saveAppUrl(image ?? "");
          } catch (e) {
            showToast(
                "Invalid QR Code. Please use a specific QR provided by the organization");
          }
        } else {
          showToast("No QR Code found");
        }
      } else {
        showToast("No QR Code found");
      }
    }
  }*/

  void loginUser() async {
    setState(() {
      _isLoading = true;
      EasyLoading.show(
          status: translate('loader.signing_in'),
          maskType: EasyLoadingMaskType.black);
    });

    try {
      final response = await Provider.of<Auth>(context, listen: false)
          .login(_usernameController.text, _passwordController.text);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.message)));

      Navigator.of(context)
          .pushNamedAndRemoveUntil(DashboardScreen.routeName, (route) => false);
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }

    setState(() {
      _isLoading = false;
      EasyLoading.dismiss(animation: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasUrl = context.watch<Auth>().appUrl.isNotEmpty;
    return Container(
      decoration: backgroundDecoration(),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Container(
          child: Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      builder: (context) {
                        return ShowLanguage();
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Form(
          key: _form,
          child: SingleChildScrollView(
            child: IgnorePointer(
              ignoring: _isLoading,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: !hasUrl
                    ? Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              /*GestureDetector(
                                onTap: () {
                                  context.read<Auth>().skipAppUrl();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 5),
                                  child: Text(
                                    translate("welcome_screen.skip"),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),*/
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onLongPress: () {
                                        context.read<Auth>().skipAppUrl();
                                      },
                                      child: SizedBox(
                                        width: 150,
                                        height: 150,
                                        child: Image.asset(
                                            'assets/icons/logo_bnw.png',
                                            color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      HexColor("#036eb7"),
                                                  padding: EdgeInsets.zero,
                                                  shape: ButtonBorder(),
                                                ),
                                                onPressed: () {
                                                  scanQr();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(20.0),
                                                  child: Text(
                                                    translate(
                                                        "welcome_screen.verify_button"),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )),
                                          ),
                                          /*SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                loadQR();
                                              },
                                              style: IconButton.styleFrom(
                                                shape: ButtonBorder(),
                                                backgroundColor:
                                                    HexColor("#036eb7")
                                                        .withOpacity(.7),
                                              ),
                                              icon: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Icon(
                                                  Icons.qr_code,
                                                  color: Colors.white,
                                                  size: 32,
                                                ),
                                              ))*/
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: Image.asset('assets/icons/logo_bnw.png',
                                      color: Colors.white),
                                ),
                              ),
                              gaps(20),
                              Text(
                                translate("login_screen.login"),
                                style:
                                    TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              gaps(20),
                              textHeading(translate("login_screen.username")),
                              gaps(10),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                keyboardAppearance: Brightness.dark,
                                style: TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (!validateField(value!)) {
                                    return "Empty Field";
                                  }
                      
                                  return null;
                                },
                                controller: _usernameController,
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.person, color: Colors.white),
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
                              gaps(10),
                              textHeading(translate("login_screen.password")),
                              gaps(10),
                              TextFormField(
                                obscureText: _obscureText,
                                keyboardAppearance: Brightness.dark,
                                style: TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (!validateField(value!)) {
                                    return "Empty Field";
                                  }
                      
                                  return null;
                                },
                                controller: _passwordController,
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.lock, color: Colors.white),
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
                                  suffixIcon: InkWell(
                                    onTap: _toggle,
                                    child: Icon(
                                      _obscureText
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              gaps(30),
                              button(),
                              gaps(20),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    openBrowserTab(context.read<Auth>().appUrl);
                                  },
                                  child: Text(
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.white),
                                      translate("login_screen.forget_password")),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      context.read<Auth>().resetAppUrl();
                                      _usernameController.clear();
                                      _passwordController.clear();
                                    },
                                    child: Text(
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.white),
                                        translate("login_screen.go_back")),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  openBrowserTab(String url) async {
    await FlutterWebBrowser.openWebPage(
      url: "${url}password/reset",
      customTabsOptions: const CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        shareState: CustomTabsShareState.on,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }

  BoxDecoration backgroundDecoration() {
    return BoxDecoration(
        image: DecorationImage(
      colorFilter: ColorFilter.mode(
          getAppTheme() ? Colors.blueGrey : Colors.black54,
          BlendMode.softLight),
      image: AssetImage(
        "assets/images/login.jpg",
      ),
      fit: BoxFit.cover,
    ));
  }

  Widget gaps(double value) {
    return SizedBox(
      height: value,
    );
  }

  Widget textHeading(String value) {
    return Text(
        textAlign: TextAlign.left,
        style: const TextStyle(color: Colors.white),
        value);
  }

  Widget button() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: HexColor("#036eb7"),
            padding: EdgeInsets.zero,
            shape: ButtonBorder(),
          ),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            validateValue();
          },
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          )),
    );
  }
}
