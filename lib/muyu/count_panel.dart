import 'package:flutter/material.dart';

class CountPanel extends StatelessWidget {
  const CountPanel({
    super.key,
    required this.count,
    required this.onTapSwitchAudio,
    required this.onTapSwitchImage
  });

  final int count;
  final VoidCallback onTapSwitchAudio;
  final VoidCallback onTapSwitchImage;

  @override
  Widget build(BuildContext context) {
    // 按钮样式
    final ButtonStyle btnStyle = ElevatedButton.styleFrom(
        minimumSize: const Size(36, 36), // 最小尺寸
        padding: EdgeInsets.zero, // 边距
        backgroundColor: Colors.green,
        elevation: 0,
        iconColor: Colors.white
    );

    return Stack(
      children: [
        Center(
          child: Text(
            '功德数：$count',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Positioned(
            right: 10,
            top: 10,
            child: Wrap(
              spacing: 8,
              direction: Axis.vertical,
              children: [
                ElevatedButton(
                  style: btnStyle,
                  onPressed: onTapSwitchAudio,
                  child: Icon(Icons.music_note_outlined),
                ),
                ElevatedButton(
                  style: btnStyle,
                  onPressed: onTapSwitchImage,
                  child: Icon(Icons.image),
                ),
              ],
            )
        )
      ],
    );
  }
}