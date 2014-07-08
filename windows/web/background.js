function launch() {


  // create the original window
  chrome.app.window.create('original.html', {
    id: "mainwin",
    bounds: {
      top: 128,
      left: 128,
      width: 300,
      height: 300
    },
    minHeight: 300,
    maxWidth: 500,
    minWidth: 300,
    frame: 'none'
  });
}

chrome.app.runtime.onLaunched.addListener(launch);