// import 'package:clothing_exchange/utils/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../widget/customElevatedButton.dart';
//
// class ProductDetailsScreen extends StatelessWidget {
//
//   final String title;
//   final String productId;
//   final String age;
//   final String size;
//   final String gender;
//   final String location;
//   final String imageUrl;
//   final String description;
//
//   const ProductDetailsScreen({
//     super.key,
//     required this.title,
//     required this.age,
//     required this.size,
//     required this.gender,
//     required this.location,
//     required this.imageUrl,
//     required this.description, required this.productId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Product Details"),
//         centerTitle: true,
//         backgroundColor: AppColors.primaryColor,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.network(
//                 imageUrl,
//                 height: 250,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => Container(
//                   height: 250,
//                   color: Colors.grey[200],
//                   child: const Center(
//                     child: Text(
//                       'Image not available',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Title
//             Text(
//               title,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//
//             // Details
//             _buildDetailRow('Age', age),
//             _buildDetailRow('Size', size),
//             _buildDetailRow('Gender', gender),
//             _buildDetailRow('Location', location),
//             const SizedBox(height: 20),
//
//             // Description
//             const Text(
//               'Description:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               description,
//               style: const TextStyle(fontSize: 16),
//             ),
//
//             SizedBox(height: 64,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CustomElevatedButton(
//                   textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
//                   borderRadius: 30,
//                   text: 'Exchange Product',
//                   onPressed: (){
//                     ///
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Text(
//         '$label: $value',
//         style: const TextStyle(fontSize: 18, color: Colors.black87),
//       ),
//     );
//   }
// }
//
//
//
//

///todo:: setting up the button nevation and it's functionality

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/Services/chat_service.dart';
import '../../../Utils/colors.dart';
import '../../../controllers/chat_controller.dart';
import '../../widget/customElevatedButton.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String title;
  final String productId;
  final String age;
  final String size;
  final String gender;
  final String location;
  final String imageUrl;
  final String description;

  ProductDetailsScreen({
    super.key,
    required this.title,
    required this.age,
    required this.size,
    required this.gender,
    required this.location,
    required this.imageUrl,
    required this.description,
    required this.productId,
  });

  final MessageController _chetCtrl = MessageController(); // Initialize ChatService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Text(
                          'Image not available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Product Details
            _buildDetailRow('Age', age),
            _buildDetailRow('Size', size),
            _buildDetailRow('Gender', gender),
            _buildDetailRow('Location', location),
            const SizedBox(height: 20),

            // Description
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(description, style: const TextStyle(fontSize: 16)),

            SizedBox(height: 64),

            // Exchange Product Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Obx(()=> _chetCtrl.conversationCreateLoading.value?CircularProgressIndicator(): CustomElevatedButton(
                textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                borderRadius: 30,
                text: 'Exchange Product',
                onPressed: () async {
                  print('ijfakjsdfa');
                  _chetCtrl.conversationExchangeCreate(productId);
                }
              //   try {
              //     String senderId =
              //         "yourSenderId"; // Replace with the actual sender ID
              //     String receiverId =
              //         "yourReceiverId"; // Replace with the actual receiver ID
              //     String message = "I am interested in this product.";
              //
              //     // Call the createConversation method
              //     final response = await chatService.createConversation(
              //       productId: productId,
              //
              //     );
              //
              //     // Fluttertoast.showToast(
              //     //   msg: "Conversation created successfully",
              //     //   toastLength: Toast.LENGTH_SHORT,
              //     //   gravity: ToastGravity.BOTTOM,
              //     // );
              //   } catch (e) {
              //     // Fluttertoast.showToast(
              //     //   msg: "Failed to create conversation",
              //     //   toastLength: Toast.LENGTH_SHORT,
              //     //   gravity: ToastGravity.BOTTOM,
              //     // );
              //   }
              // },
            ),)

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 18, color: Colors.black87),
      ),
    );
  }
}
