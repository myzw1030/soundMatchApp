import 'package:flutter/material.dart';

class SoundButton extends StatelessWidget {
  const SoundButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('aa');
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8AF3A),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
