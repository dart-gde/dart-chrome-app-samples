import "dart:html";

class DnDFileController {
  Element _el;
  Function _onDrop;
  num _over_count;
  
  DnDFileController(String id_selector, void this._onDrop(DataTransfer data_transfer)) {
    this._el = document.querySelector("$id_selector");
    this._over_count = 0;
    
    this._el.onDragEnter.listen(this._dragEnter);
    this._el.onDragOver.listen(this._dragOver);
    this._el.onDragLeave.listen(this._dragLeave);
    this._el.onDrop.listen(this._drop);
  }
  
  void _dragEnter(MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
    this._over_count++;
    this._el.classes.add("dropping");
  }
  
  void _dragOver(MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
  }
  
  void _dragLeave(MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
    if (--this._over_count <= 0) {
      this._el.classes.remove("dropping");
      this._over_count = 0;
    }
  }
  
  void _drop(MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
    this._el.classes.remove("dropping");
    
    this._onDrop(e.dataTransfer);
  }
}