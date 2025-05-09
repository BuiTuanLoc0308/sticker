import 'package:flutter/material.dart';

class StickerSearch extends StatelessWidget {
  const StickerSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenSize = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 40,
      child: TextFormField(
        onTapOutside: (PointerDownEvent event) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: screenSize * 0.01),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          hintText: 'Search stickers',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: screenSize * 0.03),
            child: const Icon(Icons.search),
          ),
          prefixIconConstraints: const BoxConstraints(),
        ),
      ),
    );
  }
}
