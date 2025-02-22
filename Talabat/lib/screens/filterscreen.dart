
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:talabat/widgets/filterbutton.dart';

class FilterScreen extends StatelessWidget {
   final List<String> filters = [
    "All",
    "Laptops",
    "PCs",
    "Phones"
    "Mouses",
    "Headphones",
    "Keyboards",
    "Speakers"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          // Scrollable Tab
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            color: Colors.grey[200],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((filter) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: FilterButton(label: filter),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Product List",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
