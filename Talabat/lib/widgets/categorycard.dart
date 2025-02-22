import 'package:flutter/material.dart';
import 'package:talabat/models/section.dart';
import 'package:talabat/pages/filterByCategory.dart';

import 'package:talabat/utils/constants.dart';
import 'package:talabat/utils/theme.dart';
import 'package:talabat/widgets/netImage.dart';

class CategoryCard extends StatelessWidget {
  final Section section;
  late VoidCallback onTap;

  CategoryCard({super.key, required this.section});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 100,
      child: GestureDetector(
        onTap: () {
          print(section.id);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Filterbycategory(section_id: section.id,)));
        },
        child: Card(
          color: primarycolor,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                section.name,
                style: theme.textTheme.bodySmall,
                 softWrap: false,
    overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight:
                        Radius.circular(10)), // Adjust the radius as needed
                child: Netimage(
                  imageUrl: section.image, // Your image URL
                  width: 125,
                  height: 75,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
