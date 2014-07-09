import 'dart:html';

import "package:chrome/chrome_app.dart" as chrome;

void main() {
  document.querySelector("button").onClick.listen((MouseEvent mouse_event) {
    window.navigator.getUserMedia(audio: true, video: true).then((MediaStream media_stream) {
      VideoElement video = document.querySelector("video");
      video.src = Url.createObjectUrlFromStream(media_stream);
    }).catchError((e) => window.console.error(e));
  });
}
