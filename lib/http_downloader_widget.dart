library http_downloader_widget;

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http_downloader/http_downloader.dart';

class HttpDownloaderWidget extends StatefulWidget {
  const HttpDownloaderWidget({
    super.key,
    required this.url,
    required this.path,
    required this.fileName,
    this.startDownloadWidget,
    this.downloadingWidget,
    this.downloadedWidget,
  });
  final String url;
  final String path;
  final String fileName;
  final Widget Function(Future<void> Function() download)? startDownloadWidget;
  final Widget Function(int progress, String downloadedMB, String contentMB)?
      downloadingWidget;
  final Widget? downloadedWidget;
  @override
  State<HttpDownloaderWidget> createState() => _HttpDownloaderWidgetState();
}

class _HttpDownloaderWidgetState extends State<HttpDownloaderWidget> {
  bool downloading = false;
  double dlProgress = 0;
  int contentLength = 0;
  int downloadedBytes = 0;
  Uint8List? uint8list;
  bool shortcutChecked = true;
  bool downloaded = false;

  Future<void> downloadFile() async {
    downloading = true;
    setState(() {});
    try {
      final bytes = await HttpDownloader.download(widget.url,
          (total, downloaded, progress) {
        contentLength = total;
        downloadedBytes = downloaded;
        dlProgress = progress;

        setState(() {});
      });
      try {
        File("${widget.path}\\${widget.fileName}")
          ..createSync(recursive: true)
          ..writeAsBytesSync(bytes);
        log('File Downloaded: ${widget.path}\\${widget.fileName}');
      } catch (e) {
        log("Error: $e");
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
          return widget.downloadingWidget == null
              ? Column(
                  children: [
                    Text("Downloading... ${dlProgress.toInt().toString()}%",
                        style: const TextStyle(color: Colors.black)),
                    SizedBox(
                      width: 400,
                      child: LinearProgressIndicator(
                        value: dlProgress / 100,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                    ),
                    Text(
                        "${(downloadedBytes / 1048576).toStringAsFixed(2)} MB / ${(contentLength / 1048576).toStringAsFixed(2)} MB",
                        style: const TextStyle(color: Colors.black)),
                  ],
                )
              : widget.downloadingWidget!(
                  dlProgress.toInt(),
                  (downloadedBytes / 1048576).toStringAsFixed(2),
                  (contentLength / 1048576).toStringAsFixed(2));
        } else if (snapshot.data == "download") {
          return widget.startDownloadWidget == null
              ? ElevatedButton(
                  onPressed: () {
                    downloadFile();
                  },
                  child: const Text("Start Download"),
                )
              : widget.startDownloadWidget!(downloadFile);
        } else if (snapshot.data == "downloaded") {
          return widget.downloadedWidget ?? const Text("Downloaded");
        } else {
          return Container();
        }
      },
    );
  }
}
