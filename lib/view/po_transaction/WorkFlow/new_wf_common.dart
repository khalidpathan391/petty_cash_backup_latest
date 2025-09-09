import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/common/common_work_flow_model.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/widget/common_empty_list%20copy.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/custom_arrow.dart';
import 'package:url_launcher/url_launcher.dart';

class NewWFCommon extends StatefulWidget {
  final List<ApprvlLvlStatus> listData;
  const NewWFCommon({super.key, required this.listData});

  @override
  State<NewWFCommon> createState() => _NewWFCommonState(listData);
}

class _NewWFCommonState extends State<NewWFCommon> {
  List<ApprvlLvlStatus> listData1;
  // bool isOpen = false;//for settings icon on workflow
  bool isProject = false;
  bool isDivision = false;
  bool isDepartment = false;
  bool isDesignation = false;
  _NewWFCommonState(this.listData1);

  double calculateTotalHeight(int itemCount, double rowHeight) {
    int numberOfRows;

    // Check if the item count is odd or even
    if (itemCount % 2 == 0) {
      // Even number of items, divide by 2
      numberOfRows = itemCount ~/ 2;
    } else {
      // Odd number of items, divide by 2 and add 1 extra row
      numberOfRows = (itemCount ~/ 2) + 1;
    }

    // Calculate the total height
    double totalHeight = numberOfRows * rowHeight;

    return totalHeight;
  }

  Color getStatusColor(String status, {type = 0}) {
    switch (status) {
      case 'Submitted':
      case 'Approved':
      case 'Approved & Forwarded':
        //forest green
        return type == 1
            ? const Color(0xFF228B22)
            : Colors.lightGreen.withOpacity(.2);
      case 'Pending':
        return type == 1 ? Colors.amber : Colors.amber.withOpacity(0.1);
      case 'Rejected':
      case 'CANCELLED':
        return Colors.red.shade400;
      case 'Delegated':
        return type == 1 ? Colors.teal : Colors.teal.withOpacity(.5);
      case 'FYI':
        return type == 1
            ? Colors.lightBlueAccent
            : Colors.lightBlueAccent.withOpacity(.2);
      case 'Re-Initiated':
        return type == 1 ? Colors.purple : Colors.purple.withOpacity(.25);
      case 'Request For Information':
        return type == 1 ? Colors.orange : Colors.orange.withOpacity(.5);
      case 'Replied':
        return type == 1 ? Colors.cyan : Colors.cyan.withOpacity(.7);
      case 'Forwarded':
        return const Color(0xffE6E6FA);
      case 'Transferred':
        return type == 1 ? Colors.indigo : Colors.indigo.withOpacity(.5);
      default:
        return type == 1
            ? Colors.grey
            : Colors.grey.withOpacity(0.5); // Default color
    }
  }

  // void setIsOpen(){isOpen = !isOpen;setState(() {});}
  void setIsProject(dynamic myState) {
    isProject = !isProject;
    setState(() {});
    myState(() {});
  }

  void setIsDivision(dynamic myState) {
    isDivision = !isDivision;
    setState(() {});
    myState(() {});
  }

  void setIsDepartment(dynamic myState) {
    isDepartment = !isDepartment;
    setState(() {});
    myState(() {});
  }

  void setIsDesignation(dynamic myState) {
    isDesignation = !isDesignation;
    setState(() {});
    myState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = AppWidthP(33);
    double containerHeight = 105;
    String url = ApiUrl.baseUrl!.substring(0, ApiUrl.baseUrl!.length - 1);
    Color themeColor = context.resources.color.themeColor;
    double mediumText = context.resources.dimension.appMediumText;
    double smallText = context.resources.dimension.appSmallText;
    double extraSmallText = context.resources.dimension.appExtraSmallText;
    return listData1.isEmpty
        ? const CommonEmptyList()
        : InteractiveViewer(
            maxScale: 10,
            child: SingleChildScrollView(
              child: ListView.builder(
                itemCount: listData1.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  double levelHeight = calculateTotalHeight(
                      listData1[index].workflowData!.length, containerHeight);
                  return Container(
                    padding: EdgeInsets.symmetric(
                        vertical: AppHeight(5), horizontal: AppWidth(5)),
                    child: Row(
                      children: [
                        //Make the levels
                        if (index != 0)
                          Container(
                            // color: Colors.green,
                            height: levelHeight,
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CommonTextView(
                                      label:
                                          'Level ${listData1[index].workflowLevel}',
                                      fontSize: smallText,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                      myDecoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey.withOpacity(.3),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 28,
                                      child: CustomArrow(
                                        arrowColor: themeColor,
                                        bodyHeight:
                                            18, // Adjust this to control the arrow body height
                                        bodyWidth:
                                            2, // Adjust this to control the arrow body width
                                        arrowHeadSize:
                                            6, // Adjust this to control the arrowhead size
                                        rotationAngle: 1.5708 *
                                            3, // 90-degree rotation (Pi/2 radians)
                                      ),
                                    ),
                                    CommonTextView(
                                      label: listData1[index].workflowType!,
                                      fontSize: smallText,
                                    ),
                                  ],
                                ),
                                if (index + 1 < listData1.length)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 55.0),
                                    child: CustomArrow(
                                      arrowColor: themeColor,
                                      bodyHeight: levelHeight -
                                          50, // Adjust this to control the arrow body height
                                      bodyWidth:
                                          3, // Adjust this to control the arrow body width
                                      arrowHeadSize:
                                          10, // Adjust this to control the arrowhead size
                                      // rotationAngle: 1.5708*3, // 90-degree rotation (Pi/2 radians)
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        //The child list
                        Expanded(
                          child: ListView.builder(
                            itemCount: listData1[index].workflowData!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, childIndex) {
                              return childIndex % 2 == 0
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: containerHeight,
                                              width: index == 0
                                                  ? AppWidthP(40)
                                                  : containerWidth,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    bottom: 0,
                                                    child: InkWell(
                                                      onTap: () {
                                                        _showActionStatusPopup(
                                                            context,
                                                            listData1[index]
                                                                    .workflowData![
                                                                childIndex],
                                                            url);
                                                      },
                                                      child: Container(
                                                        width: index == 0
                                                            ? AppWidthP(40)
                                                            : containerWidth,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 2),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                          color: getStatusColor(
                                                              listData1[index]
                                                                  .workflowData![
                                                                      childIndex]
                                                                  .action!),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CommonTextView(
                                                              label: listData1[
                                                                      index]
                                                                  .workflowData![
                                                                      childIndex]
                                                                  .actionTakenByEmpName!,
                                                              fontSize:
                                                                  smallText,
                                                              maxLine: 1,
                                                              overFlow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            CommonTextView(
                                                              label: listData1[
                                                                      index]
                                                                  .workflowData![
                                                                      childIndex]
                                                                  .department!,
                                                              fontSize:
                                                                  extraSmallText,
                                                              maxLine: 1,
                                                              overFlow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            CommonTextView(
                                                              label: listData1[
                                                                      index]
                                                                  .workflowData![
                                                                      childIndex]
                                                                  .userMobile!,
                                                              fontSize:
                                                                  extraSmallText,
                                                              maxLine: 1,
                                                              overFlow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            CommonTextView(
                                                              label: listData1[
                                                                      index]
                                                                  .workflowData![
                                                                      childIndex]
                                                                  .actionDate!,
                                                              fontSize:
                                                                  extraSmallText,
                                                              maxLine: 1,
                                                              overFlow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            // if(childIndex+1 < listData1[index].workflowData!.length)CommonTextView(
                                                            //   label: listData1[index].workflowData![childIndex+1].actionTakenByEmpName!,
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  //Add Image
                                                  Positioned(
                                                    top: 5,
                                                    left: 5,
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 20,
                                                        backgroundColor: context
                                                            .resources
                                                            .color
                                                            .colorLightGrey
                                                            .withOpacity(.5),
                                                        child: listData1[index]
                                                                .workflowData![
                                                                    childIndex]
                                                                .userImg!
                                                                .isEmpty
                                                            ? const Icon(
                                                                Icons.person)
                                                            : InkWell(
                                                                onTap: () => AppUtils.showPhotoDialog(
                                                                    context,
                                                                    listData1[
                                                                            index]
                                                                        .workflowData![
                                                                            childIndex]
                                                                        .actionTakenByEmpName!,
                                                                    '$url${listData1[index].workflowData![childIndex].userImg!}'),
                                                                child: Hero(
                                                                  tag:
                                                                      '$url${listData1[index].workflowData![childIndex].userImg!}',
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        '$url${listData1[index].workflowData![childIndex].userImg!}',
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      height:
                                                                          40,
                                                                      width: 40,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        image: DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.cover),
                                                                      ),
                                                                    ),
                                                                    progressIndicatorBuilder: (context,
                                                                            url,
                                                                            progress) =>
                                                                        SizedBox(
                                                                      width:
                                                                          10.0,
                                                                      height:
                                                                          10.0,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        value: progress
                                                                            .progress,
                                                                        color: context
                                                                            .resources
                                                                            .color
                                                                            .themeColor,
                                                                        strokeWidth:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons.person),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (childIndex + 1 <
                                                listData1[index]
                                                    .workflowData!
                                                    .length)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 40.0),
                                                child: Icon(
                                                  Icons.swap_horiz_outlined,
                                                  color: themeColor,
                                                ),
                                              ),
                                            if (childIndex + 1 <
                                                listData1[index]
                                                    .workflowData!
                                                    .length)
                                              SizedBox(
                                                height: containerHeight,
                                                width: containerWidth,
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      bottom: 0,
                                                      child: InkWell(
                                                        onTap: () {
                                                          _showActionStatusPopup(
                                                              context,
                                                              listData1[index]
                                                                      .workflowData![
                                                                  childIndex +
                                                                      1],
                                                              url);
                                                        },
                                                        child: Container(
                                                          width: containerWidth,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 5,
                                                                  vertical: 2),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                            color: getStatusColor(
                                                                listData1[index]
                                                                    .workflowData![
                                                                        childIndex +
                                                                            1]
                                                                    .action!),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CommonTextView(
                                                                label: listData1[
                                                                        index]
                                                                    .workflowData![
                                                                        childIndex +
                                                                            1]
                                                                    .actionTakenByEmpName!,
                                                                fontSize:
                                                                    smallText,
                                                                maxLine: 1,
                                                                overFlow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              CommonTextView(
                                                                label: listData1[
                                                                        index]
                                                                    .workflowData![
                                                                        childIndex +
                                                                            1]
                                                                    .department!,
                                                                fontSize:
                                                                    extraSmallText,
                                                                maxLine: 1,
                                                                overFlow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              CommonTextView(
                                                                label: listData1[
                                                                        index]
                                                                    .workflowData![
                                                                        childIndex +
                                                                            1]
                                                                    .userMobile!,
                                                                fontSize:
                                                                    extraSmallText,
                                                                maxLine: 1,
                                                                overFlow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              CommonTextView(
                                                                label: listData1[
                                                                        index]
                                                                    .workflowData![
                                                                        childIndex +
                                                                            1]
                                                                    .actionDate!,
                                                                fontSize:
                                                                    extraSmallText,
                                                                maxLine: 1,
                                                                overFlow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              // if(childIndex+1 < listData1[index].workflowData!.length)CommonTextView(
                                                              //   label: listData1[index].workflowData![childIndex+1].actionTakenByEmpName!,
                                                              // ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    //Add Image
                                                    Positioned(
                                                      top: 5,
                                                      left: 5,
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              context
                                                                  .resources
                                                                  .color
                                                                  .colorLightGrey
                                                                  .withOpacity(
                                                                      .5),
                                                          child: listData1[
                                                                      index]
                                                                  .workflowData![
                                                                      childIndex +
                                                                          1]
                                                                  .userImg!
                                                                  .isEmpty
                                                              ? const Icon(
                                                                  Icons.person)
                                                              : InkWell(
                                                                  onTap: () => AppUtils.showPhotoDialog(
                                                                      context,
                                                                      listData1[
                                                                              index]
                                                                          .workflowData![childIndex +
                                                                              1]
                                                                          .actionTakenByEmpName!,
                                                                      '$url${listData1[index].workflowData![childIndex + 1].userImg!}'),
                                                                  child: Hero(
                                                                    tag:
                                                                        '$url${listData1[index].workflowData![childIndex + 1].userImg!}',
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          '$url${listData1[index].workflowData![childIndex + 1].userImg!}',
                                                                      imageBuilder:
                                                                          (context, imageProvider) =>
                                                                              Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            40,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          image: DecorationImage(
                                                                              image: imageProvider,
                                                                              fit: BoxFit.cover),
                                                                        ),
                                                                      ),
                                                                      progressIndicatorBuilder: (context,
                                                                              url,
                                                                              progress) =>
                                                                          SizedBox(
                                                                        width:
                                                                            10.0,
                                                                        height:
                                                                            10.0,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          value:
                                                                              progress.progress,
                                                                          color: context
                                                                              .resources
                                                                              .color
                                                                              .themeColor,
                                                                          strokeWidth:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Icon(
                                                                              Icons.person),
                                                                    ),
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                        if (index == 0) ...[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                CommonTextView(
                                                  label: 'Submitted',
                                                  fontSize: mediumText,
                                                  color: Colors.white,
                                                  myDecoration:
                                                      const BoxDecoration(
                                                    color: Colors.green,
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black),
                                                      right: BorderSide(
                                                          color: Colors.black),
                                                      left: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(5),
                                                      bottomRight:
                                                          Radius.circular(5),
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                CustomArrow(
                                                  arrowColor: themeColor,
                                                  bodyHeight:
                                                      30, // Adjust this to control the arrow body height
                                                  bodyWidth:
                                                      3, // Adjust this to control the arrow body width
                                                  arrowHeadSize:
                                                      10, // Adjust this to control the arrowhead size
                                                  // rotationAngle: 1.5708, // 90-degree rotation (Pi/2 radians)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]
                                      ],
                                    )
                                  : const SizedBox();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
  }

  void _showActionStatusPopup(
      BuildContext context, WorkflowData data, String url) {
    final String userImgUrl = data.userImg!;
    final String actionStatus = data.action!;
    final String userName = data.actionTakenByEmpName!;
    final String userMobile = data.userMobile!;
    final String actionDate = data.actionDate!;
    final String departmentDesc = data.department!;
    final String remark = data.remark!;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top part (Green background with user details and action status)
              Container(
                color: getStatusColor(actionStatus, type: 1),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // User image
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: context.resources.color.colorLightGrey
                            .withOpacity(.5),
                        child: data.userImg!.isEmpty
                            ? const Icon(Icons.person)
                            : InkWell(
                                onTap: () => AppUtils.showPhotoDialog(
                                    context, userName, '$url$userImgUrl'),
                                child: Hero(
                                  tag: '$url$userImgUrl',
                                  child: CachedNetworkImage(
                                    imageUrl: '$url$userImgUrl',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    progressIndicatorBuilder:
                                        (context, url, progress) => SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                        color:
                                            context.resources.color.themeColor,
                                        strokeWidth: 1,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.person),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Action status and phone number
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            actionStatus,
                            maxLines: 2,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userMobile,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Close button & Call button
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.call, color: Colors.white),
                          onPressed: () => _makePhoneCall('tel:$userMobile'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bottom part (Details section)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Action Date
                    _buildInfoRow(
                        'Action Date', actionDate.isEmpty ? 'NA' : actionDate),

                    // User Name
                    _buildInfoRow(
                        'Name', '$userName(${data.actionTakenByEmpCode})'),

                    // Designation Description
                    _buildInfoRow('Designation', data.designation!),

                    // Project
                    _buildInfoRow('Project', data.project!),

                    // Division
                    _buildInfoRow('Division', data.division!),

                    // Department Description
                    _buildInfoRow('Department', departmentDesc),

                    // Remark (if available)
                    _buildInfoRow('Remark', remark),

                    // Attachment
                    if (data.attachment!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Attachment :  ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            //icon here
                            GestureDetector(
                              onTap: () async {
                                // Replace 'your_url_here' with the actual URL
                                // final imageUrl = '$url${data.attachment}';
                                // Launch the URL
                                final Uri uri = Uri.parse(data.attachment!);

                                if (!await launchUrl(uri)) {
                                  throw Exception(
                                      'Could not launch ${data.attachment}');
                                }
                              },
                              child: const Icon(
                                Icons
                                    .description, // You can use any relevant icon
                                color: Color(
                                    0xFF4682B4), // Set the color of the icon
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label :  ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: CommonTextView(
              label: value,
              maxLine: 3,
              overFlow: TextOverflow.ellipsis,
              fontSize: context.resources.dimension.appMediumText - 1,
              padding: const EdgeInsets.only(top: 4),
            ),
          ),
        ],
      ),
    );
  }

  /*Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label:  ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Ensure the color is set
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: Colors.black, // Ensure the color is set
                    ),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }*/

  Future<void> _makePhoneCall(String url) async {
    final Uri phoneUri = Uri.parse(url);

    if (!await launchUrl(phoneUri)) {
      throw Exception('Could not launch $url');
    }
  }
}
