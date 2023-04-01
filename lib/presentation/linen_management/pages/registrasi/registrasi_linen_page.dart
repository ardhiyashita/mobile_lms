import 'package:flutter/material.dart';

class RegistrasiLinenPage extends StatefulWidget {
  const RegistrasiLinenPage({Key? key}) : super(key: key);

  @override
  State<RegistrasiLinenPage> createState() => _RegistrasiLinenPageState();
}

class _RegistrasiLinenPageState extends State<RegistrasiLinenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Registrasi Linen'),
      ),
      body: ListView.builder(
        itemCount: 50,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Template ${index + 1}'),
            trailing: const Icon(
              Icons.chevron_right,
              size: 16,
            ),
            onTap: (){
              
            },
          );
        },
      ),
    );
  }
}
