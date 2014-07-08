
import 'dart:html';

import 'package:chrome/chrome_app.dart' as chrome;
import "script/update.dart";

// kill all windows onClosed event
void reset(windows) {
  windows.forEach((win) {
    win.close();
  });
}

void main() {
  var windows = <chrome.AppWindow>[];
  //  get original window
  var original = chrome.app.window.current();
  windows.add(original);
  
  //  create copycat window
  var bounds = original.getBounds();
  bounds.left += bounds.width + 5;
  chrome.CreateWindowOptions cwo = new chrome.CreateWindowOptions(bounds: bounds, minWidth: 300, minHeight: 300, maxWidth: 500, frame: 'none');
  chrome.app.window.create("copycat.html", cwo).then((chrome.AppWindow copycat) {
    windows.add(copycat);
    
    //  original event
    original
      ..onBoundsChanged.listen((event) {
        var bounds = original.getBounds();
        bounds.left = bounds.left + bounds.width + 5;
        copycat.setBounds(bounds);
      })
      ..onRestored.listen((event) {
        print('original restored');
        if (copycat.isMinimized()) {
          copycat.restore();
        }
      })
      ..onClosed.listen((event) => reset(windows));

    //  copycat event
    copycat
      ..onRestored.listen((event) {
        print('copy restored');
        if (original.isMinimized()) {
          original.restore();
        }
      })
      ..onClosed.listen((event) => reset(windows));
    
    var minimizeNode = document.querySelector("#minimize-button");
    if (minimizeNode != null) {
      minimizeNode.onClick.listen((event) {
        windows.forEach((win) {
          win.minimize();
        });
      });
    }

    update();
  });
}
