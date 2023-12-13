import 'package:flutter/material.dart';
import 'package:http_downloader/downloader_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DownloaderWidget(
              url: "https://github.githubassets.com/assets/mona-loading-dark-static-8b35171e5d6c.svg",
              path: "C:\\Users\\Hasan\\Desktop\\deneme.svg",
            ),
          ],
        ),
      ),
    );
  }
}
