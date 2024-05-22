import 'package:flutter/material.dart';

class DownloadButton extends StatelessWidget {
  final Function onDownload;
  final bool isLoading;

  const DownloadButton({required this.onDownload, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isLoading ? null : () => onDownload(),
      height: 50,
      color: Color(0xFF0b512d),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Center(
        child: Text(
          "Descargar Archivo",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
