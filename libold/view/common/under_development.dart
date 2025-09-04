import 'package:flutter/material.dart';

class UnderDevelopment extends StatelessWidget {
  final String? text;
  final double bottomSpacing;
  const UnderDevelopment({super.key, this.text, this.bottomSpacing = 100});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display image for Under Development
            Image.asset(
              'assets/images/under_development.png', // Path to your image asset
              width: 300, // Adjust size if necessary
              height: 300, // Adjust size if necessary
            ),
            Text(
              text ?? "Page Under Development",
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            const Text(
              "We're working hard to bring this feature to you.",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: bottomSpacing),
          ],
        ),
      ),
    );
  }
}
