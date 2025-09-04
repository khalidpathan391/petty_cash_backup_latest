import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CommonEmptyList extends StatelessWidget {
  const CommonEmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding for better centering
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image to visually indicate an empty list
            // Image.asset(
            //   'assets/images/empty_list_image.jpg', // Path to the image asset
            //   // color: Colors.blueGrey.shade300, // Optional color filter for the image
            // ),
            //gif
            // Image.asset(
            //   'assets/images/empty_list_animation.gif', // Path to the image asset
            //   // color: Colors.blueGrey.shade300, // Optional color filter for the image
            // ),
            // Icon to visually indicate an empty list
            Icon(
              Icons.inbox_rounded,
              size: 80.0,
              color: Colors.blueGrey.shade300, // Softer color for elegance
            ),
            const SizedBox(height: 20), // Space between icon and text

            // Beautiful text widget indicating the list is empty
            Text(
              'List_Empty'.tr(),
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w500, // Semi-bold for elegance
                color: Colors.blueGrey.shade600, // Slightly softer color for the text
              ),
            ),
            const SizedBox(height: 10), // Space between text and description

            // Additional description for a better user experience
            Text(
              'There are currently no items to display.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey.shade500,
                height: 1.5, // Increase line height for readability
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
