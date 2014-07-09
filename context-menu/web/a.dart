
import 'dart:html';

import "package:chrome/chrome_app.dart" as chrome;

import "common.dart";


void main() {
  bool focus = false;
  window.onLoad.listen((event) {
    log('Window A is loaded');
    setupContextMenu("windowA");
  });
  
  window.onBlur.listen((event) {
    log("Window A is blur");
    focus = false;
  });
  
  window.onFocus.listen((event) {
    log('Window A is focus');
    focus = true;
    setupContextMenu("windowA");
  });
  
  chrome.contextMenus.onClicked.listen((chrome.OnClickedEvent info) {
    clickOnContext(focus, 'A', info);
  });
}
