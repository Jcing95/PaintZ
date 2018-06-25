class Raster{
  
  PGraphics rg;
  float pscale;
  
  Raster(){
//   rg = createGraphics((img.width*10),(int)(img.height*10),JAVA2D);
//   rg.beginDraw();
//   rg.stroke(20);
//   rg.strokeWeight(1);
//   for(int i= 0; i<= img.width;i++){
//     rg.line(i*10,0,i*10,rg.height);
//   }
//   for(int i= 0; i<= img.height;i++){
//     rg.line(0,i*10,rg.width,i*10);
//   } 
//   rg.endDraw();
  }
  
  void paint(){
   //image(rg,getX(),getY(),img.width*scale,img.height*scale);
   stroke(20);
   strokeWeight(scale/10);
   for(int i= 0; i<= img.width;i++){
     if(getX()+i*scale>-width/2 && getX()+i*scale < width/2)
     line(getX()+i*scale,getY(),getX()+i*scale,getY()+img.height*scale);
   }
   for(int i= 0; i<= img.height;i++){
     if(getY()+i*scale>-height/2 && getY()+i*scale < height/2)
     line(getX(),getY()+i*scale,getX()+img.width*scale,getY()+i*scale);
   } 
  }
  
  
  
}