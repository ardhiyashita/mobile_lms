import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uhf_c72_plugin_2/tag_epc.dart';
import 'package:uhf_c72_plugin_2/uhf_c72_plugin.dart';

import 'package:mobile_lms/presentation/linen_management/widgets/bottom_navbar_scan.dart';

class ReTagPage extends StatefulWidget {
  const ReTagPage({super.key});

  @override
  State<ReTagPage> createState() => _ReTagPageState();
}

class _ReTagPageState extends State<ReTagPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _oldTagController = TextEditingController();
  final _newTagController = TextEditingController();
  // final String _platformVersion = 'Unknown';
  bool _isReading = false;
  // final bool _isEmptyTags = false;
  bool _isConnected = false;

  TagEpc? epcTaglist;
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
    await UhfC72Plugin.setWorkArea('2');
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
      epcTaglist = TagEpc.parseTags(result).first;
      _oldTagController = TextEditingController(text: epcTaglist?.epc);
      _isReading = false;
    });
  }

  void updateIsConnected(dynamic isConnected) {
    log('connected $isConnected');
    _isConnected = isConnected;
    debugPrint('is connected ==> $isConnected');
  }

  void startReadTagEpc() async {
    bool? status = await UhfC72Plugin.startSingle;
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
      epcTaglist?.toMap().clear();
    });
  }

  SnackBar snackbar({required String content}) {
    return SnackBar(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Re-Tag/Re-Serial'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: false,
                        controller: _oldTagController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Must not empty';
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Old Tag',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          // contentPadding: const EdgeInsets.symmetric(
                          //   vertical: 18,
                          //   horizontal: 15,
                          // ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        autofocus: false,
                        controller: _newTagController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Must not empty';
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'New Tag',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          // contentPadding: const EdgeInsets.symmetric(
                          //   vertical: 18,
                          //   horizontal: 15,
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    // if (_formKey.currentState!.validate()) {
                    //   Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(
                    //       builder: (context) => const HomePage(),
                    //     ),
                    //     (route) => false,
                    //   );
                    // }
                  },
                  borderRadius: BorderRadius.circular(15.0),
                  child: Ink(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8.0,
                              color: Colors.black12,
                              offset: Offset(0, 3),
                            ),
                          ]),
                      padding: const EdgeInsets.all(20.0),
                      child: const Center(
                        child: Text('Save'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbarScan(
          isReading: _isReading,
          startOrStop: () {
            startReadTagEpc();
          },
          reset: () {
            clearEpcList();
          }),
    );
  }
}
