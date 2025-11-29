import 'package:flutter/material.dart';

import '../../../constants.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
    required this.inicial,
    required this.nombreCompleto,
  }) : super(key: key);

  final String inicial;
  final String nombreCompleto;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 115,
          width: 115,
          child: CircleAvatar(
            backgroundColor: kPrimaryColor,
            child: Text(
              inicial.toUpperCase(),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          nombreCompleto,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
