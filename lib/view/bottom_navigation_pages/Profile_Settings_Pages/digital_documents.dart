import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/IDCard/DDT/driving_license.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/IDCard/EmployeeCard/EmpCard.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/document_orientation.dart';
import 'package:petty_cash/view/common/CustomLoaders/custom_refresh.dart';
import 'package:petty_cash/view/widget/common_text.dart';

class DigitalDocuments extends StatefulWidget {
  static const String id = 'digital_document';

  const DigitalDocuments({Key? key}) : super(key: key);

  @override
  State<DigitalDocuments> createState() => _DigitalDocumentsState();
}

class _DigitalDocumentsState extends State<DigitalDocuments> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
          SystemUiOverlay.top,
          SystemUiOverlay.bottom,
        ]);
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

        if (didPop) {
          return;
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: const Text('Digital Documents'),
            centerTitle: true,

            backgroundColor: Colors.grey.shade200,
            // elevation: 0,
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              const CommonTextView(
                label: "Employee ID Card",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                margin: EdgeInsets.only(bottom: 20, top: 10),
              ),
              isLoading
                  ? const CustomLoader()
                  : EmployeeIDForm(
                      onDoubleTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DocumantOrientation(
                                      index: 2,
                                    ))).then((value) {
                          isLoading = true;
                          Future.delayed(const Duration(milliseconds: 500), () {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        });
                      },
                    ),
              const CommonTextView(
                label: "Driving License",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                margin: EdgeInsets.only(top: 30),
              ),
              isLoading
                  ? const CustomLoader()
                  : DrivingLicense(
                      onDoubleTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DocumantOrientation(
                                      index: 1,
                                    ))).then((value) {
                          SystemChrome.setEnabledSystemUIMode(
                              SystemUiMode.manual,
                              overlays: [
                                SystemUiOverlay.bottom,
                                SystemUiOverlay.top,
                              ]);
                          isLoading = true;
                          Future.delayed(const Duration(milliseconds: 500), () {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        });
                      },
                    ),

// const CommonTextView(label: "Dummy",fontSize: 20,fontWeight: FontWeight.bold,
//                margin: EdgeInsets.only(top: 30),
//                ),
//               isLoading?const CustomLoader(): Dummy(onDoubleTap: (){
//                 Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => const DocumantOrientation(index: 1,))
//   ).then((value) {
//      isLoading =true;
//     Future.delayed(const Duration(milliseconds: 500),(){
//       setState(() {
//            isLoading =false;
//       });
//     });
//   });
//               },),
            ],
          )),
        ),
      ),
    );
  }
}
