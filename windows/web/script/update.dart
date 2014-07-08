import "dart:html";

void update([num coef = 0]) {
  document
    ..querySelector("#screenX").text = window.screenX.toString()
    ..querySelector("#screenY").text = window.screenX.toString()
    ..querySelector("#innerWidth").text = window.innerWidth.toString() 
    ..querySelector("#innerHeight").text = window.innerHeight.toString();
  
  window.requestAnimationFrame(update);
}