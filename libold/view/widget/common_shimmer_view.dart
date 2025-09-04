import 'package:flutter/material.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:shimmer/shimmer.dart';

class CommonShimmerView extends StatelessWidget {
  final int numberOfRow;
  final ShimmerViewType shimmerViewType;
  final bool isListView;
  final int numberOfTabLength;
  final bool isScrollable;

  const CommonShimmerView({
    Key? key,
    this.numberOfRow = 1,
    this.shimmerViewType = ShimmerViewType.DEFAULT_VIEW,
    this.isListView = true,
    this.numberOfTabLength = 3,
    this.isScrollable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: isListView
          ? ListView.builder(
              itemCount: numberOfRow,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics:
                  isScrollable ? null : const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor:
                      context.resources.color.themeColor.withOpacity(0.3),
                  highlightColor:
                      context.resources.color.themeColor.withOpacity(0.1),
                  child: (shimmerViewType == ShimmerViewType.DMSDashBoard1 &&
                          index == 0)
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            getContainerWidget(
                                context, 30, MediaQuery.of(context).size.width),
                            getContainerWidget(
                                context, 30, MediaQuery.of(context).size.width),
                            getContainerWidget(
                                context, 30, MediaQuery.of(context).size.width),
                            getContainerWidget(
                                context, 30, MediaQuery.of(context).size.width),
                            const SizedBox(
                              height: 50,
                            ),
                            const DoughnutContainer(
                              innerRadius: 150,
                              outerRadius: 200,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            getContainerWidget(
                                context, 30, MediaQuery.of(context).size.width),
                            getContainerWidget(
                                context, 30, MediaQuery.of(context).size.width),
                            const SizedBox(
                              height: 20,
                            ),
                            const HorizontalBarGraphWithAxes(
                              data: [30, 60, 80],
                              labels: ["Item 1", "Item 2", "Item 3"],
                              maxBarWidth: 300, // Maximum bar width in pixels
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        )
                      : (shimmerViewType == ShimmerViewType.DMSDashBoard2)
                          ? Column(
                              children: [
                                getContainerWidget(context, 30,
                                    MediaQuery.of(context).size.width),
                              ],
                            )
                          : (shimmerViewType == ShimmerViewType.TRN_PAGE &&
                                  index == 0)
                              ? Column(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            getContainerWidget(
                                                context,
                                                15,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2),
                                            getContainerWidget(
                                                context,
                                                15,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4)
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            getContainerWidget(
                                                context,
                                                15,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2),
                                            getContainerWidget(
                                                context,
                                                15,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4)
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          height: 0.5,
                                          color: Colors.grey,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            // Horizontal scroll
                                            itemCount: numberOfTabLength,
                                            // The number of items you want to display
                                            itemBuilder: (context, index) {
                                              return getContainerWidget(
                                                context,
                                                40,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4, // Adjust this as needed
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    )
                                  ],
                                )
                              : (shimmerViewType == ShimmerViewType.HOME_TAB &&
                                      index == 0)
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          top: 18, bottom: 30),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              getContainerWidget(
                                                  context, 50, 60),
                                              getContainerWidget(
                                                  context, 10, 50),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              getContainerWidget(
                                                  context, 50, 60),
                                              getContainerWidget(
                                                  context, 10, 50),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              getContainerWidget(
                                                  context, 50, 60),
                                              getContainerWidget(
                                                  context, 10, 50),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : getShimmerView(context, shimmerViewType),
                );
              },
            )
          : GridView.builder(
              padding: const EdgeInsets.all(4.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: numberOfRow,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor:
                      context.resources.color.themeColor.withOpacity(0.3),
                  highlightColor:
                      context.resources.color.themeColor.withOpacity(0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                        ),
                      ),
                      Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            top: 4.0, left: 15, right: 15),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget getShimmerView(BuildContext context, ShimmerViewType type) {
    switch (type) {
      case ShimmerViewType.HOME_PAGE:
        return getHomePageWidget(context);
      case (ShimmerViewType.HOME_TAB):
        return getHomePageWidget(context);
      case ShimmerViewType.COMMON_LIST:
        return Container(
          margin: EdgeInsets.only(top: 8),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: getContainerWidget(
                          context, 8, MediaQuery.of(context).size.width / 4)),
                  Expanded(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.topRight,
                          child: getContainerWidget(context, 8,
                              MediaQuery.of(context).size.width / 4))),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              getContainerWidget(
                  context, 5, MediaQuery.of(context).size.width / 4),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: getContainerWidget(
                          context, 8, MediaQuery.of(context).size.width / 4)),
                  Expanded(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.topRight,
                          child: getContainerWidget(context, 8,
                              MediaQuery.of(context).size.width / 4))),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 0.5,
                color: Colors.grey,
              )
            ],
          ),
        );
      case (ShimmerViewType.COMMON_SEARCH):
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            getContainerWidget(
                context, 14, MediaQuery.of(context).size.width / 4),
            getContainerWidget(context, 6, MediaQuery.of(context).size.width),
            getContainerWidget(
                context, 6, MediaQuery.of(context).size.width / 2),
            Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 10.0),
              color: Colors.grey,
            )
          ],
        );
      case (ShimmerViewType.TRN_PAGE):
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: getContainerWidget(
                        context, 15, MediaQuery.of(context).size.width)),
                Expanded(
                    flex: 3,
                    child: getContainerWidget(
                        context, 25, MediaQuery.of(context).size.width)),
              ],
            ),
            SizedBox(
              height: 5,
            )
          ],
        );
      case (ShimmerViewType.SIDE_MENU):
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5, left: 4),
                  height: 20,
                  width: 20,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Expanded(
                    flex: 2,
                    child: getContainerWidget(
                        context, 20, MediaQuery.of(context).size.width)),
                Container(
                  margin: EdgeInsets.only(top: 5, right: 4),
                  height: 20,
                  width: 20,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              height: 0.5,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
            ),
            // SizedBox(
            //   height: 5,
            // )
          ],
        );
      case (ShimmerViewType.SIDE_MENU):
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5, left: 4),
                  height: 20,
                  width: 20,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Expanded(
                    flex: 2,
                    child: getContainerWidget(
                        context, 20, MediaQuery.of(context).size.width)),
                Container(
                  margin: EdgeInsets.only(top: 5, right: 4),
                  height: 20,
                  width: 20,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              height: 0.5,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
            ),
            // SizedBox(
            //   height: 5,
            // )
          ],
        );
      default:
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.black.withOpacity(0.1),
              width: 0.9, // Border width
            ),
            color: Colors.grey.withOpacity(0.5),
          ),
          height: 30,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(right: 10, left: 10, top: 15.0),
        );
    }
  }

  Widget getHomePageWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: AppHeight(34),
                  width: AppWidth(34),
                  margin:
                      EdgeInsets.only(right: AppWidth(8), left: AppWidth(8)),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.5)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 8,
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      height: 5,
                      width: MediaQuery.of(context).size.width / 4,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ],
                ),
              ],
            )),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 8,
                  width: MediaQuery.of(context).size.width / 4,
                  margin: EdgeInsets.only(right: 5, bottom: 3.0),
                  color: Colors.grey.withOpacity(0.5),
                ),
                Row(
                  children: [
                    Container(
                      height: 15,
                      width: 15,
                      margin: EdgeInsets.only(right: 5),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    Container(
                      height: 8,
                      width: MediaQuery.of(context).size.width / 6,
                      margin: EdgeInsets.only(right: 5),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Container(
          height: 5,
          margin: EdgeInsets.only(right: 10, left: 10, top: 4.0, bottom: 4.0),
          color: Colors.grey.withOpacity(0.5),
        ),
        Container(
          height: 5,
          width: MediaQuery.of(context).size.width / 2,
          margin: EdgeInsets.only(right: 10, left: 10),
          color: Colors.grey.withOpacity(0.5),
        ),
        Container(
          height: 0.5,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 10, bottom: 10),
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget getContainerWidget(BuildContext context, double height, double width) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.only(right: 10, left: 10, top: 5.0),
      color: Colors.grey.withOpacity(0.5),
    );
  }
}

enum ShimmerViewType {
  HOME_TAB,
  HOME_PAGE,
  COMMON_LIST,
  COMMON_SEARCH,
  TRN_PAGE,
  SIDE_MENU,
  DEFAULT_VIEW,
  DMSDashBoard1,
  DMSDashBoard2
}

class DoughnutContainer extends StatelessWidget {
  final double outerRadius;
  final double innerRadius;

  const DoughnutContainer({
    super.key,
    required this.outerRadius,
    required this.innerRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: outerRadius,
        height: outerRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors
              .transparent, // Inner part color (transparent in the middle)
          border: Border.all(
            width: (outerRadius - innerRadius) /
                2, // Border thickness (to mimic doughnut)
          ),
        ),
      ),
    );
  }
}

class HorizontalBarGraphWithAxes extends StatelessWidget {
  final List<double> data; // List of values for the bars
  final double barHeight;
  final double maxBarWidth; // Maximum width of the bar graph
  final List<String> labels; // Labels for the y-axis (for each bar)

  const HorizontalBarGraphWithAxes({
    super.key,
    required this.data,
    required this.labels,
    this.barHeight = 20,
    required this.maxBarWidth,
  });

  @override
  Widget build(BuildContext context) {
    double maxValue = data.reduce(
        (a, b) => a > b ? a : b); // Find the max value to normalize the bars

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bars and Y-Axis
          Row(
            children: [
              // Y-Axis labels
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: labels.map((label) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        height: barHeight,
                        child: Text(label, style: TextStyle(fontSize: 12)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Horizontal Bars
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.map((value) {
                    double barWidth =
                        (value / maxValue) * maxBarWidth; // Normalize bar width
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // Grey background bar (the full container)
                          Container(
                            width: maxBarWidth,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: Colors.grey[
                                  300], // Grey background for the entire bar
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          // Colored bar to show the actual value
                          Container(
                            width: barWidth,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: Colors.blue, // Color of the bar
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          // X-Axis (top labels)
          Padding(
            padding: const EdgeInsets.only(left: 40.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("0"),
                Text("${(maxValue / 2).round()}"),
                Text(maxValue.toStringAsFixed(0)), // Max value as label
              ],
            ),
          ),
        ],
      ),
    );
  }
}
