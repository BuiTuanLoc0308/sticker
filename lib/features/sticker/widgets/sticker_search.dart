import 'package:flutter/material.dart';

class StickerSearch extends StatelessWidget {
  const StickerSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(30),
          ),
          hintText: 'Search stickers',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 0, left: 10),
            child: const Icon(Icons.search),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0),
        ),
      ),
    );
  }
}
