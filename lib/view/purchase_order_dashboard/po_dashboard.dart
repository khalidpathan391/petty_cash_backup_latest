// ignore_for_file: unused_local_variable, depend_on_referenced_packages, unused_element, unnecessary_string_interpolations

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/petty_cash_dashboard/grn_analysis_model.dart';
import 'package:petty_cash/data/models/petty_cash_dashboard/pettycash_analysis.dart';
import 'package:petty_cash/data/models/petty_cash_dashboard/pr_analysis_model.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view_model/purchase_order_dashnboard/po_dashboard_vm.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  static String id = 'po_dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  double dW = 0.0;
  double dH = 0.0;

  @override
  Widget build(BuildContext context) {
    Color themeColor = context.resources.color.themeColor;
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (_) => PoDashboardVm()..initDefaultVal(context),
      child: Consumer<PoDashboardVm>(
        builder: (context, provider, child) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.pettyCashList.isEmpty
                      ? Center(
                          child: CommonTextView(
                            label: "No Data Found",
                            fontSize: context.resources.dimension.appBigText,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: dW * 0.01, vertical: dW * 0.005),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPettyCashCard(provider, themeColor),
                              SizedBox(height: dH * 0.005),
                              CommonTextView(
                                fontSize:
                                    context.resources.dimension.appMediumText +
                                        3,
                                overFlow: TextOverflow.ellipsis,
                                margin: const EdgeInsets.only(left: 6),
                                maxLine: 1,
                                label: "Status ",
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 0,
                                  child: Padding(
                                    padding: EdgeInsets.all(dW * 0.005),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 1.25,
                                            child: _buildPieChart(provider),
                                          ),
                                          SizedBox(height: dH * 0.06),

                                          /// Legends
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              _LegendItem(
                                                  color: Colors.blue,
                                                  text: "Limit"),
                                              _LegendItem(
                                                  color: Colors.orange,
                                                  text: "Balance"),
                                              _LegendItem(
                                                  color: Colors.green,
                                                  text: "Disbursement"),
                                            ],
                                          ),
                                          SizedBox(height: dH * 0.04),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CommonButton(
                                                width: dW / 2.5,
                                                height: 35,
                                                text: "PR Analysis",
                                                fontSize: context.resources
                                                    .dimension.appMediumText,
                                                onPressed: () {
                                                  _showPRAnalysisBottomSheet(
                                                      context, provider);
                                                },
                                                borderRadius: 8.0,
                                                disable: false,
                                                color: themeColor,
                                              ),
                                              CommonButton(
                                                width: dW / 2.5,
                                                height: 35,
                                                text: "GRN Analysis",
                                                fontSize: context.resources
                                                    .dimension.appMediumText,
                                                onPressed: () {
                                                  _showGRNAnalysisBottomSheet(
                                                      context,
                                                      provider.grnAnalysis
                                                              ?.grnList ??
                                                          []);
                                                },
                                                borderRadius: 8.0,
                                                disable: false,
                                                color: themeColor,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: dH * 0.03),
                                          Builder(
                                            builder: (context) {
                                              final selectedAccount = provider
                                                  .pettyCashAnalysis
                                                  ?.pettyCashAccounts
                                                  ?.firstWhere(
                                                (acc) =>
                                                    acc.pettyCashDescription ==
                                                    provider.selectedPettyCash,
                                                orElse: () =>
                                                    PettyCashAccounts(),
                                              );
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonTextView(
                                                    label:
                                                        "Petty Cash Account Analysis",
                                                    fontSize: dW * 0.045,
                                                    fontWeight: FontWeight.bold,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 8),
                                                  ),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: DataTable(
                                                      columns: const [
                                                        DataColumn(
                                                            label: SizedBox()),
                                                        DataColumn(
                                                            label: SizedBox()),
                                                      ],
                                                      rows: [
                                                        DataRow(cells: [
                                                          const DataCell(Text(
                                                              "Petty Cash Code - Description")),
                                                          DataCell(Text(
                                                            (selectedAccount?.pettyCashCode ??
                                                                            '') !=
                                                                        '' &&
                                                                    (selectedAccount?.pettyCashDescription ??
                                                                            '') !=
                                                                        ''
                                                                ? "${selectedAccount?.pettyCashCode} - ${selectedAccount?.pettyCashDescription}"
                                                                : "No Value Found",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                        ]),
                                                        DataRow(cells: [
                                                          const DataCell(Text(
                                                              "Petty Cash Limit")),
                                                          DataCell(Text(
                                                            (selectedAccount?.pettyCashLimit ??
                                                                        '') !=
                                                                    ''
                                                                ? selectedAccount!
                                                                    .pettyCashLimit!
                                                                : "No Value Found",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                          )),
                                                        ]),
                                                        DataRow(cells: [
                                                          const DataCell(Text(
                                                              "Disbursement Limit")),
                                                          DataCell(Text(
                                                            (selectedAccount?.disbursementLimit ??
                                                                        '') !=
                                                                    ''
                                                                ? selectedAccount!
                                                                    .disbursementLimit!
                                                                : "No Value Found",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .green),
                                                          )),
                                                        ]),
                                                        DataRow(cells: [
                                                          const DataCell(Text(
                                                              "Petty Cash Balance")),
                                                          DataCell(Text(
                                                            (selectedAccount?.pettyCashBalance ??
                                                                        '') !=
                                                                    ''
                                                                ? selectedAccount!
                                                                    .pettyCashBalance!
                                                                : "No Value Found",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .orange),
                                                          )),
                                                        ]),
                                                        DataRow(cells: [
                                                          const DataCell(Text(
                                                              "Effective Start Date")),
                                                          DataCell(Text(
                                                            (selectedAccount?.effectiveStartDate ??
                                                                        '') !=
                                                                    ''
                                                                ? selectedAccount!
                                                                    .effectiveStartDate!
                                                                : "No Value Found",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .purple),
                                                          )),
                                                        ]),
                                                        DataRow(cells: [
                                                          const DataCell(Text(
                                                              "Effective End Date")),
                                                          DataCell(Text(
                                                            (selectedAccount?.effectiveEndDate ??
                                                                        '') !=
                                                                    ''
                                                                ? selectedAccount!
                                                                    .effectiveEndDate!
                                                                : "No Value Found",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .brown),
                                                          )),
                                                        ]),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPettyCashCard(PoDashboardVm provider, Color themeColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Row(
        children: [
          Expanded(
            child: CommonTextView(
              fontSize: context.resources.dimension.appBigText + 4,
              fontWeight: FontWeight.bold,
              overFlow: TextOverflow.ellipsis,
              maxLine: 1,
              label: provider.selectedPettyCash?.isNotEmpty == true
                  ? provider.selectedPettyCash!
                  : "No Petty Cash Selected",
            ),
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: themeColor, size: dW * 0.06),
            tooltip: "View Petty Cash Info",
            onPressed: () => _showPettyCashInfo(context, provider),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.swap_horiz, size: dW * 0.06, color: themeColor),
            tooltip: "Change Petty Cash",
            onSelected: provider.setSelectedPettyCash,
            itemBuilder: (ctx) => provider.pettyCashList
                .map(
                  (item) => PopupMenuItem<String>(
                    value: item,
                    child: CommonTextView(
                      label: item,
                      fontSize: dW * 0.04,
                      overFlow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  void _showPettyCashInfo(BuildContext context, PoDashboardVm provider) {
    final selectedAccount =
        provider.pettyCashAnalysis?.pettyCashAccounts?.firstWhere(
      (acc) => acc.pettyCashDescription == provider.selectedPettyCash,
      orElse: () => PettyCashAccounts(),
    );

    if (selectedAccount?.info == null) {
      AppUtils.showToastRedBg(context, "No info available for this petty cash");
      return;
    }

    final info = selectedAccount!.info!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => Navigator.pop(ctx)),
                      CommonTextView(
                          label: "Petty Cash Info",
                          fontSize: dW * 0.05,
                          fontWeight: FontWeight.bold),
                      const SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: dH * 0.01),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text("Description")),
                      DataColumn(label: Text("Value"))
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text("Total POs Created")),
                        DataCell(Text("${info.totalPoCount ?? '-'}"))
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Total PO Value")),
                        DataCell(Text("${info.totalPoValue ?? '-'}"))
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Approved & Posted GRNs")),
                        DataCell(
                            Text("${info.approvedPostedGrns?.count ?? '-'}"))
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Total Value (Approved)")),
                        DataCell(Text(
                            "${info.approvedPostedGrns?.totalValue ?? '-'}"))
                      ]),
                    ],
                  ),
                  SizedBox(height: dH * 0.03),
                  CommonTextView(
                      label: "Pending Disbursement GRNs",
                      fontSize: dW * 0.045,
                      fontWeight: FontWeight.bold),
                  SizedBox(height: dH * 0.03),
                  info.pendingGrns?.isNotEmpty == true
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(
                                  label: CommonTextView(label: "GRN No")),
                              DataColumn(
                                  label: CommonTextView(label: "GRN Date")),
                              DataColumn(label: CommonTextView(label: "Value")),
                            ],
                            rows: info.pendingGrns!
                                .map((grn) => DataRow(cells: [
                                      DataCell(Text(grn.grnNo ?? '-')),
                                      DataCell(Text(grn.grnDate ?? '-')),
                                      DataCell(Text(grn.value ?? '-')),
                                    ]))
                                .toList(),
                          ),
                        )
                      : const CommonTextView(label: "No pending GRNs"),
                  SizedBox(height: dH * 0.03),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPRAnalysisBottomSheet(
      BuildContext context, PoDashboardVm provider) {
    final prHeads = provider.prAnalysis?.prHeadList ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(dW * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                      CommonTextView(
                        label: "PR Analysis",
                        fontSize: dW * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: dH * 0.02),
                  prHeads.isEmpty
                      ? const CommonTextView(
                          label: "No assigned/un-consumed PRs")
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text("PR Date")),
                              DataColumn(label: Text("PR No.")),
                              DataColumn(label: Text("Charge Type")),
                              DataColumn(label: Text("Store Location")),
                              DataColumn(label: Text("Need By Date")),
                              DataColumn(label: Text("Remarks")),
                              DataColumn(label: Text("Info")),
                            ],
                            rows: prHeads
                                .map(
                                  (prHead) => DataRow(cells: [
                                    DataCell(Text(prHead.prDocDate ?? '-')),
                                    DataCell(Text(prHead.prDocNo ?? '-')),
                                    DataCell(Text(
                                      '${prHead.prChargeToCode ?? '-'} - ${prHead.prChargeToDesc ?? '-'}',
                                    )),
                                    DataCell(Text(
                                      '${prHead.prStoreLocCode ?? '-'} - ${prHead.prStoreLocDesc ?? '-'}',
                                    )),
                                    DataCell(Text(prHead.prNeedByDate ?? '-')),
                                    DataCell(Text(prHead.prRemarks ?? '-')),
                                    DataCell(IconButton(
                                      icon: const Icon(Icons.info_outline),
                                      color: context.resources.color.themeColor,
                                      onPressed: () {
                                        // Filter items for this PR header
                                        final prItemsForThisPR = provider
                                                .prAnalysis?.prItemList
                                                ?.where((item) =>
                                                    item.prHeaderId ==
                                                    prHead.prHeaderId)
                                                .toList() ??
                                            [];
                                        _showPRItemDetails(
                                            ctx, prItemsForThisPR);
                                      },
                                    )),
                                  ]),
                                )
                                .toList(),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPRItemDetails(BuildContext context, List<PrItemList> items) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(dW * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => Navigator.pop(ctx)),
                      CommonTextView(
                          label: "PR Item Details",
                          fontSize: dW * 0.05,
                          fontWeight: FontWeight.bold),
                      const SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: dH * 0.02),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Item Code")),
                        DataColumn(label: Text("Description")),
                        DataColumn(label: Text("UOM")),
                        DataColumn(label: Text("Qty")),
                        DataColumn(label: Text("PR Assigned Date")),
                        DataColumn(label: Text("Manufacturer")),
                        DataColumn(label: Text("Supplier")),
                        DataColumn(label: Text("Note to Buyer")),
                      ],
                      rows: items
                          .map(
                            (detail) => DataRow(cells: [
                              DataCell(Text(detail.priItemCode ?? '-')),
                              DataCell(Text(detail.priItemDesc ?? '-')),
                              DataCell(Text(
                                  detail.priUomCode ?? '-')), // or priUomDesc
                              DataCell(Text(detail.priItemQty ?? '-')),
                              DataCell(Text(detail.priAssignedDate ?? '-')),
                              DataCell(Text(
                                detail.priMnfrPopup != null &&
                                        detail.priMnfrPopup!.isNotEmpty
                                    ? detail.priMnfrPopup!
                                        .map((e) => e.mnfrCodeDesc)
                                        .join(", ")
                                    : '-',
                              )),
                              DataCell(Text(
                                detail.priSupplierPopup != null &&
                                        detail.priSupplierPopup!.isNotEmpty
                                    ? detail.priSupplierPopup!
                                        .map((e) => e.suppCodeName)
                                        .join(", ")
                                    : '-',
                              )),
                              DataCell(Text(detail.priNoteToBuyer ?? '-')),
                            ]),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showGRNAnalysisBottomSheet(
      BuildContext context, List<GrnList> grnList) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(dW * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => Navigator.pop(ctx)),
                      CommonTextView(
                          label: "GRN Analysis",
                          fontSize: dW * 0.05,
                          fontWeight: FontWeight.bold),
                      const SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: dH * 0.02),
                  grnList.isEmpty
                      ? const CommonTextView(label: "No un-approved GRNs")
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text("Doc Date")),
                              DataColumn(label: Text("GRN No.")),
                              DataColumn(label: Text("Ref PO No.")),
                              DataColumn(label: Text("Receiving Loc.")),
                              DataColumn(label: Text("Petty Cash No.")),
                              DataColumn(label: Text("Pending With")),
                              DataColumn(label: Text("Pending Since")),
                              DataColumn(label: Text("Info")),
                            ],
                            rows: grnList
                                .map(
                                  (grn) => DataRow(cells: [
                                    DataCell(Text(grn.grnDocDate ?? '-')),
                                    DataCell(Text(grn.grnDocNo ?? '-')),
                                    DataCell(Text(grn.grnRefPoDocNo ?? '-')),
                                    DataCell(Text(grn.grnReceivingLoc ?? '-')),
                                    DataCell(Text(grn.grnPettyCashNo ?? '-')),
                                    DataCell(Text(grn.pendingWith ?? '-')),
                                    DataCell(Text(grn.pendingSince ?? '-')),
                                    DataCell(IconButton(
                                      icon: const Icon(Icons.info_outline),
                                      color: context.resources.color.themeColor,
                                      onPressed: () {
                                        _showGRNItemDetails(
                                            ctx, grn.items ?? []);
                                      },
                                    )),
                                  ]),
                                )
                                .toList(),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showGRNItemDetails(BuildContext context, List<GrnItem> items) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(dW * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => Navigator.pop(ctx)),
                      CommonTextView(
                          label: "GRN Item Details",
                          fontSize: dW * 0.05,
                          fontWeight: FontWeight.bold),
                      const SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: dH * 0.02),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Item Code")),
                        DataColumn(label: Text("Description")),
                        DataColumn(label: Text("UOM")),
                        DataColumn(label: Text("Received Qty")),
                      ],
                      rows: items
                          .map(
                            (item) => DataRow(cells: [
                              DataCell(Text(item.grnItemCode ?? '-')),
                              DataCell(Text(item.grnItemDesc ?? '-')),
                              DataCell(Text(
                                  item.grnUomCode ?? '-')), // or grnUomDesc
                              DataCell(Text(item.receivedQty ?? '-')),
                            ]),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPieChart(PoDashboardVm provider) {
    final selectedAccount =
        provider.pettyCashAnalysis?.pettyCashAccounts?.firstWhere(
      (acc) => acc.pettyCashDescription == provider.selectedPettyCash,
      orElse: () => PettyCashAccounts(),
    );

    if (selectedAccount == null ||
        selectedAccount.pettyCashLimit == null ||
        selectedAccount.pettyCashBalance == null ||
        selectedAccount.disbursementLimit == null) {
      return Center(
          child: CommonTextView(
              label: "No chart data available", fontSize: dW * 0.04));
    }

    final double limit =
        double.tryParse(selectedAccount.pettyCashLimit ?? '') ?? 0;
    final double balance =
        double.tryParse(selectedAccount.pettyCashBalance ?? '') ?? 0;
    final double disbursement =
        double.tryParse(selectedAccount.disbursementLimit ?? '') ?? 0;

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
              value: limit,
              title: limit.toStringAsFixed(0),
              color: Colors.blue,
              radius: 80,
              titleStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          PieChartSectionData(
              value: balance,
              title: balance.toStringAsFixed(0),
              color: Colors.orange,
              radius: 80,
              titleStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          PieChartSectionData(
              value: disbursement,
              title: disbursement.toStringAsFixed(0),
              color: Colors.green,
              radius: 80,
              titleStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    double dW = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),
        SizedBox(width: dW * 0.015),
        CommonTextView(label: text, fontSize: dW * 0.035),
      ],
    );
  }
}
