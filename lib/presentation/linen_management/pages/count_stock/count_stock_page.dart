import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_lms/presentation/linen_management/widgets/bottom_navbar_scan.dart';
import 'package:uhf_c72_plugin_2/tag_epc.dart';
import 'package:uhf_c72_plugin_2/uhf_c72_plugin.dart';

class CountStockPage extends StatefulWidget {
  const CountStockPage({super.key});

  @override
  State<CountStockPage> createState() => _CountStockPageState();
}

class _CountStockPageState extends State<CountStockPage> {
  final String _platformVersion = 'Unknown';
  bool _isReading = false;
  final bool _isEmptyTags = false;
  bool _isConnected = false;

  List<TagEpc> _epcTaglist = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      await UhfC72Plugin.platformVersion;
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
      ScaffoldMessenger.of(context).showSnackBar(
        snackbar(content: 'Failed to get platform version.'),
      );
    }
    UhfC72Plugin.connectedStatusStream
        .receiveBroadcastStream()
        .listen(updateIsConnected);
    UhfC72Plugin.tagsStatusStream.receiveBroadcastStream().listen(updateTags);
    _isConnected = (await UhfC72Plugin.connect)!;
    await UhfC72Plugin.setWorkArea('1');
    await UhfC72Plugin.setPowerLevel('30');

    if (!mounted) return;

    if (_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackbar(content: 'Reader connection Success'),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        snackbar(content: 'Reader Connection Failed'),
      );
    }
  }

  final List<String> _logs = [];
  void log(String msg) {
    setState(() {
      _logs.add(msg);
    });
  }

  void updateTags(dynamic result) {
    log('update tags');
    setState(() {
      _epcTaglist = TagEpc.parseTags(result);
      count = _epcTaglist.length;
    });
  }

  void updateIsConnected(dynamic isConnected) {
    log('connected $isConnected');
    _isConnected = isConnected;
    debugPrint('is connected ==> $isConnected');
  }

  void startReadTagEpc() async {
    bool? status = await UhfC72Plugin.startContinuous;
    setState(() {
      _isReading = true;
    });
    log('Start: $status');
  }

  void stopReadTagEpc() async {
    bool? isStopped = await UhfC72Plugin.stop;
    setState(() {
      _isReading = false;
    });
    log('Stop $isStopped');
  }

  void clearEpcList() async {
    bool? isCleared = await UhfC72Plugin.clearData;
    log('Clear $isCleared');
    setState(() {
      _epcTaglist.clear();
    });
  }

  SnackBar snackbar({required String content}) {
    return SnackBar(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      // width: double.infinity,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      content: Text(content),
    );
  }

  @override
  void dispose() async {
    Future.microtask(() async => await UhfC72Plugin.close);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _epcTaglist
    //     .add(TagEpc(count: '10', epc: '5SETF7656GGY5578', id: '', rssi: ''));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Count Stock'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.fact_check_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total EPC :'),
                  Text(
                    '$count',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: _epcTaglist.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      _epcTaglist[index].epc,
                      style: TextStyle(
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbarScan(
        isReading: _isReading,
        startOrStop: () {
          if (_isReading) {
            stopReadTagEpc();
          } else {
            startReadTagEpc();
          }
        },
        reset: () {
          clearEpcList();
        },
      ),
    );
  }
}
