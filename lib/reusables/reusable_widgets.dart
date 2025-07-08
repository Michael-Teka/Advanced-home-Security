import 'package:flutter/material.dart';

// Custom SN Input Field with Icon
class InputField extends StatelessWidget {
  const InputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



  

  class AppBars extends StatelessWidget {
  const AppBars({
    super.key,
    required this.isDarkMode,
    required this.name,
  });
  final String name;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.grey[900]
                : const Color.fromARGB(91, 255, 255, 255),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [],
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(width: 93),
        Text(
          name,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}