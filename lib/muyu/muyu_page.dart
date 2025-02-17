import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_demo/storage/db_storage/db_storage.dart';
import 'package:flutter_demo/storage/sp_storage.dart';
import 'package:uuid/uuid.dart';
import 'models/image_option.dart';
import 'models/audio_option.dart';
import 'models/merit_record.dart';
import 'options/select_audio.dart';
import 'options/select_image.dart';
import 'record_history.dart';
import 'animate_text.dart';
import 'count_panel.dart';
import 'image_panel.dart';

class MuyuPage extends StatefulWidget {
  const MuyuPage({super.key});

  @override
  State<MuyuPage> createState() => _MuyuPageState();
}

class _MuyuPageState extends State<MuyuPage> with AutomaticKeepAliveClientMixin {
  int _counter = 0;
  MeritRecord? _cruRecord;
  List<ImageOption> imageOptions = [
    ImageOption('基础版', 'assets/images/muyu.png', 1, 3),
    ImageOption('尊享版', 'assets/images/muyu2.png', 3, 6),
  ];
  int _activeImageIndex = 0;
  List<AudioOption> audioOptions = [
    AudioOption('音效1', 'muyu_1.mp3'),
    AudioOption('音效2', 'muyu_2.mp3'),
    AudioOption('音效3', 'muyu_3.mp3'),
  ];
  int _activeAudioIndex = 0;
  List<MeritRecord> _records = [];
  final Random _random = Random();
  final Uuid uuid = Uuid();
  AudioPool? pool;

  String get activeImage => imageOptions[_activeImageIndex].src;

  @override
  void initState() {
    super.initState();
    _initAudioPool();
    _initConfig();
  }

  void _initConfig() async {
    Map<String, dynamic> config = await SpStorage.instance.getMuyuConfig();
    _counter = config['counter'] ?? 0;
    _activeImageIndex = config['activeImageIndex'] ?? 0;
    _activeAudioIndex = config['activeAudioIndex'] ?? 0;
    _records = await DbStorage.instance.meritRecordDao.query();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("电子木鱼"),
          actions: [
            IconButton(onPressed: _toHistory, icon: const Icon(Icons.history))
          ],
        ),
        body: Column(
            children: [
              Expanded(
                  child: CountPanel(
                      count: _counter,
                      onTapSwitchAudio: _onTapSwitchAudio,
                      onTapSwitchImage: _onTapSwitchImage
                  )
              ),
              Expanded(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ImagePanel(
                          onTap: _onKnock,
                          image: activeImage
                      ),
                      if (_cruRecord != null) AnimateText(record: _cruRecord!)
                    ],
                  )
              ),
        ])
    );
  }

  void saveConfig() {
    SpStorage.instance.saveMuyuConfig(
        counter: _counter,
        activeImageIndex: _activeImageIndex,
        activeAudioIndex: _activeAudioIndex
    );
  }

  void _initAudioPool() async {
    pool = await FlameAudio.createPool(
        audioOptions[_activeAudioIndex].src,
        maxPlayers: 1
    );
  }

  void _toHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecordHistory(
          records: _records.reversed.toList()
      ))
    );
  }

  void _onTapSwitchAudio() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return AudioOptionPanel(
            audioOptions: audioOptions,
            activeIndex: _activeAudioIndex,
            onSelect: _onSelectAudio,
          );
        }
    );
  }

  void _onTapSwitchImage() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return ImageOptionPanel(
              imageOptions: imageOptions,
              activeIndex: _activeImageIndex,
              onSelect: _onSelectImage,
          );
        }
    );
  }

  _onSelectImage(int value) {
    Navigator.of(context).pop(); // 关闭底部弹窗
    if (value == _activeImageIndex) {
      return;
    }
    setState(() {
      _activeImageIndex = value;
      saveConfig();
    });
  }

  String get activeAudio => audioOptions[_activeAudioIndex].src;

  void _onSelectAudio(int value) async {
    Navigator.of(context).pop();
    if (value == _activeAudioIndex) {
      return;
    }
    _activeAudioIndex = value;
    saveConfig();
    pool = await FlameAudio.createPool(activeAudio, maxPlayers: 1);
  }

  int get knockValue {
    int min = imageOptions[_activeImageIndex].min;
    int max = imageOptions[_activeImageIndex].max;
    return min + _random.nextInt(max + 1 - min);
  }

  void _onKnock() {
    pool?.start();
    setState(() {
      String id = uuid.v4();
      _cruRecord = MeritRecord(
          id,
          DateTime.now().millisecondsSinceEpoch,
          knockValue,
          activeImage,
          audioOptions[_activeAudioIndex].name
      );
      _counter += _cruRecord!.value;
      saveConfig();
      DbStorage.instance.meritRecordDao.insert(_cruRecord!);
      _records.add(_cruRecord!);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
