import 'package:flutter/material.dart';

class CommonPopupContent extends StatefulWidget {
  final String title;
  final List<Map<String, String>> data;
  final String docNoColumn;
  final String statusColumn;

  const CommonPopupContent({
    super.key,
    required this.title,
    required this.data,
    required this.docNoColumn,
    required this.statusColumn,
  });

  @override
  State<CommonPopupContent> createState() => _CommonPopupContentState();
}

class _CommonPopupContentState extends State<CommonPopupContent> {
  int currentPage = 1;
  final int itemsPerPage = 5;
  final ScrollController _scrollController = ScrollController();

  int get totalPages => (widget.data.length / itemsPerPage).ceil();

  List<Map<String, String>> get currentPageData {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return widget.data.sublist(
      startIndex,
      endIndex > widget.data.length ? widget.data.length : endIndex,
    );
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      setState(() {
        currentPage = page;
      });

      // Auto-scroll to show the selected page number
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToPage(page);
      });
    }
  }

  void _scrollToPage(int page) {
    if (_scrollController.hasClients) {
      // Calculate the position to scroll to
      // Each page number button is 48px wide (40px + 8px padding)
      final double scrollPosition = (page - 1) * 48.0;
      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final headerSpacing = screenHeight * 0.025; // 2.5% of screen height
    final bottomSpacing = screenHeight * 0.025; // 2.5% of screen height
    final buttonSpacing = screenWidth * 0.02; // 2% of screen width
    final pageButtonSize = screenWidth * 0.1; // 10% of screen width

    return Column(
      children: [
        // Header - Fixed at top
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: screenWidth * 0.05, // 5% of screen width
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        SizedBox(height: headerSpacing),

        // Scrollable content area
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Table Header
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.015, // 1.5% of screen height
                    horizontal: screenWidth * 0.04, // 4% of screen width
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.docNoColumn,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                screenWidth * 0.038, // 3.8% of screen width
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.statusColumn,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                screenWidth * 0.038, // 3.8% of screen width
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Table Body
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: currentPageData
                        .map(
                          (data) => _buildTableRow(
                            data[widget.docNoColumn]!,
                            data[widget.statusColumn]!,
                            context,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: bottomSpacing),

        // Pagination Controls - Fixed at bottom
        Column(
          children: [
            // Page Numbers Row
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Previous Button
                  IconButton(
                    onPressed: currentPage > 1
                        ? () => goToPage(currentPage - 1)
                        : null,
                    icon: Icon(
                      Icons.chevron_left,
                      size: screenWidth * 0.06, // 6% of screen width
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: currentPage > 1
                          ? Colors.blue.shade50
                          : Colors.grey.shade100,
                    ),
                  ),
                  SizedBox(width: buttonSpacing),

                  // Page Numbers
                  ...List.generate(totalPages, (index) {
                    final pageNumber = index + 1;
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                      ), // 1% of screen width
                      child: InkWell(
                        onTap: () => goToPage(pageNumber),
                        child: Container(
                          width: pageButtonSize,
                          height: pageButtonSize,
                          decoration: BoxDecoration(
                            color: currentPage == pageNumber
                                ? Colors.blue
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: currentPage == pageNumber
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              pageNumber.toString(),
                              style: TextStyle(
                                color: currentPage == pageNumber
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    screenWidth * 0.035, // 3.5% of screen width
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  SizedBox(width: buttonSpacing),

                  // Next Button
                  IconButton(
                    onPressed: currentPage < totalPages
                        ? () => goToPage(currentPage + 1)
                        : null,
                    icon: Icon(
                      Icons.chevron_right,
                      size: screenWidth * 0.06, // 6% of screen width
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: currentPage < totalPages
                          ? Colors.blue.shade50
                          : Colors.grey.shade100,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: bottomSpacing),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.015,
                  ), // 1.5% of screen height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // 4% of screen width
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTableRow(String docNo, String status, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final verticalPadding = screenHeight * 0.015; // 1.5% of screen height
    final horizontalPadding = screenWidth * 0.04; // 4% of screen width
    final fontSize = screenWidth * 0.035; // 3.5% of screen width
    final statusPadding = screenWidth * 0.02; // 2% of screen width

    Color statusColor = Colors.green;
    if (status == 'No') {
      statusColor = Colors.red;
    } else if (status == 'Pending') {
      statusColor = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              docNo,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: statusPadding,
                vertical: statusPadding * 0.5,
              ),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: fontSize * 0.85, // Slightly smaller than main text
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function to show the common popup
void showCommonPopup(
  BuildContext context, {
  required String title,
  required List<Map<String, String>> data,
  required String docNoColumn,
  required String statusColumn,
}) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  final bottomSheetHeight = screenHeight * 0.95; // 95% of screen height
  final topMargin = screenHeight * 0.06; // 6% of screen height
  final padding = screenWidth * 0.06; // 6% of screen width

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: bottomSheetHeight,
        margin: EdgeInsets.only(top: topMargin),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: CommonPopupContent(
            title: title,
            data: data,
            docNoColumn: docNoColumn,
            statusColumn: statusColumn,
          ),
        ),
      );
    },
  );
}
