import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildCard(
            title: 'This Week New Leads',
            count: '0',
            bgColor: const Color(0xFF8E5CFF), // Purple
            image: 'assets/images/avtar.png',
          ),
          const SizedBox(height: 12),
          _buildCard(
            title: 'Interested',
            count: '0',
            bgColor: const Color(0xFFFDCB58), // Yellow
            image: 'assets/images/avtar.png',
          ),
          const SizedBox(height: 12),
          _buildCard(
            title: 'This Week Followups',
            count: '0',
            bgColor: const Color(0xFFFF8A94), // Red-pink
            image: 'assets/images/avtar.png',
          ),
          const SizedBox(height: 12),
          _buildCard(
            title: 'Converted',
            count: '0',
            bgColor: const Color(0xFF4A8DFF), // Blue
            image: 'assets/images/avtar.png',
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String count,
    required Color bgColor,
    required String image,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text part
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          // Image part
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
