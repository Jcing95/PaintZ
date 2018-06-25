class Slider{
  
  int x, y, w, h;
  
  int ptx;
  int parts;
  
  public Slider(int x, int y, int w, int h, int parts){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.parts = parts;
    ptx = 0;
  }
  
  void press(){
    //println("press");
    if(mouseX >= x && mouseY >= y 
     && mouseX <= x+w 
     && mouseY <= y+h){
      float p = mouseX-x;
      ptx = round((p/w)*parts);
      brushsize = ptx+1;
      activity.runOnUiThread(new Runnable() {
    public void run() {
      eBrush.setText(""+(int)brushsize);
    }
  });
      
      //println(ptx);
    }
  }
  
  
  void paint(){
    if(eBrush.getText().toString().length() > 0 && brushsize != Integer.parseInt(eBrush.getText().toString())){
      brushsize = Integer.parseInt(eBrush.getText().toString());
      brushsize = (int)max(1,brushsize);
      ptx = (int)min(brushsize-1,parts);
    }
    fill(#777777);
    rect(0,y,width,h+5);
    image(slidBar,x,y,w,h);
    image(slidPointer,x+(float)ptx/parts*w-h/2,y,h,h);
    
  }
  
}