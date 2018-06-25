
import android.os.Environment;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import java.util.LinkedList;

import android.app.Activity;
import android.content.Context;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.text.Editable;
//import android.text.InputTpye;
import android.graphics.Color;
import android.widget.Toast;
import android.os.Looper;
import android.view.WindowManager;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.os.Bundle;
import android.widget.EditText;
import android.widget.TextView;

// CONSTANTS // 
int iconsize;

// ANDROID STUFF //
ScaleGestureDetector scaler;
Activity activity;
Context context;
FrameLayout fl;
EditText eBrush, eName;

// ESSENTIALS //
Raster raster;
ImageBackground imgback;
PGraphics imgBack;
ColorPicker cp;
Slider brushSlider;
Toolbar tools;
SavePrompt saveprompt;

// IMAGES //
PImage img;
PImage slidPointer, slidBar;
PImage transparent;

// VARIABLES //
float scale;
color c, cl;
int imgX, imgY;
int lmx, lmy;
int mx, my;
String imageName;


boolean pressed;
boolean fillsuccess=true;
//PShape sbg;

float brushsize;
LinkedList<Integer> rcl;

// ICONIDS //
int colorpicker, pipette, eraser, 
  fill, move, save, grid, tundo, tredo,
  openImage;

Stroke undo, redo;
LinkedList<Stroke> undos;
LinkedList<Stroke> redos;

void setup() {
  fullScreen(P2D);
  frameRate(120);
  orientation (PORTRAIT);
  textureWrap(REPEAT);
  textureMode(NORMAL);
  ((PGraphicsOpenGL)g).textureSampling(3);
  Looper.prepare();
  activity = this.getActivity();
  context = activity.getApplicationContext();
  
  rcl = new LinkedList<Integer>();
  imageName = "img.png";
  undos = new LinkedList<Stroke>();
  redos = new LinkedList<Stroke>();
  undo = new Stroke();
  brushsize =1;
  iconsize = height/20;
  brushSlider = new Slider(width/50, iconsize*2, width-2*width/10, height/25, 9);

  setupToolbar();

  slidPointer = loadImage("gfx/slider/pointer.png");
  slidBar = loadImage("gfx/slider/bar.png");

  transparent = loadImage("gfx/tools/transparent.png");

  load(null);
  img.loadPixels();

  scaler = new ScaleGestureDetector(getActivity().getApplicationContext(), new  ScaleGestureDetector.SimpleOnScaleGestureListener() {
    public boolean onScale(ScaleGestureDetector s) {
      scale *= s.getScaleFactor();
      scale = max(0.5, min(100, scale));
      return true;
    }
  }   
  );
  imgback = new ImageBackground(img.width, img.height);
  raster = new Raster();
  c = 0x00000000;
  cp = new ColorPicker(10, height/5, width-20, width-20, c);
  initTFs();
  saveprompt = new SavePrompt();
  
}


void setupToolbar() {
  println("loading tools");
  tools = new Toolbar();
  colorpicker = tools.add("transparent", true);
  pipette = tools.add("pipette", true);
  eraser = tools.add("eraser", true);
  fill = tools.add("fill", true);
  tundo = tools.add("undo", false);
  move = tools.add("move", true);
  save = tools.add("save", false);
  grid = tools.add("grid", true);
  tredo = tools.add("redo", false);
  openImage = tools.add("open", false);
  println("tools loaded");
}

void initTFs(){
  eBrush = txt(eBrush,width-width/5+width/25,iconsize*2,2*width/10-3*width/50,height/25,true);
  eName = txt(eName,width/8+width/16,height/4+height/32,3*width/4-width/8,height/16,false);

  println("" + (eBrush == eName));

  fl = (FrameLayout)activity.findViewById(0x1000);
  activity.runOnUiThread(new Runnable(){
   public void run() { 
      if(eBrush.getParent()!=null){
        ((ViewGroup)eBrush.getParent()).removeView(eBrush); 
      }
      fl.addView(eBrush);
      fl.addView(eName);
      eName.setVisibility(View.INVISIBLE);
    }
  });
}


EditText txt(EditText edit, int x, int y, int w, int h, boolean numbers) {
  edit = new EditText(context);
  //edit = e;
  edit.setLayoutParams(
  new LinearLayout.LayoutParams(w,h));
  edit.setTextColor(Color.rgb(0, 0, 0));
  edit.setBackgroundColor(Color.rgb(0x93,0x93,0x93));
  edit.setX(x);
  edit.setY(y);
  edit.setLines(1);
  if(numbers)
    edit.setInputType(2);
  else
    edit.setInputType(262144);
  edit.setTextSize(0,height/40);
  edit.setPadding(0,0,0,0);
  edit.setCursorVisible(false);
  edit.requestFocus();
  edit.setVisibility(View.VISIBLE);

  return edit;
}



void draw() {
  background(#dfdfdf);
  if (tools.tool(colorpicker)) {
    cp.render();
  } else {
    translate(width/2, height/2);
    imgback.paint();
    image(img, getX(), getY(), img.width*scale, img.height*scale);

    if (tools.tool(grid)) raster.paint();
    translate(-width/2, -height/2);
    stroke(#000000);
    fill(#ffffff);
    strokeWeight(1);
    rect(0, mouseY, width, scale/10);
    rect(mouseX, 0, scale/10, height);
    noFill();
    strokeWeight(5);
    ellipse(mouseX, mouseY, brushsize*scale, brushsize*scale);
  }

  tools.paint();
  brushSlider.paint();
  if(saveprompt.active)
  saveprompt.paint();
}

int slotX(int nr) {
  return (int)(height/50+(nr*1.5*height/20));
}

public boolean surfaceTouchEvent(MotionEvent e) {
  scaler.onTouchEvent(e);
  lmx = mx;
  lmy = my;
  mx = (int)e.getX();
  my = (int)e.getY();
  mouseX = mx;
  mouseY = my;
  if (e.getActionMasked() == MotionEvent.ACTION_MOVE
        && !saveprompt.active) {
    drag(e.getPointerCount());
  }

  boolean btls = tools.press();
  if (!btls && e.getActionMasked() == MotionEvent.ACTION_DOWN
    && !saveprompt.active && e.getPointerCount() == 1 && !tools.tool(colorpicker) && !tools.tool(move)) {
    img.loadPixels();
    paint(mouseX, mouseY);
    img.updatePixels();
  }
  return super.surfaceTouchEvent(e);
}

void load(String path) {
  try {
    PImage imgl;
    img = null;
    if(path == null){
    String filename = "img.png";
    String directory = new String(Environment.getExternalStorageDirectory().getAbsolutePath() + "/paintZ");
    imgl = loadImage(directory + "/" + filename);
    }else{
      imgl = loadImage(path);
    }
    imgl.loadPixels();
    img = createImage(imgl.width, imgl.height, ARGB);
    img.loadPixels();
    img.pixels = imgl.pixels;
    img.updatePixels(); 
    scale = width*0.9/img.width;
    
    println(path + " loaded successfully."); 
    toast("Succesfully loaded Image!");
    
  } 
  catch (Exception e) {
    println("Error while saving file: " + e.getMessage());
    img = createImage(512, 512, ARGB);
    toast("couldnt load - created new Image!");
  }
}

void save() {
   try {
        String filename = imageName;
        String directory = new String(Environment.getExternalStorageDirectory().getAbsolutePath() + "/paintZ");
        img.save(directory + "/" + filename);
        println("File saved successfully.");
        toast("saved successfully");
  } 
  catch (Exception e) {
    println("Error while saving file: " + e.getMessage());
  }
}

String toasttext;
void toast(String msg){
  toasttext = msg;
  activity.runOnUiThread(new Runnable(){
   public void run() { 
    Toast.makeText(activity, toasttext, Toast.LENGTH_SHORT).show(); 
    }
  });
}

void mousePressed() {
  pressed = true;
  brushSlider.press();
}

void mouseReleased() {
  pressed = false;
  if(saveprompt.active)
    saveprompt.evalClick();
  tools.release();
  if (undo.valid()) {
    undos.add(undo);
    undo = new Stroke();
    redos.clear();
  }
  
  //printArray(undos);
  //println(undo.valid());
}

void toolAction(int id) {
  if (id == save) {
    saveprompt.active = true;
    activity.runOnUiThread(new Runnable(){
   public void run() { 
      eName.setVisibility(View.VISIBLE);
      eName.setText(imageName);
      eName.requestFocus();
      activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
    }
  });
  }
  if (id == tundo && undos.size()>0) {
    undos.getLast().undo(true);
    undos.removeLast();
  }
  if (id == tredo && redos.size() > 0) {
    redos.getLast().undo(false);
    redos.removeLast();
  }
  if (id == eraser) {
    if (tools.tool(eraser)) {
      cl = c;
      c = 0x00000000;
    } else {
      c = cl;
    }
  }
  if (id == openImage){
    new FileChooser().show();
  }
}


boolean contains(float x, float y, float w, float h) {
  return (mouseX >= x && mouseY >= y 
    && mouseX <= x+w 
    && mouseY <= y+h);
}

void drag(int num) {
  brushSlider.press();
  if (tools.drag())
    return;
  if (mouseY > height/7.5) {
    if (num > 1) {
      imgX += mouseX-lmx;
      imgY += mouseY-lmy;
    }

    if (num == 1 && !tools.tool(colorpicker) && !tools.tool(fill) && !tools.tool(move)) {
      float i = lmx, j = lmy;
      float ig = mx, jg = my;
      PVector mov = new PVector(ig-i, jg-j);
      float dist = mov.mag();
      img.loadPixels();
      for (int n = 0; n< dist/scale; n++) {
        paint((int)lerp(i, ig, scale/dist*n), (int)lerp(j, jg, scale/dist*n));
      }
      img.updatePixels();
    }
  }
}



void recpaint(int x, int y, int sx, int sy) {
  float xx = x-sx;
  float yy = y-sy;
  if (sqrt(xx*xx+yy*yy)*2 <= brushsize) {
    int pos = x+y*img.width;
    if (pos >= 0 && pos < img.pixels.length
      && x < img.width && y < img.height
      && x >= 0 && y >= 0 && !rcl.contains(pos)) {
      setColor(pos);
      rcl.add(pos);
      recpaint(x+1, y, sx, sy);
      recpaint(x, y+1, sx, sy);
      recpaint(x-1, y, sx, sy);
      recpaint(x, y-1, sx, sy);
    }
  }
}

void fill(int x, int y, int prev) {
  if (prev == c)
    return;
  int pos = x+y*img.width;
  if (pos >= 0 && pos < img.pixels.length
    && x < img.width && y < img.height
    && x >= 0 && y >= 0 
    && img.pixels[pos] == prev) {
    setColor(pos);
    fill(x+1, y, prev);
    fill(x, y+1, prev);
    fill(x-1, y, prev);
    fill(x, y-1, prev);
  }
}

void refill(int lfx, int lfy, int prev){
  int pos[] = new int[4];
  pos[0] = lfx+1+(lfy)*img.width;
  pos[1] = lfx+(lfy+1)*img.width;
  pos[2] = lfx-1+(lfy)*img.width;
  pos[3] = lfx+(lfy-1)*img.width;
  if (img.pixels[pos[0]] != prev){
    println("refill 0");
    fill(lfx+1, lfy, prev);}
  if (img.pixels[pos[1]] != prev){
    println("refill 1");
    fill(lfx, lfy+1, prev);}
  if (img.pixels[pos[2]] != prev){
    println("refill 2");
    fill(lfx-1, lfy, prev);}
  if (img.pixels[pos[3]] != prev){
    println("refill 3");
    fill(lfx, lfy-1, prev);}
  
  //fillsuccess = true;
}

void setColor(int pos) {
  undo.add(pos, img.pixels[pos]);
  img.pixels[pos] = c;
}


void paint(int mx, int my) {
  int x = (int)((mx-getX()-width/2)/scale);
  int y = (int)((my-getY()-height/2)/scale);
  int pos = x+y*img.width;
  //img.loadPixels();

  if (pos >= 0 && pos < img.pixels.length
    && x < img.width && y < img.height
    && x >= 0 && y >= 0) { //Within canvas

    if (tools.tool(fill)) {
      fillsuccess = false;
      try {
        fill(x, y, img.pixels[pos]);
        fillsuccess = true;
      } 
      catch(java.lang.StackOverflowError e) {
        println("fill stackoverflow");
        fillsuccess = false;
        //refill(x,y,img.pixels[pos]);
      }
     while(!fillsuccess)
       try{ 
       refill(x, y, img.pixels[pos]);
       fillsuccess = true;
      } 
      catch(java.lang.StackOverflowError e) {
        println("fill stackoverflow");
        fillsuccess = false;
        //refill(x,y,img.pixels[pos]);
      }
      // bfill = false;
      //img.updatePixels();
      return;
    }

    if (!tools.tool(pipette)) {
      if (brushsize > 1) {
        recpaint(x, y, x, y);
        rcl.clear();
        //img.updatePixels();
      } else {
        setColor(pos);
        // img.updatePixels();
      }
    } else {
      c = img.pixels[pos];
      tools.getIcon(colorpicker).tint(c);
    }
  }
}


int getX() {
  return (int)(imgX-img.width*scale/2);
}

int getY() {
  return (int)(imgY-img.height*scale/2);
}
