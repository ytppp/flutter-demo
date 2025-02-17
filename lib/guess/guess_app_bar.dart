import 'package:flutter/material.dart';

class GuessAppBar extends StatelessWidget implements PreferredSizeWidget {

  final VoidCallback onCheck;
  final TextEditingController controller;

  const GuessAppBar({
    super.key,
    required this.onCheck,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Icon(Icons.menu, color: Colors.black,), // 左侧
      actions: [ // 右侧列表
        IconButton(
            onPressed: onCheck,
            icon: Icon(Icons.run_circle_outlined, color: Colors.blue,)
        ),
      ],
      title: TextField( // 中间部分
        controller: controller,
        keyboardType: TextInputType.number, // 键盘类型：数字
        decoration: InputDecoration( // 装饰
            filled: true, // 填充
            fillColor: Color(0xffF3F6F9), // 填充颜色
            constraints: BoxConstraints(maxHeight: 35), // 约束信息
            border: UnderlineInputBorder( // 边框信息
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(6))
            ),
            hintText: "输入0-99数字", // 提示文本
            hintStyle: TextStyle(fontSize: 14) // 提示文本样式
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}