import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Netimage extends StatelessWidget {
  const Netimage({ required this.imageUrl, this.height, this.width,super.key,});
  final String imageUrl;
  final String defaultImageUrl = 'assets/images/error.png';
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    
    print('$baseUrl$imageUrl'); // Get the base URL
    return Image.network(
      "$baseUrl$imageUrl",
      height: height,
      width: width,
      fit: BoxFit.cover, // Adjusts the image fit as needed
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child; // Image is loaded
        return Container(
          height: height,
          width: width,
          child: Center(
              child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          )),
        );
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        // If the image fails to load, display the default image
        return Image.asset(
          defaultImageUrl,
          height: height,
          width: width,
          fit: BoxFit.cover, // Adjusts the image fit as needed
        );
      },
    );
  }
}
