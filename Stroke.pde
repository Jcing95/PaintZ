class Stroke {

  LinkedList<Strokept> ptx; //pos | color
  public boolean valid= false;

  public Stroke() {
    ptx = new LinkedList<Strokept>();
  }

  void add(int pos, int col) {
    //println(pos + "  " + valid);
    this.valid=true;
    ptx.add(new Strokept(pos, col));
  }

  void undo(boolean un) {
    img.loadPixels();
    if (un)
      redo = new Stroke();
    else
      undo = new Stroke();
    while (ptx.size()>0) {
      Strokept p = ptx.getLast();
      ptx.removeLast();
      if (un) redo.add(p.pos, img.pixels[p.pos]);
      else undo.add(p.pos, img.pixels[p.pos]);
      img.pixels[p.pos] = p.col;
    }
    if (un) {
      redos.add(redo);
      redo = new Stroke();
    } else {
      undos.add(undo);
      undo = new Stroke();
    }
    img.updatePixels();
  }

  boolean valid() {
    return valid;
  }

  private class Strokept {
    int pos, col;

    public Strokept(int pos, int col) {
      this.pos = pos;
      this.col = col;
    }
  }
}
