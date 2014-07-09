
import 'dart:html';
import "dart:convert";

import 'package:chrome/chrome_ext.dart' as chrome;

var desktop_sharing = false;
var local_stream = null;

void onAcceptApproved(desktop_id) {
  print(desktop_id.runtimeType);
  if (desktop_id == null) {
    print('Desktop Capture access rejected.');
    return;
  }
  
  desktop_sharing = true;
  document.querySelector('button').innerHtml = "Disable Capture";
  print("Desktop sharing started.. desktop_id: $desktop_id");
  
  window.navigator.getUserMedia(audio: false, video: { 
    "mandatory": {
      "chromeMediaSource": 'desktop',
      "chromeMediaSourceId": desktop_id,
      "minWidth": 1280,
      "maxWidth": 1280,
      "minHeight": 720,
      "maxHeight": 720
    }
  }).then((MediaStream media_stream) {
    local_stream = media_stream;
    VideoElement video = document.querySelector('video');
    video.src = Url.createObjectUrl(media_stream);
    media_stream.onEnded.listen((Event event) {
      if (desktop_sharing) {
        toggle();
      }
    });
    
  }).catchError((e) => print('getUserMediaError: $e'));
}

void toggle() {
  if (!desktop_sharing) 
    chrome.desktopCapture.chooseDesktopMedia(['screen', 'window'], onAcceptApproved);
  else {
    desktop_sharing = false;
    if (local_stream != null) 
      local_stream.stop();
    local_stream = null;
    document.querySelector('button').innerHtml = "Enable Capture";
    print('Desktop sharing stopped...');
  }
}

void main() {
  document.querySelector("button").onClick.listen((event) {
    toggle();
  });
}