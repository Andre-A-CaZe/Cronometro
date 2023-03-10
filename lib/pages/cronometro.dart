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
  List<Duration> laps = [];
  Duration tiempoPrev = Duration.zero;

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
      tiempoPrev = Duration.zero;
      laps.clear();
    });
  }

  void vueltaCronometro() {
    if (estaCorriendo) {
      Duration tiempoActual = Duration(milliseconds: milisegundo);
      laps.insert(0, tiempoActual - tiempoPrev);
      tiempoPrev = tiempoActual;
    }
  }

  String formatearTiempo(Duration d) {
    String dosValores(int valor) {
      return valor >= 10 ? "$valor" : "0$valor";
    }

    String horas = dosValores(d.inHours);
    String minutos = dosValores(d.inMinutes.remainder(60));
    String segundos = dosValores(d.inSeconds.remainder(60));
    String milisegundos =
        dosValores(d.inMilliseconds.remainder(1000)).substring(0, 2);
    return "$horas:$minutos:$segundos:$milisegundos";
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Duration> lista = List.from(laps);
    lista.insert(0, Duration(milliseconds: milisegundo) - tiempoPrev);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatearTiempo(Duration(milliseconds: milisegundo)),
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
                  Icons.flag,
                  size: 60,
                  color: Colors.black,
                ),
                onPressed: () {
                  vueltaCronometro();
                }),
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
              itemCount: lista.length,
              itemBuilder: (context, index) {
                Duration tv = lista[index];
                Duration ta = Duration(
                    milliseconds: lista.sublist(index).fold<int>(
                        0,
                        (previousValue, element) =>
                            previousValue + element.inMilliseconds));
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Vuelta ${lista.length - index}",
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16.0),
                      ),
                      Text(
                        formatearTiempo(tv),
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16.0),
                      ),
                      Text(
                        formatearTiempo(ta),
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
