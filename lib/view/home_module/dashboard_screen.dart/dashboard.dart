// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/home_module/dashboard_screen.dart/search_screen.dart';

import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view_model/home_module_vm/dashboard_vm.dart';

import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<DashboardVm>(context, listen: false).onSubmit(context);
    });
  }

  double dW = 0.0;
  double dH = 0.0;
  double tS = 0.0;

  @override
  Widget build(BuildContext context) {
    Color themeColor = context.resources.color.themeColor;
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;
    tS = dW * 0.045;

    final viewModel = DashboardVm();
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<DashboardVm>(
        builder: (context, provider, child) {
          return SafeArea(
              child: Scaffold(
            backgroundColor: const Color(0xFF121212),
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: dW * 0.01,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.grey[900],
                              value: provider.selectedFilter,
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.white),
                              style: const TextStyle(color: Colors.white),
                              items: provider.filterOptions
                                  .map((label) => DropdownMenuItem<String>(
                                        value: label,
                                        child: Text(label),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  provider.updateFilter(value);
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SearchScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: dH * 0.03),
                      Center(
                        child: SizedBox(
                          width: dW,
                          child: PieChart(
                            dataMap: provider.dataMap,
                            animationDuration:
                                const Duration(milliseconds: 800),
                            chartLegendSpacing: 32,
                            chartRadius: dW * 0.7,
                            colorList: provider.colorList,
                            initialAngleInDegree: 0,
                            chartType: ChartType.disc,
                            ringStrokeWidth: 32,
                            legendOptions: const LegendOptions(
                              showLegendsInRow: false,
                              legendPosition: LegendPosition.right,
                              showLegends: true,
                              legendTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              chartValueStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // Positioned Bottom Container
                Positioned(
                  top: dH * 0.42,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: dW * 0.06, vertical: dH * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // GridView
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: provider.statusCards.length,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 1.3,
                          ),
                          itemBuilder: (context, index) {
                            final item = provider.statusCards[index];
                            return GestureDetector(
                              onTap: () {
                                // Handle tap event
                                Navigator.pushNamed(context, 'list_screen',
                                    arguments: item.title);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: dW * 0.03, vertical: dH * 0.01),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      item.bgColor,
                                      Colors.white.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: item.bgColor.withOpacity(0.8),
                                      blurRadius: 1,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(item.icon,
                                        size: dW * 0.09, color: Colors.black),
                                    const Spacer(),
                                    CommonTextView(
                                      label: item.title,
                                      fontSize: tS * 0.9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    CommonTextView(
                                      label: item.taskCount,
                                      fontSize: tS * 0.8,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, 'add_lead');
              },
              backgroundColor: Colors.blue.shade700,
              child: const Icon(
                Icons.add,
              ),
            ),
          ));
        },
      ),
    );
  }

  // Widget _buildTaskCard({
  //   required BuildContext context,
  //   required String status,
  //   required String title,
  //   required String time,
  //   required Color color,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF1E1E1E),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: Colors.grey.shade800),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: dW * 0.015,
  //           height: dH * 0.13,
  //           decoration: BoxDecoration(
  //             color: color,
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(12),
  //               bottomLeft: Radius.circular(12),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: Padding(
  //             padding: EdgeInsets.all(dW * 0.04),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Container(
  //                       padding: EdgeInsets.symmetric(
  //                           horizontal: dW * 0.02, vertical: dH * 0.005),
  //                       decoration: BoxDecoration(
  //                         color: color.withOpacity(0.2),
  //                         borderRadius: BorderRadius.circular(4),
  //                       ),
  //                       child: Text(
  //                         status,
  //                         style: TextStyle(
  //                           color: color,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: dW * 0.03,
  //                         ),
  //                       ),
  //                     ),
  //                     const Spacer(),
  //                     Icon(Icons.more_vert,
  //                         color: Colors.grey, size: dW * 0.045),
  //                   ],
  //                 ),
  //                 SizedBox(height: dH * 0.01),
  //                 Text(
  //                   title,
  //                   style: TextStyle(
  //                     fontSize: dW * 0.04,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 SizedBox(height: dH * 0.005),
  //                 Text(
  //                   time,
  //                   style: TextStyle(
  //                     color: Colors.grey[600],
  //                     fontSize: dW * 0.03,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
