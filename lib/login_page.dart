// ignore_for_file: avoid_print

import 'package:cronometro/pages/cronometro.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          ListTile(
            title: const Text('Cronometro'),
            subtitle: const Text('Para medir el Tiempo'),
            trailing: const Icon(Icons.arrow_forward_ios),
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                '⏱️',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
            onTap: () {
              final ruta = MaterialPageRoute(
                builder: (_) => const Cronometro(),
              );
              Navigator.push(context, ruta);
            },
          ),
        ],
      ),
    );
  }
}
