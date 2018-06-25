class ImageBackground {
  
  int w, h;
  
  public ImageBackground(int w, int h){
    this.w = w;
    this.h = h;
    
  }
  
void paint() {
  beginShape();
  texture(transparent);
  vertex(getX(), getY(), 0, 0);
  vertex(getX()+img.width*scale, getY(), getUVX(), 0);
  vertex(getX()+img.width*scale, getY()+img.height*scale, getUVX(), getUVY());
  vertex(getX(), getY()+img.height*scale, 0, getUVY());
  endShape(CLOSE);
}
  
float getUVX() {
  if (scale*transparent.width < iconsize)
    return (img.width*scale)/iconsize;
  float rep=1.0/transparent.width;
  while ((scale/rep) > iconsize) {
    rep += 1.0/transparent.width;
  }
  rep -= 1.0/transparent.height;
  return (int)((img.width*rep));
}

float getUVY() {
  if (scale*transparent.height < iconsize)
    return (img.height*scale)/(iconsize);
  float rep=1.0/transparent.height;
  while ((scale/rep) > iconsize) {
    rep += 1.0/transparent.height;
  }
  rep-= 1.0/transparent.height;
  return (int)((img.width*rep));
}
}