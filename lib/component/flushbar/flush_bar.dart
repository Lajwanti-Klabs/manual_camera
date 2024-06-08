import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class  FlushBarMessage{
  void flushBarMessage({required String message}) {
     Flushbar(
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(10),

          backgroundGradient: LinearGradient(
            colors: [
              Colors.green.shade500,
              Colors.green.shade300,
              Colors.green.shade100
            ],
            stops: const [0.4, 0.7, 1],
          ),
          boxShadows: const [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(3, 3),
              blurRadius: 3,
            ),
          ],
          dismissDirection: FlushbarDismissDirection.HORIZONTAL,
          forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
          message: message,
          messageSize: 17,
        ).show(context!);
  }
}
