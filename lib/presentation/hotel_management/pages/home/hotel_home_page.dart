import 'package:flutter/material.dart';
import 'package:mobile_lms/presentation/linen_management/pages/count_stock/count_stock_page.dart';
import 'package:mobile_lms/presentation/linen_management/pages/packing/re_tag_page.dart';
import 'package:mobile_lms/presentation/linen_management/pages/registrasi/registrasi_linen_page.dart';

class HotelHomePage extends StatefulWidget {
  const HotelHomePage({super.key});

  @override
  State<HotelHomePage> createState() => _HotelHomePageState();
}

class _HotelHomePageState extends State<HotelHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('LMS Mobile'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  height: double.maxFinite,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GridView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1.6,
                          ),
                          children: [
                            gridItem(
                              title: 'Register Linen',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrasiLinenPage(),
                                  ),
                                );
                              },
                              icon: Icons.add,
                              color: Colors.blue[300]!,
                            ),
                            gridItem(
                              title: 'Count Stock',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CountStockPage(),
                                  ),
                                );
                              },
                              icon: Icons.add,
                              color: Colors.blue[300]!,
                            ),
                            gridItem(
                              title: 'Reject',
                              onTap: () {},
                              icon: Icons.add,
                              color: Colors.blue[300]!,
                            ),
                            gridItem(
                                title: 'Re-Tag',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const ReTagPage(),
                                    ),
                                  );
                                },
                                icon: Icons.add,
                                color: Colors.blue[300]!),
                            gridItem(
                                title: 'QA & QC',
                                onTap: () {},
                                icon: Icons.add,
                                color: Colors.blue[300]!),
                            gridItem(
                                title: 'Packing',
                                onTap: () {},
                                icon: Icons.add,
                                color: Colors.blue[300]!),
                            gridItem(
                                title: 'Delivery-In',
                                onTap: () {},
                                icon: Icons.add,
                                color: Colors.blue[300]!),
                            gridItem(
                                title: 'Delivery-Out',
                                onTap: () {},
                                icon: Icons.add,
                                color: Colors.blue[300]!),
                            gridItem(
                                title: 'Transfer',
                                onTap: () {},
                                icon: Icons.add,
                                color: Colors.blue[300]!),
                            gridItem(
                                title: 'Receive',
                                onTap: () {},
                                icon: Icons.add,
                                color: Colors.blue[300]!),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gridItem(
      {required String title,
      required Function() onTap,
      required IconData icon,
      required Color color,
      required}) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon),
                  const Spacer(),
                  Text(title),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
