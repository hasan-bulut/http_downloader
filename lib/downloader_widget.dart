library downloader_widget;

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http_downloader/http_downloader.dart';

class DownloaderWidget extends StatefulWidget {
  const DownloaderWidget({super.key, required this.url, required this.path});
  final String url;
  final String path;
  @override
  State<DownloaderWidget> createState() => _DownloaderWidgetState();
}

class _DownloaderWidgetState extends State<DownloaderWidget> {
  bool downloading = false;
  double dlProgress = 0;
  int contentLength = 0;
  int downloadedBytes = 0;
  Uint8List? uint8list;
  bool shortcutChecked = true;
  bool downloaded = false;

  Future<void> donwloadFile() async {
    downloading = true;
    setState(() {});
    try {
      final bytes = await HttpDownloader.download(widget.url, (total, downloaded, progress) {
        contentLength = total;
        downloadedBytes = downloaded;
        dlProgress = progress;

        setState(() {});
      });
      try {
        File(widget.path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(bytes);
        print('File Downloaded: ${widget.path}');
      } catch (e) {
        print("Error: $e");
      }
    } catch (e) {
      log('$e');
    }
    downloading = false;
    downloaded = true;
    setState(() {});
  }

  Future<String> checkDownload() async {
    if (downloaded) {
      return "downloaded";
    } else {
      if (downloading) {
        return "downloading";
      } else {
        donwloadFile();
        return "download";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkDownload(),
      builder: (_, snapshot) {
        if (snapshot.data == "downloading") {
          return Column(
            children: [
              Text("Downloading... ${dlProgress.toInt().toString()}%", style: TextStyle(color: Colors.black)),
              SizedBox(
                width: 400,
                child: LinearProgressIndicator(
                  value: dlProgress / 100,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
              ),
              Text("${(downloadedBytes / 1048576).toStringAsFixed(2)} MB / ${(contentLength / 1048576).toStringAsFixed(2)} MB", style: TextStyle(color: Colors.black)),
            ],
          );
        } else if (snapshot.data == "downloaded") {
          return Text("Downloaded");
        } else {
          return Container();
        }
      },
    );
  }
}
