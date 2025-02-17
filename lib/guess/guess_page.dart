import 'package:flutter/material.dart';
import 'package:flutter_demo/storage/sp_storage.dart';
import 'guess_app_bar.dart';
import 'dart:math';
import 'result_notice.dart';

class GuessPage extends StatefulWidget {
  const GuessPage({super.key});

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _value = 0;
  bool _guessing = false;
  bool _isGuessOver = false;
  bool? _isBig;
  final Random _random = Random();
  final TextEditingController _guessCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initConfig();
  }

  void _initConfig() async {
    Map<String, dynamic> config = await SpStorage.instance.getGuessConfig();
    _guessing = config['guessing'] ?? false;
    _isGuessOver = config['isGuessOver'] ?? false;
    _value = config['value'] ?? 0;
  }

  void _generateRandomValue() {
    setState(() {
      _guessing = true;
      _isGuessOver = false;
      _value = _random.nextInt(100); // value is >= 0 and < 99
      SpStorage.instance.saveGuessConfig(
          guessing: _guessing,
          value: _value,
          isGuessOver: _isGuessOver
      );
      print(_value);
    });
  }

  // Widget _buildResultNotice(Color color, String info) {
  //   return Expanded(
  //       child: Container(
  //         alignment: Alignment.center,
  //         color: color,
  //         child: Text(
  //           info,
  //           style: TextStyle(
  //               fontSize: 54,
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold
  //           ),
  //         ),
  //       )
  //   );
  // }

  void _onCheck() {
    print("===$_value===${_guessCtrl.text}===");
    int? guessValue = int.tryParse(_guessCtrl.text);

    if (guessValue == null || !_guessing) {
      return;
    }

    if (guessValue == _value) {
      setState(() {
        _isGuessOver = true;
        _isBig = null;
        _guessing = false;
      });
      SpStorage.instance.saveGuessConfig(
          guessing: _guessing,
          value: _value,
          isGuessOver: _isGuessOver
      );
      return;
    }

    setState(() {
      _guessCtrl.text = '';
      _isBig = guessValue > _value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GuessAppBar(
        onCheck: _onCheck,
        controller: _guessCtrl,
      ),
      body: Stack( // 多个组件叠放
        children: [
          if (_isBig != null)
            Column(
              children: [
                if (_isBig!)
                  // _buildResultNotice(Colors.redAccent, '大了',),
                  ResultNotice(color: Colors.redAccent, info: '大了'),
                Spacer(),
                if (!_isBig!)
                  // _buildResultNotice(Colors.blueAccent, '小了',),
                  ResultNotice(color: Colors.blueAccent, info: '小了'),
              ],
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (!_guessing)
                  if (!_isGuessOver) const Text('点击右下角生成随机数值'),
                  if (_isGuessOver) Text('猜对了,数字是 $_value，游戏结束'),
                if (_guessing) const Text("**"),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _guessing ? null : _generateRandomValue,
        backgroundColor: _guessing ? Colors.grey : Colors.blue,
        tooltip: 'Random',
        child: const Icon(Icons.generating_tokens_outlined),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _guessCtrl.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
