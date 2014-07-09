chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('a.html', {bounds:{top: 0, left: 0, width: 300, height: 300}});
  chrome.app.window.create('b.html', {bounds:{top: 0, left: 310, width: 300, height: 300}});
});

chrome.runtime.onInstalled.addListener(function() {
  chrome.contextMenus.create({
    title: 'Launcher Window "A"',
    id: "launcher1",
    contexts: ['launcher']
  });
  
  chrome.contextMenus.create({
    title: 'Launcher Window "B"',
    id: "launcher2",
    contexts: ['launcher']
  });
  
  chrome.contextMenus.create({
    type: "separator",
    id: 'launcher3',
    contexts: ['launcher']
  });
});

chrome.contextMenus.onClicked.addListener(function(itemClicked) {
  if (itemClicked.menuItemId == "launcher1")
    chrome.app.window.create('a.html', {bounds:{top: 0, left: 0, width: 300, height: 300}});
  if (itemClicked.menuItemId == "launcher2")
    chrome.app.window.create('b.html', {bounds:{top: 0, left: 310, width: 300, height: 300}});
});