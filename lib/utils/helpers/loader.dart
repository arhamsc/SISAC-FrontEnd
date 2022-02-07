import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SISACLoader extends StatelessWidget {
  final double size;
  final _images = [
    "assets/images/sisac_loader_img/1.png",
    "assets/images/sisac_loader_img/2.png",
    "assets/images/sisac_loader_img/3.png",
    "assets/images/sisac_loader_img/4.png",
    "assets/images/sisac_loader_img/5.png",
    "assets/images/sisac_loader_img/6.png",
    "assets/images/sisac_loader_img/7.png",
    "assets/images/sisac_loader_img/8.png",
    "assets/images/sisac_loader_img/9.png",
  ];

  SISACLoader({Key? key, this.size = 100}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SpinKitCubeGrid(
      itemBuilder: (context, index) {
        return Image.asset(_images[index]);
      },
      size: size,
      duration: const Duration(milliseconds: 900),
    );
  }
}
