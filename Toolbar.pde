import java.util.LinkedList;

class Toolbar {
  
  LinkedList<Icon> features;
  color bg = #939393;
  int offset;
  boolean vertical = false;
  boolean validPress;
  int dist;
  
  public Toolbar(){
    features = new LinkedList<Icon>();
    
  }
  
  Icon getIcon(int id){
    return features.get(id);
  }
  
  int add(String label, boolean toggle){
    int id = features.size();
    features.add(new Icon(label, toggle, this, id));
    return id;
  }
  
  boolean tool(int id){
    return features.get(id).active;
  }
 
  void paint(){
    fill(bg);
    if(vertical)
      rect(0,0,iconsize*2,height);
    else
      rect(0,0,width,iconsize*2);
    for(Icon f : features){
      f.paint();
    }
  }
  
  int getYPos(int pos){
    if(vertical)
      return offset/2+(int)(0.5*iconsize+iconsize*1.5*(pos));
    return iconsize/2;
  }
  
  int getXPos(int pos){
    if(vertical)
      return iconsize/2;
    return offset/2+(int)(0.5*iconsize+iconsize*1.5*pos);
  }
  
  boolean press(){
    if(this.contains()){
      validPress = true;
      dist = 0;
      return true;
    }
    return false;
  }
  
  boolean release(){
    if(this.contains() && validPress){
      for(Icon f : features){
        if(f.clicked()){
          for(Icon g : features){
            g.setActive(false);
          }
          f.setActive(true);
          break;
        }
      }
      validPress = false;
      return true;
    }
    validPress = false;
    return false;
  }
  
  boolean drag(){
    if(abs(dist)>iconsize/2)
      validPress = false;
    if(this.contains()){
      int delta = mouseX-lmx;
      int maxOffset = width;
      if(vertical){
       delta = mouseY-lmx;
       maxOffset = height;
      }
      if(delta > 0 && offset/2 > iconsize*3)
        return true;
      if(delta < 0 && offset/2 < maxOffset-iconsize*3-(iconsize*1.5*features.size()))
        return true;
      offset += delta;
      dist+= delta;
      return true;
    }
    return false;
  }
  
  boolean contains(){
    if(vertical && mouseX < iconsize*2)
      return true;
    return mouseY < iconsize*2;
  }
}