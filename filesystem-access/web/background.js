chrome.app.runtime.onLaunched.addListener(function(launchData) {
  chrome.app.window.create('filesystem_access.html', {
    'id': 'fileWin', 'bounds': {'width': 800, 'height': 600 }
  });
});