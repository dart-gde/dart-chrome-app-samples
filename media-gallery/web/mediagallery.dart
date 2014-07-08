
import 'dart:html';

import 'package:chrome/chrome_app.dart' as chrome;

num gGalleryIndex = 0;
DirectoryReader gGalleryReader = null;
var gDirectories = [];
var gGalleryArray = [];
List<GalleryData> gGalleryData = [];
Element gCurOptGrp = null;
var imgFormats = ['png', 'bmp', 'jpeg', 'jpg', 'gif', 'png', 'svg', 'xbm', 'webp'];
var audFormats = ['wav', 'mp3'];
var vidFormats = ['3gp', '3gpp', 'avi', 'flv', 'mov', 'mpeg', 'mpeg4', 'mp4', 'ogg', 'webm', 'wmv'];

void errorPrintFactory(e, String custom) {
  var sb = new StringBuffer();
  sb.write("$custom : ");
  if (!(e is FileError)) {
    return;
  }
  switch (e.code) {
    case FileError.QUOTA_EXCEEDED_ERR:
      sb.write("QUOTA_EXCEEDED_ERR");
      break;
    case FileError.NOT_FOUND_ERR:
      sb.write("NOT_FOUND_ERR");
      break;
    case FileError.SECURITY_ERR:
      sb.write("SECURITY_ERR");
      break;
    case FileError.INVALID_MODIFICATION_ERR:
      sb.write("INVALID_MODIFICATION_ERR");
      break;
    case FileError.INVALID_STATE_ERR:
      sb.write("INVALID_STATE_ERR");
      break;
    default:
      sb.write("unknown error");
      break;
  }
  print(sb.toString());
  print(e);
}

class GalleryData {
  var _id;
  String path = "";
  num sizeBytes = 0;
  num numFiles = 0;
  num numDirs = 0;
  
  GalleryData(this._id);
}

void clearContentDiv() {
  var content_div = document.querySelector("#content");
  while (content_div.childNodes.length >= 1)
    content_div.childNodes.removeAt(0);
}

void clearList() {
  document.querySelector("#GalleryList").innerHtml = "";
}

void addItem(Entry itemEntry) {
  var opt = document.createElement('option');
  if (itemEntry.isFile) {
    opt.setAttribute("data-fullpath", itemEntry.fullPath);
    
    var mData = chrome.mediaGalleries.getMediaFileSystemMetadata(itemEntry.filesystem);
    opt.setAttribute("data-fsid", mData.galleryId);
  }
  opt.innerHtml = itemEntry.name;
  gCurOptGrp.append(opt);
}

Element addGallery(name, id) {
  var optGrp = document.createElement("optgroup")
    ..setAttribute("label", name)
    ..setAttribute("id", id);
  document.querySelector("#GalleryList").append(optGrp);
  return (optGrp);
}

void scanGallery(List entries) {
  if (entries.length == 0) {
    if (gDirectories.length > 0) {
      DirectoryEntry dir_entry = gDirectories.removeAt(0);
      print('Doing subdir: ' + dir_entry.fullPath);
      gGalleryReader = dir_entry.createReader();
      gGalleryReader.readEntries().then(scanGallery).catchError((e) => errorPrintFactory(e, 'readEntries'));
      return;
    }
    else {
      gGalleryIndex++;
      if (gGalleryIndex < gGalleryArray.length) {
        print("Doing next Gallery: ${gGalleryArray[gGalleryIndex].name}");
        scanGalleries(gGalleryArray[gGalleryIndex]);
      }
      return;
    }
  }

  for (int index = 0; index < entries.length; index++) {
    print(entries[index].name);
    if (entries[index].isFile) {
      addItem(entries[index]);
      gGalleryData[gGalleryIndex].numFiles++;
      entries[index].getMetadata().then((metadata) {
        if (gGalleryData.length > gGalleryIndex) {
          gGalleryData[gGalleryIndex].sizeBytes = metadata.size;
        }
      });
    }
    else if (entries[index].isDirectory) 
      gDirectories.add(entries[index]);
    else
      print("Got something other than a file or directory.");
  }
  gGalleryReader.readEntries().then(scanGallery).catchError((e) => errorPrintFactory(e, 'readMoreEntries'));
}

void scanGalleries(FileSystem fs) {
  var mData = chrome.mediaGalleries.getMediaFileSystemMetadata(fs);
  print("Reading gallery: ${mData.name}");
  
  gCurOptGrp = addGallery(mData.name, mData.galleryId);
  gGalleryData.add(new GalleryData(mData.galleryId));
  gGalleryReader = fs.root.createReader();
  gGalleryReader.readEntries().then(scanGallery).catchError((e) => errorPrintFactory(e, 'readEntries'));
}

void getGalleriesInfo(List<FileSystem> results) {
  clearContentDiv();
  if (results.isNotEmpty) {
    var sb = new StringBuffer();
    sb.write("Gallery count: ${results.length} ( ");
    for (int index = 0; index < results.length; index++) {
      var result = results[index]; 
      var mData = chrome.mediaGalleries.getMediaFileSystemMetadata(result);
      if (mData != null) {
        sb.write(mData.name);
        if (index < results.length - 1)
          sb.write(", ");
        sb.write(" ");
      }
    }
    sb.write(")");
    document.querySelector("#status").innerHtml = sb.toString();
    gGalleryArray = results;
    gGalleryIndex = 0;
    (document.querySelector("#read-button") as ButtonElement).disabled = false;
  }
  else {
    document.querySelector("#status").innerHtml = "No galleries found";
    (document.querySelector("#read-button") as ButtonElement).disabled = true;
  }
}

void main() {
  var win = chrome.app.window.current();
  if (win.toJs().hasProperty("__MGA__bRestart")) {
    if (win.toJs()["__MGA__bRestart"]) {
      print("app was restarted");
      
      chrome.MediaFileSystemsDetails mfsd = new chrome.MediaFileSystemsDetails(interactive: chrome.GetMediaFileSystemsInteractivity.IF_NEEDED);
      chrome.mediaGalleries.getMediaFileSystems(mfsd).then(getGalleriesInfo);
    }
  }
  
  document.querySelector("#gallery-button").onClick.listen((event) {
    chrome.MediaFileSystemsDetails mfsd = new chrome.MediaFileSystemsDetails(interactive: chrome.GetMediaFileSystemsInteractivity.IF_NEEDED);
    chrome.mediaGalleries.getMediaFileSystems(mfsd).then(getGalleriesInfo);  
  });
  
  document.querySelector("#configure-button").onClick.listen((event) {
    chrome.MediaFileSystemsDetails mfsd = new chrome.MediaFileSystemsDetails(interactive: chrome.GetMediaFileSystemsInteractivity.YES);
    chrome.mediaGalleries.getMediaFileSystems(mfsd).then(getGalleriesInfo);  
  });
  
  document.querySelector("#add-folder-button").onClick.listen((event) {
    chrome.mediaGalleries.addUserSelectedFolder().then((chrome.AddUserSelectedFolderResult add_user_selected_folder) => getGalleriesInfo(add_user_selected_folder.mediaFileSystems));
  });
  
  document.querySelector("#read-button").onClick.listen((event) {
    clearContentDiv();
    clearList();
    if (gGalleryArray.length > 0) {
      gGalleryIndex = 0;
      gGalleryData.clear();
      scanGalleries(gGalleryArray[0]);
    }
  });
}
