import 'dart:html';

import 'package:chrome/chrome_app.dart' as chrome;

void log(String message) {
  PreElement logger = document.querySelector('#log');
  logger.text += "$message\n";
}

void clickOnContext(bool focus, String aOrB, chrome.OnClickedEvent info) {
  if (!focus) {
    log("Ignoring context menu click that happened in another window");
    return;
  }
    
  log('Item selected in $aOrB: ${info.info.menuItemId}');
}

void setupContextMenu(String sContext) {
  chrome.contextMenus.removeAll().then((value) {
    var options = ["foo", "bar", "baz"];
    if (sContext == "windowA") {
      options.forEach((String option) {
        chrome.contextMenus.create(new chrome.ContextMenusCreateParams(title: "A: $option", id: option, type: "radio", contexts: ['all']));
      });
      chrome.contextMenus.create(new chrome.ContextMenusCreateParams(id: "sep1", type: "separator", contexts: ['selection']));
      chrome.contextMenus.create(new chrome.ContextMenusCreateParams(title: "Selection context menu: '%s'", id: "Selection context menu", contexts: ['selection']));
    }
    else if (sContext == "windowB") {
      options.forEach((String option) {
        chrome.contextMenus.create(new chrome.ContextMenusCreateParams(title: "B: $option", id: option, type: "checkbox", contexts: ['all']));
      });
    }
  });
}