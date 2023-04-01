import 'package:flutter/material.dart';

class BottomNavbarScan extends StatefulWidget {
  final bool isReading;
  final Function() startOrStop;
  final Function() reset;
  const BottomNavbarScan({super.key, required this.isReading, required this.startOrStop, required this.reset});

  @override
  State<BottomNavbarScan> createState() => _BottomNavbarScanState();
}

class _BottomNavbarScanState extends State<BottomNavbarScan> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        child: BottomAppBar(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(children: [
              Expanded(
                flex: 4,
                child: Material(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: widget.startOrStop,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: double.maxFinite,
                      // padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          widget.isReading ? 'Stop' : 'Start Reading',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 1,
                child: Material(
                  borderRadius: BorderRadius.circular(15),
                  child: Tooltip(
                    message: 'Reset list',
                    child: InkWell(
                      onTap: widget.reset,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: double.maxFinite,
                        // padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.blue,
                            )),
                        child: const Center(
                          child: Icon(
                            Icons.refresh,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      );
  }
}