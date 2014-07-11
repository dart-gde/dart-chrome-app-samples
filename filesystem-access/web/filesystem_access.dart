import 'dart:html';
import "dart:async";

import 'package:chrome/chrome_app.dart' as chrome;

import "dnd.dart";

TextAreaElement textarea = null;
ButtonElement saveFileButton = null;

void errorHandler(message) {
  window.console.error(message);
}

void displayEntryData(Entry entry) {
  InputElement file_path = document.querySelector("#file_path");
  SpanElement file_size = document.querySelector("#file_size");
  if (entry.isFile) {
    file_path.value = "";
    entry.getMetadata().then((Metadata metadata) {
      file_size.text = metadata.size.toString();
    }).catchError((e) => print("getMetadata error: $e"));

    try {
      chrome.fileSystem.getDisplayPath(entry).then((String path) {
        file_path.value = path;
      }).catchError((e) => print("$e"));
    }
    catch (e) {
      print("bug getDisplayPath $e");
    }
  }
  else {
    textarea.innerHtml = "";
    file_path.value = entry.fullPath;
    file_size.text = "N/A";
  }
}

Future<String> readAsText(FileEntry entry) {
  Completer completer = new Completer();
  entry.file().then((File file) {
    var reader = new FileReader();
    reader.onError.listen(errorHandler);
    reader.onLoadEnd.listen((ProgressEvent progress_event) {
      completer.complete((progress_event.target as FileReader).result);
    });
    reader.readAsText(file);
  });
  return (completer.future);
}

void onDrop(DataTransfer data_transfer) {
  Entry entry = null;
  for (int i = 0; i < data_transfer.items.length; i++) {
    var item = data_transfer.items[i];
    if ((item.kind == "file" 
        && item.type.startsWith("text/"))
        || item.type == "") {
      entry = item.getAsEntry();
      break;
    }
  }
  if (entry != null)
    displayEntryData(entry);
  OutputElement output = document.querySelector("output");;
  if (entry == null || entry.isDirectory) {
    output.value = "Sorry. That's not a text file.";
    return;
  }
  else if (entry.isFile) {
    output.value = "";
    readAsText(entry).then((String result) {
      textarea.innerHtml = result;
    });
    saveFileButton.disabled = false;
  }
}

void main() {
  textarea = document.querySelector("textarea");
  saveFileButton = document.querySelector("#save_file");
  var dnd = new DnDFileController("body", onDrop);
}