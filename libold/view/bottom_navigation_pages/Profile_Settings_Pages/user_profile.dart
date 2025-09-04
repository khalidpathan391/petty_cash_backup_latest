// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last, avoid_print, prefer_final_fields, unused_element, unused_field, use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/widget/common_text.dart';

class UserProfile extends StatefulWidget {
  static const String id = "user_profile";
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 7, vsync: this);
    super.initState();
  }

  @override
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bigText = context.resources.dimension.appBigText;
    Color themeColor = context.resources.color.themeColor;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: themeColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: CommonTextView(
          label: 'User Profile',
          color: Colors.white,
          fontFamily: 'Bold',
          fontSize: bigText + 4,
        ),
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  color: themeColor,
                ),
              ),
              Positioned(
                top: 30,
                child: InkWell(
                  onTap: () {
                    if (Global.empData!.fileName != null &&
                        Global.empData!.fileName!.isNotEmpty) {
                      _openImageDialog();
                    } else {
                      AppUtils.showToastRedBg(context, "Image Is Not Availble");
                    }
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: Global.empData!.media == 1
                        ? NetworkImage(ApiUrl.baseUrl! +
                            Global.empData!.fileName.toString())
                        : null,
                    child: Global.empData!.media != 1
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          CommonTextView(
            label: Global.empData!.empName.toString(),
            fontSize: bigText + 6,
            padding: const EdgeInsets.only(top: 30),
            color: Colors.blue,
            textAlign: TextAlign.center,
          ),
          CommonTextView(
            label: 'Lead Technical Consultent',
            // label: Global.empData!.empName.toString(),
            fontSize: bigText, padding: const EdgeInsets.only(bottom: 30),
            fontFamily: 'Bold',
            color: Colors.black87,
            textAlign: TextAlign.center,
          ),
          CommonTextView(
            label: 'Update Profile',
            // label: Global.empData!.empName.toString(),
            fontSize: bigText + 3,
            fontFamily: 'Bold',
            color: Colors.black87,
            textAlign: TextAlign.center,
          ),
          TabBar(
            controller: _tabController,
            labelColor: themeColor,
            indicatorColor: themeColor,
            unselectedLabelColor: themeColor.withOpacity(0.5),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal),
            indicatorPadding: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            tabAlignment: TabAlignment.start,
            indicator: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(
                color: context.resources.color.themeColor,
                width: 2,
              )),
            ),
            overlayColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return context.resources.color.themeColor.withOpacity(.2);
              }
              return Colors.white;
            }),
            isScrollable: true,
            tabs: [
              Tab(
                child: CommonTextView(
                  label: 'Contact Information',
                  fontSize: context.resources.dimension.appBigText,
                  color: themeColor,
                  margin: EdgeInsets.symmetric(horizontal: AppWidth(10)),
                ),
              ),
              Tab(
                child: CommonTextView(
                  label: 'About Me',
                  fontSize: context.resources.dimension.appBigText,
                  color: themeColor,
                  margin: EdgeInsets.symmetric(horizontal: AppWidth(10)),
                ),
              ),
              Tab(
                child: CommonTextView(
                  label: 'Vaccination',
                  fontSize: context.resources.dimension.appBigText,
                  color: themeColor,
                  margin: EdgeInsets.symmetric(horizontal: AppWidth(10)),
                ),
              ),
              Tab(
                child: CommonTextView(
                  label: 'Family Relation',
                  fontSize: context.resources.dimension.appBigText,
                  color: themeColor,
                  margin: EdgeInsets.symmetric(horizontal: AppWidth(10)),
                ),
              ),
              Tab(
                child: CommonTextView(
                  label: 'Skills and expertise',
                  fontSize: context.resources.dimension.appBigText,
                  color: themeColor,
                  margin: EdgeInsets.symmetric(horizontal: AppWidth(10)),
                ),
              ),
              Tab(
                child: CommonTextView(
                  label: 'Schools and education',
                  fontSize: context.resources.dimension.appBigText,
                  color: themeColor,
                  margin: EdgeInsets.symmetric(horizontal: AppWidth(10)),
                ),
              ),
              Tab(
                child: CommonTextView(
                  label: 'Interests and hobbies',
                  fontSize: context.resources.dimension.appBigText,
                  color: themeColor,
                  margin: EdgeInsets.symmetric(horizontal: AppWidth(10)),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: const [
                    Text(
                      "Overview",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text("Overview Content Item 1"),
                      subtitle: Text("Details about item 1"),
                      trailing: Icon(Icons.copy),
                    ),
                    ListTile(
                      title: Text("Overview Content Item 2"),
                      subtitle: Text("Details about item 2"),
                      trailing: Icon(Icons.copy),
                    ),
                    Divider(),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: const [
                    Text(
                      "Company",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text("Company Content Item 1"),
                      subtitle: Text("Details about company item 1"),
                      trailing: Icon(Icons.copy),
                    ),
                    ListTile(
                      title: Text("Company Content Item 2"),
                      subtitle: Text("Details about company item 2"),
                      trailing: Icon(Icons.copy),
                    ),
                    Divider(),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: const [
                    Text(
                      "Organization",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text("Organization Content Item 1"),
                      subtitle: Text("Details about organization item 1"),
                      trailing: Icon(Icons.copy),
                    ),
                    ListTile(
                      title: Text("Organization Content Item 2"),
                      subtitle: Text("Details about organization item 2"),
                      trailing: Icon(Icons.copy),
                    ),
                    Divider(),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: const [
                    Text(
                      "Contact",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text("Contact Content Item 1"),
                      subtitle: Text("Details about contact item 1"),
                      trailing: Icon(Icons.copy),
                    ),
                    ListTile(
                      title: Text("Contact Content Item 2"),
                      subtitle: Text("Details about contact item 2"),
                      trailing: Icon(Icons.copy),
                    ),
                    Divider(),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: const [
                    Text(
                      "Devices",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text("Devices Content Item 1"),
                      subtitle: Text("Details about devices item 1"),
                      trailing: Icon(Icons.copy),
                    ),
                    ListTile(
                      title: Text("Devices Content Item 2"),
                      subtitle: Text("Details about devices item 2"),
                      trailing: Icon(Icons.copy),
                    ),
                    Divider(),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: const [
                    Text(
                      "Language & Region",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text("Language Content Item 1"),
                      subtitle: Text("Details about language item 1"),
                      trailing: Icon(Icons.copy),
                    ),
                    ListTile(
                      title: Text("Language Content Item 2"),
                      subtitle: Text("Details about language item 2"),
                      trailing: Icon(Icons.copy),
                    ),
                    Divider(),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: const [
                    Text(
                      "Delegation",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text("Delegation Content Item 1"),
                      subtitle: Text("Details about delegation item 1"),
                      trailing: Icon(Icons.copy),
                    ),
                    ListTile(
                      title: Text("Delegation Content Item 2"),
                      subtitle: Text("Details about delegation item 2"),
                      trailing: Icon(Icons.copy),
                    ),
                    Divider(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String imageUrl = ApiUrl.baseUrl! + Global.empData!.fileName.toString();

        return Dialog(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Global.empData!.media == 1
                      ? Image.file(
                          File(Global.empData!.fileName.toString()),
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )),
            ),
          ),
        );
      },
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
