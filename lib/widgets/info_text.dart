import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  final String type;
  final String text;

  const InfoText({super.key, required this.type, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$type: ',
          style: TextStyle(
            color: Colors.blueGrey[300],
            fontSize: 16,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.blueGrey[100],
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
