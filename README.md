# Http Downloader

Simply download your files from the internet and save them to the desired location on your device.

Download your files from the internet and see the progress while downloading. Edit the progress bar as you wish. You can adjust the view before the download starts and after the download is complete. If you do not set it, it will remain as default.

## Usage

1. Use `HttpDownloaderWidget()` where the download progress will be.
3. HttpDownloaderWidget(<br>
`url:` (Link of the file you want to download `ex. https://google.com/example.png`),<br>
`path:` (Location to save the file `ex. C:\\Users\\YourName\\Desktop`),<br>
`fileName:` (The name to save the file `ex. image.png`)<br>
):

## Example

If you do this example, it will have the default view.
```
HttpDownloaderWidget(
  url: "https://google.com/example.png",
  path: "C:\\Users\\YourName\\Desktop",
  fileName: "image.png"
)
```

You can customize it this way.
```
HttpDownloaderWidget(
  url: "https://google.com/example.png",
  path: "C:\\Users\\YourName\\Desktop",
  fileName: "image.png"
  startDownloadWidget: (download) {
    return ElevatedButton(
      onPressed: download,
      child: Text("Download"),
    );
  },
  downloadingWidget: (progress, downloadedMB, contentMB) {
    return Column(
      children: [
        Text("Downloading.. ${progress.toString()}%", style: TextStyle(color: Colors.black)),
        SizedBox(
          width: 400,
          child: LinearProgressIndicator(
            value: progress / 100,
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
        ),
        Text("$downloadedMB MB / $contentMB MB", style: TextStyle(color: Colors.amber)),
      ],
    );
  },
  downloadedWidget: const Text("Download Completed"),
)
```
