
import 'dart:html';

import "package:chrome/chrome_app.dart" as chrome;

import "common.dart";

void main() {
  bool focus = false;
  window.onLoad.listen((event) {
    log('Window B is loaded');
    setupContextMenu("windowB");
  });
  
  window.onBlur.listen((event) {
    log("Window B is blur");
    focus = false;
  });
  
  window.onFocus.listen((event) {
    log('Window B is focus');
    focus = true;
    setupContextMenu("windowB");
  });
  
  chrome.contextMenus.onClicked.listen((chrome.OnClickedEvent info) {
    clickOnContext(focus, 'B', info);
  });
}
