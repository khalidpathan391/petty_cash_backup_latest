import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/IDCard/DDT/driving_license.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/IDCard/EmployeeCard/EmpCard.dart';
import 'package:petty_cash/view/common/CustomLoaders/custom_refresh.dart';
import 'package:petty_cash/view/widget/common_text.dart';

class DocumantOrientation extends StatefulWidget {
  final int index;

  const DocumantOrientation({Key? key, required this.index}) : super(key: key);

  @override
  State<DocumantOrientation> createState() => _DocumantOrientationState();
}

class _DocumantOrientationState extends State<DocumantOrientation> {
  bool isLoading = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom,
    ]);
    super.initState();
    isLoading = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
          SystemUiOverlay.bottom,
          SystemUiOverlay.top,
        ]);
        if (didPop) {
          return;
        }
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            body: Stack(
              children: [
                //  IconButton(
                //           icon: const Icon(Icons.close),
                //           onPressed: _handleClose,
                //         ),
                isLoading
                    ? const Center(
                        child: CustomLoader(),
                      )
                    : widget.index == 1
                        ? DrivingLicense(
                            onDoubleTap: () {
                              Navigator.pop(context);
                            },
                            isLandscape: true,
                          )
                        : widget.index == 2
                            ? EmployeeIDForm(
                                onDoubleTap: () {
                                  Navigator.pop(context);
                                },
                                isLandscape: true,
                              )
                            : const CommonTextView(
                                label: 'Under Development',
                              ),
              ],
            )),
      ),
    );
  }
  //  void _handleClose() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   setState(() {
  //      _isLandscape = false;
  //   });
  // }
}
