import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/merit_record.dart';

class RecordHistory extends StatelessWidget {
  final List<MeritRecord> records;
  DateFormat dateFormat = DateFormat('yyyy年MM月dd日 HH:mm:ss');
  
  RecordHistory({
    super.key,
    required this.records
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView.builder( // ListView 支持视图滑动
        itemBuilder: _buildItem,
        itemCount: records.length,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() =>
      AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          '功德记录',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      );

  Widget? _buildItem(BuildContext context, int index) {
    MeritRecord merit = records[index];
    String date = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(merit.timestamp));
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        backgroundImage: AssetImage(merit.image),
      ), // 左侧组件，使用CircleAvatar展示圆形图形
      title: Text('功德 +${merit.value}'),
      subtitle: Text(merit.audio),
      trailing: Text(
        date,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}