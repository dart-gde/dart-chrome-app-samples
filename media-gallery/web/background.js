
chrome.app.runtime.onLaunched.addListener(function(data) {
    chrome.app.window.create('mediagallery.html', 
      {bounds: {width:900, height:600}, minWidth:900, maxWidth: 900, minHeight:600, maxHeight: 600, id:"MGExp"}, 
      function(app_win) {
        app_win.__MGA__bRestart = false;
      }
    );
    console.log("app launched");
});

chrome.app.runtime.onRestarted.addListener(function() {
    chrome.app.window.create('mediagallery.html', 
      {bounds: {width:900, height:600}, minWidth:900, maxWidth: 900, minHeight:600, maxHeight: 600, id:"MGExp"}, 
      function(app_win) {
        app_win.__MGA__bRestart = true;
      }
    );
    console.log("app restarted");
});