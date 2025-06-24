import 'package:flutter/material.dart';

class ProductDetailsHistoryScreen extends StatelessWidget {
  final String productImagePath;
  final String title;
  final String age;
  final String description;
  final VoidCallback onDelete;

  // Exchange with info
  final String exchangeUserImagePath;
  final String exchangeUserName;
  final String exchangeUserPhone;
  final String exchangeUserLocation;

  const ProductDetailsHistoryScreen({
    super.key,
    required this.productImagePath,
    required this.title,
    required this.age,
    required this.description,
    required this.onDelete,
    required this.exchangeUserImagePath,
    required this.exchangeUserName,
    required this.exchangeUserPhone,
    required this.exchangeUserLocation,
  });

  @override
  Widget build(BuildContext context) {
    // Colors used in the design
    final Color containerBackground = const Color(0xFFF7EFE2);
    final Color containerBorder = const Color(0xFFD9BAA1);
    final Color accentColor = const Color(0xFFCC9966);
    final Color deleteIconColor = const Color(0xFFD85A5A);
    final Color textColor = const Color(0xFF333333);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Product History',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product details',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Merged Container for Product + Exchange User info
            Container(
              decoration: BoxDecoration(
                color: containerBackground,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: containerBorder),
              ),
              padding: const EdgeInsets.all(12),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Section
                      Text(
                        'My product',
                        style: TextStyle(
                          fontSize: 12,
                          color: accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image - FIXED: Using Image.network instead of Image.asset
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                            ),
                            child: productImagePath.isNotEmpty
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: productImagePath.startsWith('assets/')
                                  ? Image.asset(
                                productImagePath,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.image_not_supported,
                                        color: Colors.grey, size: 30),
                                  );
                                },
                              )
                                  : Image.network(
                                productImagePath,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.image_not_supported,
                                        color: Colors.grey, size: 30),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                              ),
                            )
                                : const Center(
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.grey, size: 30),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Product Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Age: $age',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Exchange with Text
                      Center(
                        child: Text(
                          'Exchange with',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: accentColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Exchange User Section - Enhanced user image display
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[200],
                              border: Border.all(color: accentColor.withOpacity(0.3), width: 2),
                            ),
                            child: exchangeUserImagePath.isNotEmpty &&
                                exchangeUserImagePath != 'assets/user_profile_image.png'
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: exchangeUserImagePath.startsWith('assets/')
                                  ? Image.asset(
                                exchangeUserImagePath,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.person,
                                        color: Colors.grey, size: 35),
                                  );
                                },
                              )
                                  : Image.network(
                                exchangeUserImagePath,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print('User image load error: $error');
                                  return const Center(
                                    child: Icon(Icons.person,
                                        color: Colors.grey, size: 35),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                      child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2)
                                      )
                                  );
                                },
                              ),
                            )
                                : Center(
                              child: Icon(Icons.person,
                                  color: accentColor, size: 35),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person_outline,
                                        color: accentColor, size: 16),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        exchangeUserName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.phone_outlined,
                                        color: accentColor, size: 16),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        exchangeUserPhone,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                        color: accentColor, size: 16),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        exchangeUserLocation,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),

                  // Delete Icon Top Right
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: Icon(Icons.delete_outline_rounded,
                          color: deleteIconColor, size: 24),
                      onPressed: onDelete,
                      tooltip: 'Delete Product',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}