// // ignore_for_file: unused_local_variable

// import 'package:flutter/material.dart';
// import 'package:petty_cash/resources/app_extension_context.dart';
// import 'package:petty_cash/view/widget/erp_text_field.dart';


// class CustomSearchFieldWidget extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final Function onSearch;

//   const CustomSearchFieldWidget({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     required this.onSearch,
//   });

//   @override
//   State<CustomSearchFieldWidget> createState() =>
//       _CustomSearchFieldWidgetState();
// }

// class _CustomSearchFieldWidgetState extends State<CustomSearchFieldWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final themeColor = context.resources.color.themeColor;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final iconHeight = screenHeight * 0.05;
//     final fieldWidth = screenWidth * 0.5;

//     return Container(
//       padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               height: iconHeight,
//               width: fieldWidth,
//               decoration: BoxDecoration(
//                 border: Border.all(width: 1, color: Colors.grey),
//                 borderRadius: BorderRadius.circular(15), // Rounded corners
//                 color: Colors.white,
//               ),
//               margin: const EdgeInsets.only(bottom: 10),
//               child: CommonTextFormField(
//                 controller: widget.controller,
//                 hintText: widget.hintText,
//                 readOnly: false,
//                 keyboardType: TextInputType.text,
//                 suffixIcon: Icons.search,
//                 onSuffixIconTap: () => widget.onSearch(),
//                 decoration: InputDecoration(
//                   hintText: widget.hintText,
//                   hintStyle: TextStyle(
//                     color: Colors.grey,
//                     fontSize: context.resources.dimension.appSmallText + 2,
//                   ),
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 15, vertical: 10), // Add more padding
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
