// ignore_for_file: library_private_types_in_public_api, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/widget/button.dart';

class ConnectivityChangeHandler extends StatefulWidget {
  final Widget child;
  final VoidCallback? retryClick;

  const ConnectivityChangeHandler({
    Key? key,
    required this.child,
    this.retryClick,
  }) : super(key: key);

  @override
  _ConnectivityChangeHandlerState createState() =>
      _ConnectivityChangeHandlerState();
}

class _ConnectivityChangeHandlerState extends State<ConnectivityChangeHandler> {
  // List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    isNoInternetConnection = false;
    // initConnectivity();
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    // _connectivitySubscription.cancel(); // Clean up the subscription
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initConnectivity() async {
  //   late List<ConnectivityResult> result;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     return;
  //   }
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) {
  //     return Future.value(null);
  //   }

  //   return _updateConnectionStatus(result);
  // }

  bool isNoInternetConnection = false;

  // Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
  //   setState(() {
  //     _connectionStatus = result;
  //     isNoInternetConnection =
  //         _connectionStatus.any((connection) => connection.name == 'none');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          TextDirection.ltr, // or TextDirection.rtl based on your requirement
      child: Stack(
        children: [
          widget.child,
          isNoInternetConnection
              ? Stack(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color:
                            context.resources.color.themeColor.withOpacity(0.3),
                      ),
                    ),
                    Center(
                      child: Card(
                        elevation: 5,
                        color: Colors.white, // White background for the card
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // Background color for the Container
                            borderRadius: BorderRadius.circular(
                                10), // Rounded corners for the Container
                          ),
                          width: MediaQuery.of(context).size.width /
                              2, // Ensure the container has a white background
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/images/no_connection.svg',
                                height: 100,
                                width: 100,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    style: TextStyle(fontSize: 14.0),
                                    textAlign: TextAlign.center,
                                    "No internet connection\nPlease check your internet connection"),
                              ),
                              if (widget.retryClick != null)
                                Button(
                                  icon: 'assets/images/retry.svg',
                                  onClick: widget.retryClick!,
                                  width: 120,
                                  text: "Retry!",
                                ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox()
        ],
      ),
    );
  }
}
