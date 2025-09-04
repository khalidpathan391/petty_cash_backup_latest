// ignore_for_file: avoid_print, unused_element, use_build_context_synchronously, unused_local_variable, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/po_model.dart/get_reefernce_pr.dart';
import 'package:petty_cash/globalSize.dart';

// import 'package:easy_localization/easy_localization.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/base/BaseGestureTouchSafeArea.dart';
import 'package:petty_cash/view/common/transaction_common/common_header_transactions.dart';
import 'package:petty_cash/view/common_annotated_region.dart';

import 'package:petty_cash/view/widget/CustomAppBar.dart';
import 'package:petty_cash/view/widget/common_button.dart';

import 'package:petty_cash/view/widget/common_shimmer_view.dart';
import 'package:petty_cash/view/widget/common_text.dart';

import 'package:petty_cash/view/widget/erp_text_field.dart';
import 'package:petty_cash/view/widget/custom_view_table.dart';
import 'package:petty_cash/view/widget/common_empty_list copy.dart';
import 'package:petty_cash/view/widget/quill_text_field.dart';
import 'package:petty_cash/view_model/purchase_order/purchase_order_vm.dart';

import 'package:provider/provider.dart';

class PoTransaction extends StatefulWidget {
  static String id = 'po_transaction';
  const PoTransaction({super.key});

  @override
  State<PoTransaction> createState() => _PoTransactionState();
}

class _PoTransactionState extends State<PoTransaction>
    with TickerProviderStateMixin {
  late PoApplicationVm provider;
  late TabController _tabController;

  int headerId = -1;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<PoApplicationVm>(context, listen: false);
    provider.submitRemarksCtrl.text = '';
    _tabController =
        TabController(length: provider.tabHeaders.length, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;

    headerId = ModalRoute.of(context)?.settings.arguments as int? ?? -1;

    // Call API safely after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.callPoView(headerId).then((_) {
        // Update TabController safely after data is loaded
        if (mounted) {
          _tabController.dispose();
          _tabController =
              TabController(length: provider.tabHeaders.length, vsync: this);
          setState(() {}); // rebuild TabBar with updated tabs
        }
      });
    });

    _isInitialized = true;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double dW = 0.0;

  double dH = 0.0;

  double tS = 0.0;
  @override
  Widget build(BuildContext context) {
    Color themeColor = context.resources.color.themeColor;

    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;
    tS = dW * 0.035; // Decreased text size multiplier

    provider = Provider.of<PoApplicationVm>(context);

    return CommonAnnotatedRegion(
      child: BaseGestureTouchSafeArea(
        child: Consumer<PoApplicationVm>(
          builder: (context, provider, widget) {
            return PopScope(
              canPop: true,
              onPopInvoked: (val) {
                provider.setDefault();
                _tabController.dispose();
                _tabController = TabController(
                    length: provider.tabHeaders.length,
                    vsync: this,
                    initialIndex: 0);
                if (val) return;
              },
              child: Scaffold(
                appBar: CustomAppBar(
                  type: 'Purchase Order',
                  typeIcon: '',
                  isTransaction: true,
                  isList: false,
                  isAdd: false,
                  isSave: provider.isApproved
                      ? false
                      : (provider.isSubmit ? false : true),
                  isSubmit: provider.isApproved
                      ? false
                      : (provider.isSubmit ? false : true),
                  isTransactionBack: true,
                  save: () {
                    print("function is called");
                  },
                  submitOrApproval: () {
                    AppUtils.showSubmit(
                      context,
                      controller: provider.submitRemarksCtrl,
                      onChange: (val) {},
                      onSubmit: (file) {
                        if (provider.myHeaderId != -1) {
                          if (provider.submitRemarksCtrl.text.isNotEmpty) {
                          } else {
                            AppUtils.showToastRedBg(
                                context, "Comment can not be empty");
                          }
                        } else {
                          AppUtils.showToastRedBg(context,
                              " You Can Submit After Save Please Save the Transaction");
                        }
                      },
                    );
                  },
                ),
                body: provider.isLoading
                    ? const CommonShimmerView(
                        numberOfRow: 20,
                        shimmerViewType: ShimmerViewType.TRN_PAGE,
                      )
                    : AppUtils.errorMessage.isNotEmpty
                        ? AppUtils(context).getCommonErrorWidget(() {}, '')
                        : Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    right: dW * 0.025,
                                    left: dW * 0.04,
                                    top: dH * 0.02),
                                child: _HeaderSummary(),
                              ),
                              TabBar(
                                controller: _tabController,
                                tabs: List.generate(provider.tabHeaders.length,
                                    (index) {
                                  return Tab(
                                    child: CommonTextView(
                                      label: provider.tabHeaders[index],
                                      fontSize: tS * 1.2,
                                      color: themeColor,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: dW * 0.025),
                                    ),
                                  );
                                }),
                                indicatorColor: themeColor,
                                labelColor: themeColor,
                                unselectedLabelColor:
                                    themeColor.withOpacity(0.5),
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: tS * 0.6), // Decreased text size
                                unselectedLabelStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: tS * 0.5), // Decreased text size
                                indicatorPadding: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(0),
                                tabAlignment: TabAlignment.start,
                                indicator: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: themeColor,
                                      width: dW * 0.005,
                                    ),
                                  ),
                                ),
                                overlayColor:
                                    MaterialStateColor.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return themeColor.withOpacity(.2);
                                  }
                                  return Colors.white;
                                }),
                                isScrollable: true,
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    _HeaderTab(),
                                    _ItemDetailsTab(),
                                  ],
                                ),
                              ),
                            ],
                          ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeaderTab extends StatefulWidget {
  @override
  State<_HeaderTab> createState() => _HeaderTabState();
}

class _HeaderTabState extends State<_HeaderTab> {
  late quill.QuillController _remarkQuillCtrl;

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PoApplicationVm>(context, listen: false);
    _remarkQuillCtrl = quill.QuillController.basic();

    if (vm.remarkCtrl.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _remarkQuillCtrl.document.insert(0, vm.remarkCtrl.text);
      });
    }

    _remarkQuillCtrl.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.remarkCtrl.text = _remarkQuillCtrl.document.toPlainText().trim();
      });
    });
  }

  double dW = 0.0;

  double dH = 0.0;

  double tS = 0.0;

  /// --- Show Reference PR Bottom Sheet ---
  void _showReferencePRSheet() async {
    Color themeColor = context.resources.color.themeColor;
    final vm = Provider.of<PoApplicationVm>(context, listen: false);

    // Fetch PR list from API
    await vm.fetchReferencePR();

    Map<int, bool> selectedItems = {};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return DraggableScrollableSheet(
              expand: false,
              maxChildSize: 0.9,
              initialChildSize: 0.6,
              minChildSize: 0.3,
              builder: (context, scrollController) {
                final prList = vm.referencePRModel.referencePR ?? [];

                if (vm.isReferenceLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (prList.isEmpty) {
                  return const Center(child: Text('No Reference PR Found'));
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: prList.length,
                        itemBuilder: (context, index) {
                          final pr = prList[index];
                          final hasInfo =
                              (pr.priMnfrPopup?.isNotEmpty ?? false) ||
                                  (pr.priSupplierPopup?.isNotEmpty ?? false);

                          return Card(
                              margin: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.008,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.02,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.03),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: selectedItems[pr.srNo] ?? false,
                                      onChanged: (val) {
                                        setStateBottomSheet(() {
                                          selectedItems[pr.srNo!] =
                                              val ?? false;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonTextView(
                                            label:
                                                '${pr.priItemCode ?? '-'} - ${pr.priItemDesc ?? '-'}',
                                            fontSize: context.resources
                                                .dimension.appMediumText,
                                          ),
                                          const SizedBox(height: 4),
                                          CommonTextView(
                                            label:
                                                'Qty: ${pr.priItemQty ?? '-'}',
                                            fontSize: context.resources
                                                    .dimension.appMediumText -
                                                2,
                                            color: Colors.grey[700],
                                          ),
                                          const SizedBox(height: 4),
                                          CommonTextView(
                                            label:
                                                'Note to Buyer: ${pr.priNoteToBuyer ?? '-'}',
                                            fontSize: context.resources
                                                    .dimension.appMediumText -
                                                2,
                                            color: Colors.grey[700],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (hasInfo)
                                      IconButton(
                                        icon: const Icon(Icons.info_outline),
                                        onPressed: () {
                                          _showManufacturerSupplierSheet(pr);
                                        },
                                      ),
                                  ],
                                ),
                              ));
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final selectedPRs = prList
                                .where((pr) => selectedItems[pr.srNo] ?? false)
                                .toList();
                            // Call your Add PO function here
                            print(
                                "Selected PRs: ${selectedPRs.map((e) => e.prDocNo).toList()}");
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: CommonButton(
                              width: dW / 3,
                              height: 35,
                              text: "Add PO",
                              fontSize:
                                  context.resources.dimension.appMediumText,
                              onPressed: () {
                                // Api will call here
                              },
                              borderRadius: 8.0,
                              disable: false,
                              color: context.resources.color.themeColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  /// --- Manufacturer/Supplier Bottom Sheet ---
  void _showManufacturerSupplierSheet(ReferencePR pr) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.25, // half of screen height
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Manufacturer Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextView(
                      label: "Manufacturer",
                      fontWeight: FontWeight.bold,
                      fontSize: context.resources.dimension.appMediumText,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: pr.priMnfrPopup?.length ?? 0,
                        itemBuilder: (context, index) {
                          final mnfr = pr.priMnfrPopup![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextView(
                                  label:
                                      'Manufacturer ID: ${mnfr.mnfrCodeId ?? '-'}',
                                  fontSize:
                                      context.resources.dimension.appMediumText,
                                ),
                                const SizedBox(height: 4),
                                CommonTextView(
                                  label:
                                      'Manufacturer Name: ${mnfr.mnfrCodeDesc ?? '-'}',
                                  fontSize:
                                      context.resources.dimension.appMediumText,
                                ),
                                const SizedBox(height: 4),
                                CommonTextView(
                                  label:
                                      'Country Code: ${mnfr.mnfrCountryCode ?? '-'}',
                                  fontSize:
                                      context.resources.dimension.appMediumText,
                                ),
                                const SizedBox(height: 4),
                                CommonTextView(
                                  label:
                                      'Country Desc: ${mnfr.mnfrCountryDesc ?? '-'}',
                                  fontSize:
                                      context.resources.dimension.appMediumText,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Supplier Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextView(
                      label: "Supplier",
                      fontWeight: FontWeight.bold,
                      fontSize: context.resources.dimension.appMediumText,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: pr.priSupplierPopup?.length ?? 0,
                        itemBuilder: (context, index) {
                          final supp = pr.priSupplierPopup![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextView(
                                  label:
                                      'Supplier ID: ${supp.suppCodeId ?? '-'}',
                                  fontSize:
                                      context.resources.dimension.appMediumText,
                                ),
                                const SizedBox(height: 4),
                                CommonTextView(
                                  label:
                                      'Supplier Code: ${supp.suppCodeCode ?? '-'}',
                                  fontSize:
                                      context.resources.dimension.appMediumText,
                                ),
                                const SizedBox(height: 4),
                                CommonTextView(
                                  label:
                                      'Supplier Name: ${supp.suppCodeName ?? '-'}',
                                  fontSize:
                                      context.resources.dimension.appMediumText,
                                ),
                              ],
                            ),
                          );
                        },
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

  /// --- Create Supplier Bottom Sheet ---
  void _showCreateSupplierSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        final dW = MediaQuery.of(context).size.width;
        final vm = Provider.of<PoApplicationVm>(context, listen: false);

        Widget labelWithField({required String label, required Widget field}) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CommonTextView(
                    label: label,
                    fontSize: 14,
                    maxLine: 1,
                    overFlow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(flex: 7, child: field),
              ],
            ),
          );
        }

        Widget combinedSearchField({
          required String label,
          required TextEditingController code,
          required TextEditingController desc,
          bool showSearch = true,
        }) {
          final controller = TextEditingController(
              text: code.text.isNotEmpty
                  ? (desc.text.isNotEmpty
                      ? '${code.text} - ${desc.text}'
                      : code.text)
                  : desc.text);
          void handleTap() {
            if (label == 'Reference*') {
              Provider.of<PoApplicationVm>(context, listen: false)
                  .searchReference(context);
            } else {
              Provider.of<PoApplicationVm>(context, listen: false)
                  .searchField(context, label);
            }
          }

          return labelWithField(
              label: label,
              field: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: showSearch ? handleTap : null,
                child: AbsorbPointer(
                  absorbing: true,
                  child: CommonTextFormField(
                    label: label,
                    controller: controller,
                    enabled: false,
                    height: 36,
                    hintFontSize: 12,
                    suffixWidget: showSearch
                        ? const Icon(
                            Icons.search,
                            size:
                                12, // Decrease the size of the search icon here
                          )
                        : null,
                  ),
                ),
              ));
        }

        return Padding(
          padding: EdgeInsets.only(
            left: dW * 0.03,
            right: dW * 0.03,
            top: dW * 0.03,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Supplier Header
                const CommonTextView(
                  label: "Supplier",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                const SizedBox(height: 8),

                // Header info
                const CommonTextView(
                  label: "Header: XYZ Header",
                  fontSize: 14,
                ),
                const SizedBox(height: 16),

                // Fields using combinedSearchField style
                combinedSearchField(
                  label: 'Supplier Code*',
                  code: vm.supplierCode,
                  desc: TextEditingController(),
                  showSearch: false,
                ),
                combinedSearchField(
                  label: 'Supplier Code*',
                  code: TextEditingController(),
                  desc: vm.supplierDesc,
                  showSearch: false,
                ),
                combinedSearchField(
                  label: 'Supplier Type',
                  code: vm.supplierType,
                  desc: TextEditingController(),
                  showSearch: true,
                ),
                combinedSearchField(
                  label: 'Address',
                  code: vm.supplierAddress,
                  desc: TextEditingController(),
                  showSearch: false,
                ),

                const SizedBox(height: 16),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        // vm.saveSupplier(); // call your save method
                        Navigator.pop(context);
                      },
                      child: const CommonTextView(label: "Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// --- Net Value Bottom Sheet ---
  void _showNetValueSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final dW = MediaQuery.of(context).size.width;
        Provider.of<PoApplicationVm>(context, listen: false);

        Widget labelWithField({required String label, required Widget field}) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CommonTextView(
                    label: label,
                    fontSize: 14,
                    maxLine: 1,
                    overFlow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(flex: 7, child: field),
              ],
            ),
          );
        }

        Widget combinedSearchField({
          required String label,
          required TextEditingController code,
          required TextEditingController desc,
          bool showSearch = false,
        }) {
          final controller = TextEditingController(
              text: code.text.isNotEmpty ? code.text : desc.text);
          return labelWithField(
            label: label,
            field: CommonTextFormField(
              label: label,
              controller: controller,
              enabled: false,
              height: 36,
              hintFontSize: 12,
              suffixWidget: showSearch ? const Icon(Icons.search) : null,
            ),
          );
        }

        Widget valueField(String label, double value) {
          return labelWithField(
            label: label,
            field: CommonTextFormField(
              label: label,
              controller: TextEditingController(text: value.toStringAsFixed(2)),
              enabled: false,
              height: 36,
              hintFontSize: 12,
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.only(
            left: dW * 0.03,
            right: dW * 0.03,
            top: dW * 0.03,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header block
                const CommonTextView(
                  label: "Net Value",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
                const Divider(),
                const SizedBox(height: 5),
                const CommonTextView(
                  label: "Item Details",
                  alignment: Alignment.topCenter,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
                const SizedBox(height: 5),
                // Item Details fields
                valueField("Gross Value", 0.0),
                valueField("Discount", 0.0),
                valueField("Gross Value after Discount", 0.0),
                valueField("Tax (Add to Cost)", 0.0),
                valueField("Tax (Recoverable)", 0.0),
                valueField("Expense", 0.0),
                valueField("Net Value", 0.0),

                const Divider(),
                const SizedBox(height: 5),

                const CommonTextView(
                  label: "Header",
                  alignment: Alignment.topCenter,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
                const Divider(),
                const SizedBox(height: 5),
                // Bottom block (summary)
                valueField("Tax (Add to Cost)", 0.0),
                valueField("Tax (Recoverable)", 0.0),
                valueField("Discount", 0.0),
                valueField("Expense", 0.0),
                valueField("Net Value", 0.0),

                const SizedBox(height: 16),

                // Save/Cancel buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        // Call your save method here
                        Navigator.pop(context);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;
    tS = dW * 0.045;
    final vm = Provider.of<PoApplicationVm>(context);

    InputDecoration deco(String hint, {Widget? suffix}) => InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: tS * 0.6,
          ),
          suffixIcon: suffix,
        );

    Widget labelWithField({
      required String label,
      required Widget field,
    }) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: dH * 0.01),
        child: Row(children: [
          Expanded(
              flex: 3,
              child: CommonTextView(
                label: label,
                maxLine: 1,
                overFlow: TextOverflow.ellipsis,
                fontSize: tS * 0.75,
              )),
          Expanded(flex: 7, child: field),
        ]),
      );
    }

    Widget combinedSearchField({
      required String label,
      required TextEditingController code,
      required TextEditingController desc,
      bool showSearch = true,
    }) {
      final controller = TextEditingController(
          text: code.text.isNotEmpty
              ? (desc.text.isNotEmpty
                  ? '${code.text} - ${desc.text}'
                  : code.text)
              : desc.text);
      void handleTap() {
        if (label == 'Reference*') {
          Provider.of<PoApplicationVm>(context, listen: false)
              .searchReference(context);
        } else {
          Provider.of<PoApplicationVm>(context, listen: false)
              .searchField(context, label);
        }
      }

      return labelWithField(
          label: label,
          field: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: showSearch ? handleTap : null,
            child: AbsorbPointer(
              absorbing: true,
              child: CommonTextFormField(
                label: label,
                controller: controller,
                enabled: false,
                height: dH * 0.05,
                hintFontSize: tS * 0.75,
                fontSize: tS * 0.75,
                suffixWidget: showSearch
                    ? Icon(
                        Icons.search,
                        size: tS * 1.2,
                      )
                    : null,
              ),
            ),
          ));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(dW * 0.04),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CommonButton(
                width: dW / 2.5,
                height: dH * 0.05,
                text: "Reference PR",
                fontSize: tS * 0.7,
                onPressed: () {
                  _showReferencePRSheet();
                },
                borderRadius: dW * 0.02,
                disable: false,
                // color: themeColor, // Use the locally defined themeColor
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                // color: themeColor,
                size: tS * 1.5,
              ),
              onSelected: (value) {
                if (value == 'create_supplier') {
                  _showCreateSupplierSheet();
                } else if (value == 'net_value') {
                  _showNetValueSheet();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'create_supplier',
                  child: CommonTextView(
                    label: 'Create Supplier',
                    fontSize: tS * 0.9,
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'net_value',
                  child: CommonTextView(
                    label: 'Net Value',
                    fontSize: tS * 0.9,
                  ),
                ),
              ],
            )
          ],
        ),
        combinedSearchField(
            label: 'Doc. Loc.*',
            code: vm.docLocCodeCtrl,
            desc: vm.docLocDescCtrl),
        combinedSearchField(
            label: 'Reference*',
            code: vm.referenceCtrl,
            desc: vm.referenceDescCtrl,
            showSearch: true),
        labelWithField(
            label: 'Ref. Doc.*',
            field: Row(children: [
              Expanded(
                  flex: 2,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: vm.isReferenceDirect
                        ? null
                        : () {
                            Provider.of<PoApplicationVm>(context, listen: false)
                                .searchRefTxnCode(context);
                          },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: Opacity(
                        opacity: vm.isReferenceDirect ? 0.5 : 1.0,
                        child: CommonTextFormField(
                          label: 'Ref Doc Code',
                          controller: vm.refDocCodeCtrl,
                          enabled: false,
                          height: dH * 0.05,
                          hintFontSize: tS * 0.75,
                          fontSize: tS * 0.75,
                          suffixWidget: Icon(
                            Icons.search,
                            size: tS * 1.2,
                            color: vm.isReferenceDirect ? Colors.grey : null,
                          ),
                        ),
                      ),
                    ),
                  )),
              const SizedBox(width: 4),
              Expanded(
                  flex: 3,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: vm.isReferenceDirect
                        ? null
                        : () {
                            Provider.of<PoApplicationVm>(context, listen: false)
                                .searchRefDocNo(context);
                          },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: Opacity(
                        opacity: vm.isReferenceDirect ? 0.5 : 1.0,
                        child: CommonTextFormField(
                          label: 'Ref Doc No',
                          controller: vm.refDocNoCtrl,
                          enabled: false,
                          height: dH * 0.05,
                          hintFontSize: tS * 0.75,
                          fontSize: tS * 0.75,
                          suffixWidget: vm.isReferenceDirect
                              ? null
                              : Icon(
                                  Icons.search,
                                  size: tS * 1.2,
                                ),
                        ),
                      ),
                    ),
                  )),
            ])),
        combinedSearchField(
            label: 'Supplier*',
            code: vm.supplierCtrl,
            desc: TextEditingController(),
            showSearch: true),
        // labelWithField(
        //     label: 'Sup Offer No.',
        //     field: CommonTextFormField(
        //       label: 'Sup Offer No.',
        //       controller: vm.supOfferNoCtrl,
        //       enabled: false,
        //       height: dH * 0.05,
        //       hintFontSize: tS * 0.75,
        //       fontSize: tS * 0.75,
        //     )),
        // labelWithField(
        //     label: 'Sup Offer Date*',
        //     field: CommonTextFormField(
        //       label: 'Sup Offer Date*',
        //       controller: vm.supOfferDateCtrl,
        //       enabled: false,
        //       suffixWidget: const Icon(Icons.calendar_month),
        //       height: dH * 0.05,
        //       hintFontSize: tS * 0.75,
        //       fontSize: tS * 0.75,
        //     )),
        combinedSearchField(
            label: 'Currency*',
            code: vm.currencyCodeCtrl,
            desc: vm.currencyDescCtrl,
            showSearch: true),
        labelWithField(
            label: 'Exchange Rate*',
            field: CommonTextFormField(
              label: 'Exchange Rate*',
              controller: vm.exchangeRateCtrl,
              enabled: false,
              height: dH * 0.05,
              hintFontSize: tS * 0.75,
              fontSize: tS * 0.75,
            )),
        labelWithField(
            label: 'Discount / Value',
            field: Row(children: [
              Expanded(
                  child: CommonTextFormField(
                label: 'Discount',
                controller: vm.discountCtrl,
                enabled: true,
                height: dH * 0.05,
                hintFontSize: tS * 0.75,
                fontSize: tS * 0.75,
                keyboardType: TextInputType.number,
                onChanged: vm.onDiscountChanged,
              )),
              const SizedBox(width: 8),
              Expanded(
                  child: CommonTextFormField(
                label: 'Value',
                controller: vm.valueCtrl,
                enabled: false,
                height: dH * 0.05,
                hintFontSize: tS * 0.75,
                fontSize: tS * 0.75,
              )),
            ])),
        labelWithField(
            label: 'Payment Term*',
            field: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Provider.of<PoApplicationVm>(context, listen: false)
                  .searchField(context, 'Payment Term*'),
              child: AbsorbPointer(
                absorbing: true,
                child: CommonTextFormField(
                  label: 'Payment Term*',
                  controller: vm.paymentTermCtrl,
                  enabled: false,
                  suffixWidget: const Icon(Icons.search),
                  height: dH * 0.05,
                  hintFontSize: tS * 0.75,
                  fontSize: tS * 0.75,
                ),
              ),
            )),
        labelWithField(
            label: 'Mode of Shipment*',
            field: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Provider.of<PoApplicationVm>(context, listen: false)
                  .searchField(context, 'Mode of Shipment*'),
              child: AbsorbPointer(
                absorbing: true,
                child: CommonTextFormField(
                  label: 'Mode of Shipment*',
                  controller: vm.modeShipmentCtrl,
                  enabled: false,
                  suffixWidget: const Icon(Icons.search),
                  height: dH * 0.05,
                  hintFontSize: tS * 0.75,
                  fontSize: tS * 0.75,
                ),
              ),
            )),
        labelWithField(
            label: 'Mode of Payment*',
            field: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Provider.of<PoApplicationVm>(context, listen: false)
                  .searchField(context, 'Mode of Payment*'),
              child: AbsorbPointer(
                absorbing: true,
                child: CommonTextFormField(
                  label: 'Mode of Payment*',
                  controller: vm.modePaymentCtrl,
                  enabled: false,
                  suffixWidget: const Icon(Icons.search),
                  height: dH * 0.05,
                  hintFontSize: tS * 0.75,
                  fontSize: tS * 0.75,
                ),
              ),
            )),
        combinedSearchField(
            label: 'Charge Type*',
            code: vm.chargeTypeCodeCtrl,
            desc: vm.chargeTypeDescCtrl,
            showSearch: true),
        combinedSearchField(
            label: 'Charge To*',
            code: vm.chargeToCodeCtrl,
            desc: vm.chargeToDescCtrl,
            showSearch: true),
        combinedSearchField(
            label: 'Ship to Store Loc*',
            code: vm.shipToStoreCodeCtrl,
            desc: vm.shipToStoreDescCtrl,
            showSearch: true),
        combinedSearchField(
            label: 'Purchase Type*',
            code: vm.purchaseTypeCodeCtrl,
            desc: vm.purchaseTypeDescCtrl,
            showSearch: true),
        combinedSearchField(
            label: 'Petty Cash No*',
            code: vm.pettyCashCodeCtrl,
            desc: vm.pettyCashDescCtrl,
            showSearch: true),
        combinedSearchField(
            label: 'Buyer ID*',
            code: vm.buyerCodeCtrl,
            desc: vm.buyerDescCtrl,
            showSearch: true),
        // labelWithField(
        //     label: 'ETA*',
        //     field: CommonTextFormField(
        //       label: 'ETA*',
        //       controller: vm.etaCtrl,
        //       enabled: false,
        //       suffixWidget: const Icon(Icons.calendar_month),
        //       height: dH * 0.05,
        //       hintFontSize: tS * 0.75,
        //       fontSize: tS * 0.75,
        //     )),
        combinedSearchField(
            label: 'Delivery Term*',
            code: vm.deliveryTermCodeCtrl,
            desc: vm.deliveryTermDescCtrl,
            showSearch: true),
        // labelWithField(
        //     label: 'Need By Date*',
        //     field: CommonTextFormField(
        //       label: 'Need By Date*',
        //       controller: vm.needByDateCtrl,
        //       enabled: false,
        //       suffixWidget: const Icon(Icons.calendar_month),
        //       height: dH * 0.05,
        //       hintFontSize: tS * 0.75,
        //       fontSize: tS * 0.75,
        //     )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: CommonTextView(
            label: 'Remark',
            height: dH * 0.03,
            fontSize: tS * 0.75,
            maxLine: 1,
            overFlow: TextOverflow.ellipsis,
          ),
        ),
        QuillTextField(
          controller: Provider.of<PoApplicationVm>(context, listen: false)
              .remarkQuillController,
          onChange: (_) {
            Provider.of<PoApplicationVm>(context, listen: false)
                .setRemarkFromQuill();
          },
          height: MediaQuery.of(context).size.height * 0.4,
        ),
      ]),
    );
  }
}

class _HeaderSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PoApplicationVm>(context);
    return Column(
      children: [
        TransactionStart(
          label: 'Doc. Date*',
          labelVal: vm.docDateCtrl.text,
          isCalendar: true,
          label2: 'Status',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: TransactionStart(
            label: 'Doc. No.*',
            labelVal: vm.docNoCtrl.text,
            label2: vm.statusCtrl.text.isEmpty ? 'New' : vm.statusCtrl.text,
            label2Color: Colors.green,
          ),
        ),
        Container(height: .2, color: Colors.grey),
      ],
    );
  }
}

class _ItemDetailsTab extends StatelessWidget {
  double dW = 0.0;

  double dH = 0.0;

  double tS = 0.0;
  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;
    tS = dW * 0.035; // Decreased text size multiplier
    final vm = Provider.of<PoApplicationVm>(context);
    final items = vm.purchaseOrderModel?.itemDetailsTab ?? [];

    return Column(
      children: [
        /// Top Controls (Select All, Add, Delete)
        Container(
          padding: EdgeInsets.only(
            top: 10,
            right: AppWidth(5),
            left: AppWidth(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    color: Colors.white),
                margin:
                    EdgeInsets.only(bottom: AppHeight(10), left: AppWidth(10)),
                child: CommonTextFormField(
                  height: AppHeight(30),
                  width: AppWidth(255),
                  label: 'Type to search...',
                  maxLines: 1,
                  isBorderUnderLine: false,
                  isBorderSideNone: true,
                  suffixWidget: Container(
                    width: AppWidth(20),
                    decoration: const BoxDecoration(
                        border: Border(
                            left: BorderSide(width: 1, color: Colors.grey))),
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  taxPopupList(context, 0);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: AppHeight(10), right: AppWidth(10)),
                  child: Icon(
                    Icons.attach_money,
                    color: context.resources.color.themeColor,
                    size: tS * 2.1,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            right: AppWidth(5),
            left: AppWidth(10),
          ),
          child: Row(
            children: [
              /// Select All Checkbox
              GestureDetector(
                onTap: () {
                  if (items.isNotEmpty) {
                    vm.onItemDetailsSelectAll();
                  }
                },
                child: Icon(
                  vm.isActionAll
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: context.resources.color.themeColor,
                ),
              ),
              const SizedBox(width: 5),
              const CommonTextView(label: 'Select All'),

              /// Add & Delete Buttons
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        vm.addItemDetailsLine();
                      },
                      icon: Icon(
                        Icons.add,
                        color: context.resources.color.themeColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        vm.deleteItemDetailsLine();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: context.resources.color.themeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// Empty State
        if (items.isEmpty)
          const CommonEmptyList()
        else

          /// Table
          Expanded(
            child: SingleChildScrollView(
              child: CustomViewOnlyTable(
                data: items,
                header1: 'Txn. No',
                header2: 'Ref. Doc.No',
                isScrollable: false,
                onOpen: (index) => vm.toggleItemOpen(index),
                getHeader1: (data) => data.txnNo ?? '',
                getHeader2: (data) => data.refDocNo ?? '',

                /// Checkbox column (header0)
                isIconHeader0: true,
                header0IconColor: Colors.white,
                header0IconTap: (index) {
                  vm.onItemDetailsSelected(index);
                },
                header0IconData: (index) => items[index].isSelected == true
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                ischildHeader0: true,
                headerChild: (index) => Expanded(
                  child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert,
                          size: 20, color: Colors.white),
                      onSelected: (String result) {
                        switch (result) {
                          case 'Attachments':
                            // provider
                            //     .onAccountPopUpAttachment(
                            //         context,
                            //         index);
                            // taxPopupList
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Attachments',
                              child: ListTile(
                                leading: Icon(Icons.attachment),
                                title: Text('Attachments'),
                              ),
                            ),
                          ]),
                ),

                // Item Code - search
                isRow1: true,
                row1Title: 'Item Code',
                row1Label: (data) => data.itemCode ?? '',
                row1IconData: (i) => Icons.search,
                isRow1Search: true,
                row1Tap: (index) {
                  vm.callItemSearch(context, index, 1);
                },
                row1Decoration:
                    BoxDecoration(color: Colors.white.withOpacity(.1)),

                // Desc
                isRow2: true,
                row2Title: 'Desc',
                row2Label: (data) => data.itemDesc ?? '',

                // UOM - search
                isRow3: true,
                row3Title: 'UOM',
                row3Label: (data) => data.uom ?? '',
                row3IconData: (i) => Icons.search,
                isRow3Search: true,
                row3Tap: (index) {
                  vm.callItemSearch(context, index, 2);
                },
                row3Decoration:
                    BoxDecoration(color: Colors.white.withOpacity(.1)),

                // Quantity - textfield
                isRow4: true,
                row4Title: 'Quantity',
                row4Label: (data) => data.quantity ?? '',
                isTextRow4: true,

                isRow5: true,
                row5Title: 'Loose Quantity',
                row5Label: (data) => data.looseQty ?? '',

                isRow6: true,
                row6Title: 'Base Quantity',
                row6Label: (data) => data.baseQty ?? '',

                // Unit Price - textfield
                isRow7: true,
                row7Title: 'Unit Price',
                row7Label: (data) => data.unitPrice ?? '',
                isTextRow7: (_) => true,

                isRow8: true,
                row8Title: 'Gross Value',
                row8Label: (data) => data.grossValue ?? '',

                // Discount %
                isRow9: true,
                row9Title: 'Discount %',
                row9Label: (data) => data.discountPer ?? '',
                isTextRow9: true,

                // Discount Value
                isRow10: true,
                row10Title: 'Discount Val',
                row10Label: (data) => data.discountVal ?? '',
                isTextRow10: true,

                isRow11: true,
                row11Title: 'Net Value',
                row11Label: (data) => data.netValue ?? '',

                isRow12: true,
                row12Title: 'Mnf. Desc',
                row12Label: (data) => data.mnfDesc ?? '',

                // Charge Type - search
                isRow13: true,
                row13Title: 'Charge Type',
                row13Label: (data) => data.chargeTypeCode ?? '',
                row13IconData: (i) => Icons.search,
                isRow13Search: true,
                row13Decoration:
                    BoxDecoration(color: Colors.white.withOpacity(.1)),

                isRow14: true,
                row14Title: 'Charge Type Desc',
                row14Label: (data) => data.chargeTypeName ?? '',

                // Charge To - search
                isRow15: true,
                row15Title: 'Charge To',
                row15Label: (data) => data.chargeToCode ?? '',
                row15IconData: (i) => Icons.search,
                isRow15Search: true,
                row15Decoration:
                    BoxDecoration(color: Colors.white.withOpacity(.1)),

                isRow16: true,
                row16Title: 'Charge To Desc',
                row16Label: (data) => data.chargeToName ?? '',

                isRow17: true,
                row17Title: 'Need By Dt',
                row17Label: (data) => data.needByDt ?? '',

                isRow18: true,
                row18Title: 'ETA',
                row18Label: (data) => data.etaDate ?? '',

                // GL Code - search
                isRow19: true,
                row19Title: 'GL Code',
                row19Label: (data) => data.glCode ?? '',
                row19IconData: (i) => Icons.search,
                isRow19Search: true,
                row19Tap: (index) {
                  vm.callItemSearch(context, index, 3);
                },
                row19Decoration:
                    BoxDecoration(color: Colors.white.withOpacity(.1)),

                isRow20: true,
                row20Title: 'GL Desc',
                row20Label: (data) => data.glDesc ?? '',

                // Note to Receiver
                isRow21: true,
                row21Title: 'Note to Receiver',
                row21Label: (data) => data.noteToReceiver ?? '',
                isTextRow21: true,
              ),
            ),
          ),
      ],
    );
  }

  void taxPopupList(BuildContext context, int parentIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {},
          child: FractionallySizedBox(
            heightFactor: 0.9,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter myState) {
                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  child: Consumer<PoApplicationVm>(
                    builder: (context, provider, child) {
                      var taxPopupList = provider.purchaseOrderModel!
                          .itemDetailsTab![parentIndex].taxPopup;

                      return Scaffold(
                        appBar: AppBar(
                          backgroundColor: context.resources.color.themeColor,
                          centerTitle: true,
                          title: CommonTextView(
                            label: 'Tax',
                            color: context.resources.color.colorWhite,
                            fontSize: context.resources.dimension.appMediumText,
                          ),
                          actions: [
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 25.0,
                                color: context.resources.color.colorWhite,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                          automaticallyImplyLeading: false,
                        ),
                        body: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                        top: 10,
                                        right: AppWidth(5),
                                        left: AppWidth(5),
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // provider
                                              //     .onTaxPopupAll(parentIndex);
                                            },
                                            child: Icon(
                                              provider.isActionAll
                                                  ? Icons.check_box
                                                  : Icons
                                                      .check_box_outline_blank,
                                              color: context
                                                  .resources.color.themeColor,
                                            ),
                                          ),
                                          CommonTextView(
                                            label: 'Select_All'.tr(),
                                          ),
                                          if (!provider.isSubmit)
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      // provider.addTaxPopupLine(
                                                      //     parentIndex);
                                                    },
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: context.resources
                                                          .color.themeColor,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      // provider
                                                      //     .deleteTaxPopByLine(
                                                      //         parentIndex);
                                                    },
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: context.resources
                                                          .color.themeColor,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      // provider
                                                      //     .checkMandatoryFieldsCharge(
                                                      //         context, parentIndex);
                                                    },
                                                    icon: Icon(
                                                      Icons.save,
                                                      color: context.resources
                                                          .color.themeColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (taxPopupList!.isEmpty)
                                      const CommonTextView(
                                        label: 'Data not found',
                                        alignment: Alignment.center,
                                      )
                                    else
                                      CustomViewOnlyTable(
                                        data: taxPopupList,
                                        header1: 'Code*',
                                        header2: 'Currency*',
                                        isScrollable: false,
                                        getHeader1: (data) =>
                                            data.taxCode ?? 'N/A',
                                        isIconHeader0: true,
                                        header0IconColor: Colors.white,
                                        header0IconTap: (index) {
                                          // provider.onTaxPopUpBySelected(
                                          //     parentIndex, index);
                                        },
                                        header1Search: (index) {
                                          // provider.callReEntry(
                                          //     context, index, 1,
                                          //     parentIndex: parentIndex);
                                        },
                                        header1Decoration: const BoxDecoration(
                                            color: Colors.white),
                                        isSearchHeader1: true,
                                        header0IconData: (index) {
                                          // return provider
                                          //         .bankPaymentModel!
                                          //         .onAccountTab![parentIndex]
                                          //         .taxPopup![index]
                                          //         .isSelected
                                          //     ? Icons.check_box
                                          //     : Icons.check_box_outline_blank;
                                        },
                                        getHeader2: (data) =>
                                            data.currencyCode ?? 'N/A',
                                        // header2Decoration: const BoxDecoration(
                                        //     color: Colors.white),
                                        header2Search: (index) {},
                                        onOpen: (index) {
                                          // provider.onTaxPopUp(
                                          //     index, parentIndex);
                                        },
                                        isTextRow1: (index) => true,
                                        row1Tap: (index) {
                                          // provider.updateTaxPopupAmounts(
                                          //     parentIndex);
                                        },
                                        row1Controller: (index) {
                                          // return provider
                                          //     .bankPaymentModel!
                                          //     .onAccountTab![parentIndex]
                                          //     .taxPopup![index]
                                          //     .taxPopUpPercentController;
                                        },
                                        row1KeyboardType: TextInputType.number,
                                        row1TextOnChange: (val, childIndex) {
                                          // provider.updateTaxLcAmountOnChange(
                                          //     val, parentIndex, childIndex);
                                        },

                                        row1Title: '%',
                                        row1Label: (data) =>
                                            data.discountPercent ?? 'N/A',
                                        isRow1Search: true,
                                        row1Decoration: const BoxDecoration(
                                            color: Colors.white),

                                        isRow2: true,
                                        row2Tap: (index) {},
                                        row2Title: 'Amount',
                                        row2Label: (data) =>
                                            data.discountValue ?? 'N/A',
                                        isRow3: true,
                                        row3Tap: (index) {},
                                        row3Title: 'LC Amount',
                                        row3Label: (data) =>
                                            data.discountLcvalue ?? 'N/A',
                                        row4Title: 'Remark', isRow4: true,
                                        isTextRow4: true,
                                        row4Tap: (index) {},
                                        row4Controller: (index) {
                                          // return provider
                                          //     .bankPaymentModel!
                                          //     .onAccountTab![parentIndex]
                                          //     .taxPopup![index]
                                          //     .taxPopUpRemarksController;
                                        },

                                        row4TextOnChange: (val, index) {},
                                        row4Label: (data) =>
                                            data.taxRemark ?? 'N/A',
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CommonButton(
                                    buttonWidth: ButtonWidth.WRAP,
                                    text: 'OK',
                                    onPressed: () {
                                      // provider.saveTaxPopupData(
                                      //     context, parentIndex);
                                    },
                                    color: Colors.green,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CommonButton(
                                    buttonWidth: ButtonWidth.WRAP,
                                    text: 'Close',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
