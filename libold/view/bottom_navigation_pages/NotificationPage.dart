import 'package:flutter/material.dart';

import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/my_account_page.dart';
import 'package:petty_cash/view/common/under_development.dart';
import 'package:petty_cash/view/widget/CustomAppBar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    //initialize all the video data here or in VM Constructor and call it up to you
    //Video
    //disposing any old video controller cannot have to many controllers or it crashes

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onTap: () {
          Navigator.pushNamed(context, MyAccount.id);
        },
        isSpace: true,
      ),
      body: const UnderDevelopment(
        text: "Todo Under Development",
        bottomSpacing: 70,
      ),
      /*Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonTextView(
            label: "Notifications".tr(),
            onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomVideoPlayer(
              url:'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',isFullScreen: true,doDispose: true,),),);
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const TBT_VideoPlayer(
            //     'https://erp.sendan.com.sa:8080/media/toolbox_topic/TBT_1706537355229.mp4'),),);
            },
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          const AudioRecorderPlayer(
            audioPathName: 'https://github.com/rafaelreis-hotmart/Audio-Sample-files/raw/master/sample.mp3',
            isOnline: true,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Global.allVideoData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    CommonTextView(label: 'Video ${index+1}',padding: const EdgeInsets.symmetric(vertical: 10),),
                    VideoItem(index: index,loadHeight: 150,width: AppWidthP(75),type:0,doDispose: false,),
                    // AudioRecorderPlayer(audioPathName: '${index+1}',),
                  ],
                );//add this in colum with other display data that's it
              },
            ),
          ),
        ],
      ),*/
    );
  }
}
