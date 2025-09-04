// import 'package:crebri_erp_app/models/CommonModels/common_transaction_models.dart';
// import 'package:crebri_erp_app/res/AppContextExtension.dart';
// import 'package:flutter/material.dart';

// class HeaderButtons extends StatelessWidget {
//   final List<ValHeaderBtns> buttonList;
//   final Function(ValHeaderBtns) buttonTap;

//   const HeaderButtons({
//     super.key,
//     required this.buttonList,
//     required this.buttonTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return buttonList.isNotEmpty
//         ? Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Wrap(
//               spacing: 8.0, // spacing between buttons
//               runSpacing: 8.0, // spacing between lines
//               alignment: WrapAlignment.end,
//               children: buttonList.map((buttonData) {
//                 return ElevatedButton(
//                   onPressed: () => buttonTap(buttonData),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 6.0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(3.0),
//                     ),
//                     backgroundColor: context.resources.color.themeColor,
//                     elevation: 4,
//                     shadowColor: Colors.black45, // Shadow color
//                   ),
//                   child: Text(
//                     buttonData.fieldValCodeDesc ??
//                         buttonData.fieldName ??
//                         'Button',
//                     style: const TextStyle(
//                       fontSize: 12.0,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white, // Text color
//                     ),
//                     overflow:
//                         TextOverflow.ellipsis, // Handle long text gracefully
//                   ),
//                 );
//               }).toList(),
//             ),
//           )
//         : const SizedBox();
//   }
// }
