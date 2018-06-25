class SavePrompt {
  
  boolean active;
  color fg = #939393;
  color bg = #777777;
  
  void paint(){
    fill(bg);
    rect(width/8,height/4,3*width/4,height/4);
    fill(fg);
    rect(width/4,height/4+height/4-3*height/32,width/2,height/16);
    fill(0);
    textSize(height/16);
    text("save!",width/2-textWidth("save!")/2,height/4+height/4-3*height/64);
    
  }
  
  void evalClick(){
    if(mouseX > width/4 && mouseX < width*3/4 &&
        mouseY > height/4+height/4-3*height/32 &&
        mouseY < height/4+height/4-height/32){
          imageName = eName.getText().toString();
          save();
          activity.runOnUiThread(new Runnable(){
   public void run() { 
     eName.setVisibility(View.INVISIBLE);
    }
  });
          active = false;
    }
    if(mouseX < width/8 || mouseX > width/8+3*width/4 ||
        mouseY < height/4 || mouseY > height/2){
          activity.runOnUiThread(new Runnable(){
         public void run() { 
     eName.setVisibility(View.INVISIBLE);
    }
  });
          active = false;
    
          
          
        }
  }
  
}
