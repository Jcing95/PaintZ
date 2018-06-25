class Icon {
  
  int pos;
  boolean active, toggle;
  PImage image;
  Toolbar bar;
  boolean tint;
  color tintc;
  
  public Icon(String image,boolean toggle, Toolbar bar, int pos){
    this.pos = pos;
    this.image = loadImage("gfx/tools/" + image + ".png");
    this.bar = bar;
    active = false;
    this.toggle = toggle;
  }
  
  void paint(){
    if(active){
      fill(0x80ffffff);
      rect(bar.getXPos(pos),bar.getYPos(pos),iconsize,iconsize);
    }
    //fill(0x00000000)
    image(image,bar.getXPos(pos),bar.getYPos(pos),iconsize,iconsize);
    if(tint){
      fill(tintc);
      rect(bar.getXPos(pos),bar.getYPos(pos),iconsize,iconsize);
    }
    noFill();
    stroke(0);
    strokeWeight(3);
    rect(bar.getXPos(pos),bar.getYPos(pos),iconsize,iconsize);

  }
  
  boolean clicked(){
    if(mouseX >= bar.getXPos(pos) && mouseY >= bar.getYPos(pos) 
    && mouseX <= bar.getXPos(pos)+iconsize 
    && mouseY <= bar.getYPos(pos)+iconsize){
      if(toggle){
        active = !active;
      }
      toolAction(pos);
      return active;
    }
    return false;
  }
  
  void tint(int c){
    tint = true;
    tintc = c;
  }
  
  void setActive(boolean a){
    active = a;
  }
}