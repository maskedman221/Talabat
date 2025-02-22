import 'package:flutter/material.dart';
import 'package:talabat/models/store.dart';
import 'package:talabat/pages/filterByStore.dart';
import 'package:talabat/utils/constants.dart';
import 'package:talabat/utils/theme.dart';
import 'package:talabat/widgets/netImage.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  late VoidCallback onTap;

  StoreCard({super.key, required this.store});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FilterbyStore( store_id: store.id,)));},
      child: SizedBox(
        height: 160,
        width: double.infinity,
        child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: primarycolor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Netimage(
                  imageUrl: store.image,
                  width: double.infinity,
                  height: 100,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    store.name,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
