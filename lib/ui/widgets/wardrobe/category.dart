import 'package:flutter/material.dart';

class WarderobeCategory extends StatelessWidget {
  final String text;
  final Image image;
  final bool isSelected;
  final VoidCallback onTap;

  const WarderobeCategory({Key? key, required this.text, required this.image, required this.isSelected, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        // Padding top
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: image.image,
                  fit: BoxFit.cover,
                ),
                border: isSelected ? Border.all(color: Colors.blue, width: 3) : null,
                boxShadow: isSelected
                    ? [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1)]
                    : [],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w100),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
