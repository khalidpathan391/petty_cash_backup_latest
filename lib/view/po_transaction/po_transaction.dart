// ignore_for_file: avoid_print, unused_element, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/po_model.dart/get_reefernce_pr.dart';

// import 'package:easy_localization/easy_localization.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/globalSize.dart';
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
    tS = dW * 0.045;

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
                                padding: const EdgeInsets.only(
                                    right: 10, left: 15, top: 15),
                                child: _HeaderSummary(),
                              ),
                              TabBar(
                                controller: _tabController,
                                tabs: List.generate(provider.tabHeaders.length,
                                    (index) {
                                  return Tab(
                                    child: CommonTextView(
                                      label: provider.tabHeaders[index],
                                      fontSize: context
                                          .resources.dimension.appBigText,
                                      color: themeColor,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: AppWidth(10)),
                                    ),
                                  );
                                }),
                                indicatorColor: themeColor,
                                labelColor: themeColor,
                                unselectedLabelColor:
                                    themeColor.withOpacity(0.5),
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                unselectedLabelStyle: const TextStyle(
                                    fontWeight: FontWeight.normal),
                                indicatorPadding: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(0),
                                tabAlignment: TabAlignment.start,
                                indicator: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: context.resources.color.themeColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                overlayColor:
                                    MaterialStateColor.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return context.resources.color.themeColor
                                        .withOpacity(.2);
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
                                        selectedItems[pr.srNo!] = val ?? false;
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
                                          fontSize: context.resources.dimension
                                              .appMediumText,
                                        ),
                                        const SizedBox(height: 4),
                                        CommonTextView(
                                          label: 'Qty: ${pr.priItemQty ?? '-'}',
                                          fontSize: context.resources.dimension
                                                  .appMediumText -
                                              2,
                                          color: Colors.grey[700],
                                        ),
                                        const SizedBox(height: 4),
                                        CommonTextView(
                                          label:
                                              'Note to Buyer: ${pr.priNoteToBuyer ?? '-'}',
                                          fontSize: context.resources.dimension
                                                  .appMediumText -
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
                            ),
                          );
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
                : desc.text,
          );
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
    InputDecoration deco(String hint, {Widget? suffix}) =>
        const InputDecoration();

    Widget labelWithField({
      required String label,
      required Widget field,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Expanded(
              flex: 3,
              child: CommonTextView(
                label: label,
                maxLine: 1,
                overFlow: TextOverflow.ellipsis,
                fontSize: context.resources.dimension.appSmallText,
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
      return labelWithField(
          label: label,
          field: CommonTextFormField(
            label: label,
            controller: controller,
            enabled: false,
            height: 36,
            hintFontSize: 12,
            suffixWidget: showSearch ? const Icon(Icons.search) : null,
          ));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CommonButton(
                width: dW / 2.5,
                height: 35,
                text: "Reference PR",
                fontSize: context.resources.dimension.appMediumText,
                onPressed: () {
                  _showReferencePRSheet();
                },
                borderRadius: 8.0,
                disable: false,
                color: context.resources.color.themeColor,
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: context.resources.color.themeColor,
                size: 20,
              ),
              onSelected: (value) {
                if (value == 'create_supplier') {
                  _showCreateSupplierSheet();
                } else if (value == 'net_value') {
                  _showNetValueSheet();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'create_supplier',
                  child: CommonTextView(label: 'Create Supplier'),
                ),
                const PopupMenuItem<String>(
                  value: 'net_value',
                  child: CommonTextView(label: 'Net Value'),
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
                  child: CommonTextFormField(
                label: 'Ref Doc Code',
                controller: vm.refDocCodeCtrl,
                enabled: !vm.isReferenceDirect,
                height: 36,
                hintFontSize: 12,
                suffixWidget: const Icon(Icons.search),
              )),
              const SizedBox(width: 8),
              Expanded(
                  child: CommonTextFormField(
                label: 'Ref Doc No',
                controller: vm.refDocNoCtrl,
                enabled: !vm.isReferenceDirect,
                height: 36,
                hintFontSize: 12,
              )),
            ])),
        combinedSearchField(
            label: 'Supplier*',
            code: vm.supplierCtrl,
            desc: TextEditingController(),
            showSearch: true),
        labelWithField(
            label: 'Sup Offer No.',
            field: CommonTextFormField(
              label: 'Sup Offer No.',
              controller: vm.supOfferNoCtrl,
              enabled: false,
              height: 36,
              hintFontSize: 12,
            )),
        labelWithField(
            label: 'Sup Offer Date*',
            field: CommonTextFormField(
              label: 'Sup Offer Date*',
              controller: vm.supOfferDateCtrl,
              enabled: false,
              suffixWidget: const Icon(Icons.calendar_month),
              height: 36,
              hintFontSize: 12,
            )),
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
              height: 36,
              hintFontSize: 12,
            )),
        labelWithField(
            label: 'Discount / Value',
            field: Row(children: [
              Expanded(
                  child: CommonTextFormField(
                label: 'Discount',
                controller: vm.discountCtrl,
                enabled: true,
                height: 36,
                hintFontSize: 12,
                keyboardType: TextInputType.number,
                onChanged: vm.onDiscountChanged,
              )),
              const SizedBox(width: 8),
              Expanded(
                  child: CommonTextFormField(
                label: 'Value',
                controller: vm.valueCtrl,
                enabled: false,
                height: 36,
                hintFontSize: 12,
              )),
            ])),
        labelWithField(
            label: 'Payment Term*',
            field: CommonTextFormField(
              label: 'Payment Term*',
              controller: vm.paymentTermCtrl,
              enabled: false,
              suffixWidget: const Icon(Icons.search),
              height: 36,
              hintFontSize: 12,
            )),
        labelWithField(
            label: 'Mode of Shipment*',
            field: CommonTextFormField(
              label: 'Mode of Shipment*',
              controller: vm.modeShipmentCtrl,
              enabled: false,
              suffixWidget: const Icon(Icons.search),
              height: 36,
              hintFontSize: 12,
            )),
        labelWithField(
            label: 'Mode of Payment*',
            field: CommonTextFormField(
              label: 'Mode of Payment*',
              controller: vm.modePaymentCtrl,
              enabled: false,
              suffixWidget: const Icon(Icons.search),
              height: 36,
              hintFontSize: 12,
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
        labelWithField(
            label: 'ETA*',
            field: CommonTextFormField(
              label: 'ETA*',
              controller: vm.etaCtrl,
              enabled: false,
              suffixWidget: const Icon(Icons.calendar_month),
              height: 36,
              hintFontSize: 12,
            )),
        combinedSearchField(
            label: 'Delivery Term*',
            code: vm.deliveryTermCodeCtrl,
            desc: vm.deliveryTermDescCtrl,
            showSearch: true),
        labelWithField(
            label: 'Need By Date*',
            field: CommonTextFormField(
              label: 'Need By Date*',
              controller: vm.needByDateCtrl,
              enabled: false,
              suffixWidget: const Icon(Icons.calendar_month),
              height: 36,
              hintFontSize: 12,
            )),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: CommonTextView(
            label: 'Remark',
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
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Item details will be here'));
  }
}
