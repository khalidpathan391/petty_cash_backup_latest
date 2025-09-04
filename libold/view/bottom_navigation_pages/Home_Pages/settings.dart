import 'package:flutter/material.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';
import 'package:petty_cash/view_model/HomePage/HomeVM.dart';
import 'package:provider/provider.dart';

class SettingHome extends StatefulWidget {
  static const String id = "setting_home";
  const SettingHome({super.key});

  @override
  State<SettingHome> createState() => _SettingHomeState();
}

class _SettingHomeState extends State<SettingHome> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVM>(builder: (context, provider, widget) {
      return Scaffold(
        appBar: AppBar(
          title: CommonTextView(
            label: 'Settings',
            color: Colors.white,
            fontSize: context.resources.dimension.appBigText + 2,
            fontFamily: 'Bold',
          ),
          centerTitle: true,
        ),
        body: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : AppUtils.errorMessage.isNotEmpty
                ? AppUtils(context).getCommonErrorWidget(() {
                    // provider.callSettingPriorityApi();
                  }, '')
                : Column(
                    children: [
                      SettingRows(
                        onPressed: () {
                          provider.setPriority();
                        },
                        iconSelected: provider.isPriority,
                        label: 'Priority',
                      ),
                      const Row(
                        children: [
                          Expanded(child: Text('')),
                          Expanded(
                              child: CommonTextView(
                            label: 'Colors',
                          )),
                          Expanded(
                              child: CommonTextView(
                            label: 'Min.',
                          )),
                          Expanded(
                              child: CommonTextView(
                            label: 'Max.',
                          )),
                        ],
                      ),
                      Container(
                        height: AppHeight(6),
                        margin: EdgeInsets.symmetric(
                            vertical: AppHeight(5), horizontal: AppWidth(5)),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: context.resources.color.colorLightGrey,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      // ListView.builder(
                      //   itemCount: provider.dashBoardSettingData!.priority!.length,
                      //     shrinkWrap: true,
                      //     itemBuilder: (context,index){
                      //       return PriorityRows(
                      //         priorityType: provider.dashBoardSettingData!.priority![index].priorityName.toString(),
                      //         priorityColor: provider.getPriorityColor(provider.dashBoardSettingData!.priority![index].color.toString()),
                      //         onColorTap: (){AppUtils.showCustomColorPicker(context,(color) => provider.getColorInString(color,index));},
                      //         minLabel: provider.dashBoardSettingData!.priority![index].min.toString(),
                      //         maxLabel: provider.dashBoardSettingData!.priority![index].max.toString(),
                      //         minController: provider.dashBoardSettingData!.priority![index].minController,
                      //         maxController: provider.dashBoardSettingData!.priority![index].maxController,
                      //         onMinChange: (val) => provider.setMinChange(val,index),
                      //         onMaxChange: (val) => provider.setMaxChange(val,index),
                      //       );
                      //     },
                      //     ),
                      /*PriorityRows(
              priorityType: provider.dashBoardSettingData!.priority![0].priorityName.toString(),
              priorityColor: provider.getPriorityColor(provider.dashBoardSettingData!.priority![0].color.toString()),
              onColorTap: (){AppUtils.showCustomColorPicker(context,(color) => provider.getColorInString(color,0));},
              minLabel: provider.dashBoardSettingData!.priority![0].min.toString(),
              maxLabel: provider.dashBoardSettingData!.priority![0].max.toString(),
              minController: provider.dashBoardSettingData!.priority![0].minController,
              maxController: provider.dashBoardSettingData!.priority![0].maxController,
              onMinChange: (val) => provider.setMinChange(val,0),
              onMaxChange: (val) => provider.setMaxChange(val,0),
            ),
            PriorityRows(
              priorityType: provider.dashBoardSettingData!.priority![1].priorityName.toString(),
              priorityColor: provider.getPriorityColor(provider.dashBoardSettingData!.priority![1].color.toString()),
              onColorTap: (){AppUtils.showCustomColorPicker(context,(color) => provider.getColorInString(color,1));},
              minLabel: provider.dashBoardSettingData!.priority![1].min.toString(),
              maxLabel: provider.dashBoardSettingData!.priority![1].max.toString(),
              minController: provider.dashBoardSettingData!.priority![1].minController,
              maxController: provider.dashBoardSettingData!.priority![1].maxController,
              onMinChange: (val) => provider.setMinChange(val,1),
              onMaxChange: (val) => provider.setMaxChange(val,1),
            ),
            PriorityRows(
              priorityType: provider.dashBoardSettingData!.priority![2].priorityName.toString(),
              priorityColor: provider.getPriorityColor(provider.dashBoardSettingData!.priority![2].color.toString()),
              onColorTap: (){AppUtils.showCustomColorPicker(context,(color) => provider.getColorInString(color,2));},
              minLabel: provider.dashBoardSettingData!.priority![2].min.toString(),
              maxLabel: provider.dashBoardSettingData!.priority![2].max.toString(),
              minController: provider.dashBoardSettingData!.priority![2].minController,
              maxController: provider.dashBoardSettingData!.priority![2].maxController,
              onMinChange: (val) => provider.setMinChange(val,2),
              onMaxChange: (val) => provider.setMaxChange(val,2),
            ),*/
                      SettingRows(
                        onPressed: () {
                          provider.setFYIClear();
                        },
                        iconSelected: provider.isFYIClear,
                        label: 'FYI Clear',
                      ),
                      SettingRows(
                        onPressed: () {
                          provider.setNotification();
                        },
                        iconSelected: provider.isNotification,
                        label: 'Notification Enable/Disable',
                        onTap: () {
                          provider.setNotificationTick(
                              !provider.isNotificationTick);
                        },
                        isSelected: provider.isNotificationTick,
                        showTick: true,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: CommonButton(
                              text: provider.isPriority
                                  ? 'Save'
                                  : provider.isFYIClear
                                      ? 'Clear All'
                                      : 'Submit',
                              isLoading: provider.isApply,
                              onPressed: () {
                                // if(provider.isPriority){provider.callSettingPriorityApplyApi(context);}
                                // if(provider.isFYIClear){provider.callSettingFYIClearApplyApi(context);}
                                // if(provider.isNotification){provider.callSettingNotificationApplyApi(context);}
                              }),
                        ),
                      ),
                    ],
                  ),
      );
    });
  }
}

class PriorityRows extends StatelessWidget {
  final String priorityType;
  final Color priorityColor;
  final String minLabel;
  final String maxLabel;
  final VoidCallback? onColorTap;
  final TextEditingController? minController;
  final TextEditingController? maxController;
  final Function(String)? onMinChange;
  final Function(String)? onMaxChange;
  const PriorityRows({
    super.key,
    required this.priorityType,
    required this.priorityColor,
    this.minLabel = '0',
    this.maxLabel = '1',
    this.onColorTap,
    this.minController,
    this.maxController,
    this.onMinChange,
    this.onMaxChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppWidth(5)),
          child: Row(
            children: [
              Expanded(
                  child: CommonTextView(
                label: priorityType,
              )),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(right: AppWidthP(5)),
                  child: InkWell(
                    onTap: onColorTap,
                    child: Container(
                      height: AppHeight(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        color: context.resources.color.defaultBlueGrey
                            .withOpacity(.2),
                      ),
                      child: Container(
                        height: AppHeight(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: AppWidthP(2.5)),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: priorityColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CommonTextFormField(
                  height: AppHeight(30),
                  margin: EdgeInsets.only(right: AppWidthP(3)),
                  label: minLabel,
                  controller: minController,
                  onChanged: onMinChange,
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: CommonTextFormField(
                  height: AppHeight(30),
                  margin: EdgeInsets.only(right: AppWidthP(3)),
                  label: maxLabel,
                  controller: maxController,
                  onChanged: onMaxChange,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: AppHeight(6),
          margin: EdgeInsets.symmetric(
              vertical: AppHeight(5), horizontal: AppWidth(5)),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: context.resources.color.colorLightGrey,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SettingRows extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool iconSelected;
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showTick;
  const SettingRows({
    super.key,
    this.onPressed,
    this.iconSelected = false,
    required this.label,
    this.onTap,
    this.isSelected = false,
    this.showTick = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.resources.color.defaultBlueGrey.withOpacity(.2),
      height: AppHeight(50),
      margin: EdgeInsets.only(bottom: AppHeight(10)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              iconSelected ? Icons.circle : Icons.circle_outlined,
              color: Colors.black,
            ),
          ),
          CommonTextView(
            label: label,
            fontFamily: 'Bold',
          ),
          iconSelected && showTick
              ? Expanded(
                  child: Container(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.black,
                        width: 2,
                      )),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.done,
                        color: isSelected ? Colors.black : Colors.transparent,
                        size: 15,
                      ),
                    ),
                  ),
                ))
              : const SizedBox(),
        ],
      ),
    );
  }
}
