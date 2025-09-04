// import 'package:flutter/material.dart';
// import 'package:labour_bazaar/resources/app_extension_context.dart';
// import 'package:labour_bazaar/view_model/auth_vm/detail_setup_vm.dart';

// import 'package:provider/provider.dart';

// class DatePickerWidget extends StatelessWidget {
//   const DatePickerWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Color themeColor = context.resources.color.themeColor;
//     final provider = context.watch<RegisterDetailsVm>();

//     return TextFormField(
//       readOnly: true,
//       decoration: InputDecoration(
//         labelText: 'Birth Date',
//         hintText: '${provider.selectedDate.toLocal()}'.split(' ')[0],
//         suffixIcon: Icon(
//           Icons.calendar_today,
//           color: themeColor,
//         ),
//       ),
//       style: TextStyle(
//         color: themeColor,
//       ),
//       onTap: () {
//         provider.selectDate(context);
//       },
//     );
//   }
// }
