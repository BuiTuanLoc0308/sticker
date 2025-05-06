import 'package:flutter/material.dart';

class StickerSearch extends StatelessWidget {
  const StickerSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 40,
      child: TextFormField(
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: screenSize * 0.01),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(30),
          ),
          hintText: 'Search stickers',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: screenSize * 0.03),
            child: const Icon(Icons.search),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0),
        ),
      ),
    );
  }
}
