// ignore_for_file: avoid_print, unnecessary_this, prefer_const_constructors, sort_child_properties_last, duplicate_ignore

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cronometro extends StatefulWidget {
  const Cronometro({super.key});

  @override
  State<Cronometro> createState() => _CronometroState();
}

class _CronometroState extends State<Cronometro> {
  int milisegundo = 0;
  bool estaCorriendo = false;
  late Timer timer;
  List laps = [];

  void iniciarCronometro() {
    if (!estaCorriendo) {
      timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        this.milisegundo += 11;
        setState(() {});
      });
      estaCorriendo = true;
    }
  }

  void detenerCronometro() {
    if (estaCorriendo) {
      timer.cancel();
      estaCorriendo = false;
      setState(() {});
    }
  }

  void reiniciarTiempo() {
    setState(() {
      this.milisegundo = 0;
      laps.clear();
    });
  }

  void vueltaCronometro() {
    if (laps.isNotEmpty) {
      String lap = formatearDiferenciaTiempo(laps.last);
      setState(() {
        laps.add(lap);
      });
    } else {
      String lap = formatearTiempo();
      setState(() {
        laps.add(lap);
      });
    }
  }

  String formatearDiferenciaTiempo(String lapAnterior) {
    Duration duracionAnterior = Duration(
      hours: int.parse(lapAnterior.substring(0, 2)),
      minutes: int.parse(lapAnterior.substring(3, 5)),
      seconds: int.parse(lapAnterior.substring(6, 8)),
      milliseconds: int.parse(lapAnterior.substring(9, 11)) * 10,
    );

    Duration duracionActual = Duration(milliseconds: this.milisegundo);
    Duration diferencia = duracionActual - duracionAnterior;

    String dosValores(int valor) {
      return valor >= 10 ? "$valor" : "0$valor";
    }

    String horas = dosValores(diferencia.inHours);
    String minutos = dosValores(diferencia.inMinutes.remainder(60));
    String segundos = dosValores(diferencia.inSeconds.remainder(60));
    String milisegundos =
        dosValores(diferencia.inMilliseconds.remainder(1000)).substring(0, 2);

    return "$horas:$minutos:$segundos:$milisegundos";
  }

  String formatearTiempo() {
    Duration duration = Duration(milliseconds: this.milisegundo);

    String dosValores(int valor) {
      return valor >= 10 ? "$valor" : "0$valor";
    }

    String horas = dosValores(duration.inHours);
    String minutos = dosValores(duration.inMinutes.remainder(60));
    String segundos = dosValores(duration.inSeconds.remainder(60));
    String milisegundos =
        dosValores(duration.inMilliseconds.remainder(1000)).substring(0, 2);
    return "$horas:$minutos:$segundos:$milisegundos";
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatearTiempo(),
          style: const TextStyle(fontSize: 50, color: Colors.black),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CupertinoButton(
                // ignore: sort_child_properties_last
                child: Icon(
                  Icons.not_started_outlined,
                  size: 60,
                  color: Colors.black,
                ),
                onPressed: iniciarCronometro),
            CupertinoButton(
                child: Icon(
                  Icons.stop_circle_outlined,
                  size: 60,
                  color: Colors.black,
                ),
                onPressed: detenerCronometro),
            CupertinoButton(
                child: Icon(
                  Icons.restart_alt_outlined,
                  size: 60,
                  color: Colors.black,
                ),
                onPressed: () {
                  reiniciarTiempo();
                }),
            CupertinoButton(
                child: Icon(
                  Icons.redo_outlined,
                  size: 60,
                  color: Colors.black,
                ),
                onPressed: () {
                  vueltaCronometro();
                }),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          height: 300,
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListView.builder(
              itemCount: laps.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Vuelta ${index + 1}",
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16.0),
                      ),
                      Text(
                        "${laps[index]}",
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16.0),
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
