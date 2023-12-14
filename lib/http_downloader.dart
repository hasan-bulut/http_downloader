library http_downloader;

import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

typedef DownloadProgress = void Function(
    int total, int downloaded, double progress);

class HttpDownloader {
  static Future<Uint8List> download(
      String url, DownloadProgress downloadProgress) async {
    final compelter = Completer<Uint8List>();
    final client = http.Client();
    final request = http.Request('GET', Uri.parse(url));
    final response = client.send(request);

    int downloadedBytes = 0;
    List<List<int>> chunkList = [];

    response.asStream().listen((http.StreamedResponse streamedResponse) {
      streamedResponse.stream.listen(
        (chunk) {
          final contentLength = streamedResponse.contentLength ?? 0;
          final progress = (downloadedBytes / contentLength) * 100;
          downloadProgress(contentLength, downloadedBytes, progress);

          chunkList.add(chunk);
          downloadedBytes += chunk.length;
        },
        onDone: () {
          final contentLength = streamedResponse.contentLength ?? 0;
          final progress = (downloadedBytes / contentLength) * 100;
          downloadProgress(contentLength, downloadedBytes, progress);

          int start = 0;
          final bytes = Uint8List(contentLength);

          for (var chunk in chunkList) {
            bytes.setRange(start, start + chunk.length, chunk);
            start += chunk.length;
          }

          compelter.complete(bytes);
        },
        onError: (error) => compelter.completeError(error),
      );
    });

    return compelter.future;
  }
}
