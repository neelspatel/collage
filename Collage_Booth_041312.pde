import processing.video.*;
import java.awt.*;

Capture cam;

int num, numNeeded = 5;

boolean save = true, draw = false;

RectButton takePics, choosePic, generate;
boolean locked = false;

PImage large;

//components to open new window
ExtraWindow collage;

void setup() {
  size(screen.width, screen.height);

  // If no device is specified, will just use the default.
  cam = new Capture(this, 400,400, 30);  
  
  //image numbers
  num = 1;  
  
  //sets up graphics
  
  //background
  background(14);
  
  //title
  fill(14,44,68);
  rect(0,10,screen.width,100);
  textSize(72);
  fill(0,102,153);
  text("Welcome to CollageBooth!",250,90);
  
  //buttons
  takePics = new RectButton(50,200,100,color(50), color(100));
  text("Take Pics",200,275);
    
  choosePic = new RectButton(50,400,100,color(50), color(100));
  text("Choose Picture",200,475);
  
  generate = new RectButton(50,600,100,color(50), color(100));
  text("Generate!",200,675);
  
  //status box
  stroke(255);
  fill(50);
  rect(50,800,200,30);
  textSize(18);
  
  
  //set up images
  large = loadImage("image.png");
  
 
  
}


void draw() {

  if (cam.available() == true && draw == true) {
    cam.read();
    PImage current = cam.get(0,0,400,400);
    image(cam, 900,250);
    if(save == true && (num%10==0))
    {
      current.save("/Users/neel 1/Documents/Processing/Collage_Booth_041312/pics/image" + num/10 + ".jpg");    
      //draws rectangle to cover up
      fill(50);
      stroke(50);
      rect(1120,210,30,20);
      fill(14);
      text(10-num/10,1120,230);
      
    }
    num++;
    
    if(num/10>10)
    {
      draw = false;
      save = false;
      //draw rectangle to clear everything
      fill(14);
      stroke(14);
      rect(850,200,500,500);
    }
  }  
  
  update(mouseX, mouseY);
  takePics.display();
  choosePic.display();
  generate.display();  
}

void update(int x1, int y1)
{
  if(locked == false) {
    takePics.update();    
    choosePic.update();
    generate.update();    
  } 
  else {
    locked = false;
  }

  if(mousePressed) {
    if(takePics.pressed()) {
      fill(50);
      rect(50,800,200,50);
      textSize(18);
      fill(200);
      text("TakePics Pressed!",70,825);
      
      //starts drawing and saveing pictures
      draw = true;
      save = true;
      
      //draws window
      fill(50);
      rect(850,200,500,500);
      
      //draws window title
      fill(14);
      text("WebCam Window",860,230);
      text(10,1120,230);
      text("shots remaining",1150,230);
    }  
    else if(choosePic.pressed()) {
      fill(50);
      rect(50,800,200,50);
      textSize(18);
      fill(200);
      text("Choose Pic Pressed!",70,825);
      
      //draws window
      fill(50);
      rect(850,200,500,500);
      
      //draws window title
      fill(14);
      text("Photo Selection Window",860,230);
      
      //draws image
      int imgW = large.width;
      int imgH = large.height;
      //400/x = W/H, x = 400H/W
      if(imgW>imgH)
      {
        imgH = 400*imgH/imgW;
        imgW = 400;
      }
      //x/400 = W/H, x = 400W/H
      else
      {
        imgW = 400*imgW/imgH;
        imgH = 400;
      }
      
      image(large,900,250,imgW, imgH);
      
    }  
    else if(generate.pressed()) {
      fill(50);
      rect(50,800,200,50);
      textSize(18);
      fill(200);
      text("Generate Pressed!",70,825);
      
      PImage img = large;
      
      int imgh = img.height;
      int imgw = img.width;

      int numPics = 1500;
      int rows = ceiling(Math.sqrt(numPics));
      print(rows);

      int blockh = ceiling(imgh/rows);  
      int  blockw = ceiling(imgw/rows);
      
      int newh = blockh*rows;
      int neww = blockw*rows;
  
      //loads collage window
      collage = new ExtraWindow(this, "collage", 100,0,neww, newh);
      
      
      //begins calculations
      
      //creates arrays
      //PImage[] images = new PImage[rows*rows];
      int[] r = new int[rows*rows];
      int[] g = new int[rows*rows];
      int[] b = new int[rows*rows];      
      
      for(int i = 0; i < rows; i++)
      {
        for(int j = 0; j< rows; j++)
        {
          int x = i*blockw;
          int y = j*blockh;  
          
          for(int m = 0; m < blockw; m++)
          {
            for(int n = 0; n < blockh; n++)
            {
              r[i*rows+j] += red(img.get(x+m, y+n));
              g[i*rows+j] += green(img.get(x+m, y+n));
              b[i*rows+j] += blue(img.get(x+m, y+n));
            }
          }
        }
      }
      
      for(int i = 0; i < rows*rows; i++)
      {
        r[i] = r[i]/(blockw*blockh);
        g[i] = g[i]/(blockw*blockh);
        b[i] = b[i]/(blockw*blockh);    
      }
      
      //loads directory of images
      File directory = new File("/Users/neel 1/Documents/Processing/Collage_Booth_041312/pics");
      String[] names = directory.list();
      
      //loads array of images
      PImage[] images = new PImage[names.length];
      for(int i = 0; i < names.length; i++)
      {
        images[i] = loadImage("/Users/neel 1/Documents/Processing/Collage_Booth_041312/pics/image" + (i+1) + ".jpg");
      }
      
      //drawing images
      for(int i = 0; i < rows; i++)
      {
        for(int j = 0; j< rows; j++)
        {
          int total = r[i*rows + j] + g[i*rows + j] + b[i*rows + j];
    
          if(total < 100)
          {
            collage.tint(r[i*rows + j]+50, g[i*rows + j]+50, b[i*rows + j]+50,200);
          }
          else
          {            
            collage.tint(r[i*rows + j], g[i*rows + j], b[i*rows + j],160);
          }
          //image(yale, i*blockw, j*blockh, blockw, blockh);
          //image(neel, i*blockw, j*blockh, blockw, blockh);
          //print((i*rows + j+1) +"\n");
          //PImage current = loadImage("/Users/neel 1/Documents/Processing/Collage_Booth_041312/pics/" + names[(i*rows + j+1)%names.length]);
          PImage current = images[(i*rows + j+1)%names.length];
          collage.image(current, i*blockw, j*blockh, blockw, blockh);      
        }
      }

      PImage screenshot = collage.get();
      //image(screenshot,0,0);
      screenshot.save("/Users/neel 1/Documents/Processing/Collage_Booth_041312/capture.jpg");
    }  
    
  }
}

//________________________________________________________________________________________________________________________________________________
static int ceiling(double num)
{
  int low = (int) num;
  if(low == num)
    return low;
  else
    return low+1;
}

//________________________________________________________________________________________________________________________________________________
class Button
{
  int x, y;
  int size;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false;   

  void update() 
  {
    if(over()) {
      currentcolor = highlightcolor;
    } 
    else {
      currentcolor = basecolor;
    }
  }

  boolean pressed() 
  {
    if(over) {
      locked = true;
      return true;
    } 
    else {
      locked = false;
      return false;
    }    
  }

  boolean over() 
  { 
    return true; 
  }

  boolean overRect(int x, int y, int width, int height) 
  {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } 
    else {
      return false;
    }
  }

  boolean overCircle(int x, int y, int diameter) 
  {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    } 
    else {
      return false;
    }
  }

}

class CircleButton extends Button
{ 
  CircleButton(int ix, int iy, int isize, color icolor, color ihighlight) 
  {
    x = ix;
    y = iy;
    size = isize;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }

  boolean over() 
  {
    if( overCircle(x, y, size) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    stroke(255);
    fill(currentcolor);
    ellipse(x, y, size, size);
  }
}

class RectButton extends Button
{
  RectButton(int ix, int iy, int isize, color icolor, color ihighlight) 
  {
    x = ix;
    y = iy;
    size = isize;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }

  boolean over() 
  {
    if( overRect(x, y, size, size) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    stroke(255);
    fill(currentcolor);
    rect(x, y, size, size);
  }
}


//________________________________________________________________________________________________________________________________________________
// class ExtraWindow


import java.awt.event.WindowEvent;
import java.awt.Frame;
import java.awt.Color;
import java.awt.event.WindowListener;
import java.awt.Insets;
import java.awt.event.ComponentListener;
import java.awt.event.ComponentEvent;
import java.awt.event.KeyEvent;
import java.awt.Component;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.MouseInfo;


class ExtraWindow extends PApplet implements WindowListener, ComponentListener {

  protected int width = 600;
  protected int height = 200;
  protected int x = 100;
  protected int y = 100;
  protected String myName;
  protected  String myTitle;
  protected  boolean isCoordinates = false; 
  protected boolean isLoop = true;
  public final static int NORMAL = 0;
  public final static int ECONOMIC = 1;
  protected int myMode = NORMAL;
  protected String myRenderer = "";
  protected int myFrameRate;
  boolean isUndecorated = false;
  PApplet papplet;


  public ExtraWindow(PApplet theApplet) {
    super();
    papplet = theApplet;
  }

  public ExtraWindow(PApplet theApplet, String theName, int theWidth, int theHeight) {
    this(theApplet,theName, theWidth, theHeight, "", 30);
  }

  public ExtraWindow(PApplet theApplet, String theName, int theWidth, int theHeight, String theRenderer, int theFrameRate) {
    super();
    papplet = theApplet;
    myName = theName;
    myTitle = theName;
    width = theWidth;
    height = theHeight;
    myFrameRate = theFrameRate;
    myRenderer = theRenderer;
    launch();
  }


  public ExtraWindow(PApplet theApplet, final String theName, int theX, int theY, int theWidth, int theHeight) {
    this(theApplet, theName, theX, theY, theWidth, theHeight, "", 30);
  }

  public ExtraWindow(PApplet theApplet, String theName, int theX, int theY, int theWidth, int theHeight, String theRenderer, int theFrameRate) {
    super();
    papplet = theApplet;
    myName = theName;
    myTitle = theName;
    width = theWidth;
    height = theHeight;
    x = theX;
    y = theY;
    myFrameRate = theFrameRate;
    myRenderer = theRenderer;
    launch();
  }


  public void setup() {
    if (myRenderer.length() == 0) {
      size(width, height);
    } 
    else {
      size(width, height, myRenderer);
    }
    frameRate(myFrameRate);
  }


  public void draw() {
  }


  public Frame getFrame() {
    return frame;
  }

  public String name() {
    return myName;
  }


  public void setVisible(boolean theValue) {
    if (theValue == true) {
      frame.show();
    } 
    else {
      frame.hide();
    }
  }


  public void setResizeable(boolean theValue) {
    frame.setResizable(theValue);
  }


  public void setTitle(String theTitle) {
    myTitle = theTitle;
    updateTitle();
  }

  protected void updateTitle() {
    String m = myTitle;
    if(isCoordinates) {
      m += " x:" + x + " y:" + y + "   " + width + "x" + height;
    }
    frame.setTitle(m);
  } 

  public String title() {
    return myTitle;
  } 

  public void showCoordinates() {
    isCoordinates = true;
    updateTitle();
  }

  public void hideCoordinates() {
    isCoordinates = false;
    updateTitle();
  }

  public void windowActivated(WindowEvent e) {
    isLoop = true;
    loop();
  }

  public void keyPressed(KeyEvent theKeyEvent) {
    papplet.keyPressed(theKeyEvent);
  }

  public void keyReleased(KeyEvent theKeyEvent) {
    papplet.keyReleased(theKeyEvent);
  }

  public void keyTyped(KeyEvent theKeyEvent) {
    papplet.keyTyped(theKeyEvent);
  }



  int mX;
  int mY;

  public void mousePressed(){
    if(isUndecorated) {
      mX = mouseX;
      mY = mouseY;
    }
  }

  void mouseDragged(){
    if(isUndecorated) {
      frame.setLocation(
      MouseInfo.getPointerInfo().getLocation().x-mX,
      MouseInfo.getPointerInfo().getLocation().y-mY);
    }
  }


  public void windowClosed(WindowEvent e) {
    //	 System.out.println("window closed");
  }


  public void windowClosing(WindowEvent e) {
    dispose();
  }

  public void windowDeactivated(WindowEvent e) {
    if (myMode == ECONOMIC) {
      isLoop = false;
      noLoop();
    }
  }

  public void windowDeiconified(WindowEvent e) {
  }

  public void windowIconified(WindowEvent e) {
  }

  public void windowOpened(WindowEvent e) {
  }

  public void componentHidden(ComponentEvent e) {
  }

  public void componentMoved(ComponentEvent e) {
    Component c = e.getComponent();
    x = c.getLocation().x;
    y = c.getLocation().y;
    updateTitle();
  }

  public void componentResized(ComponentEvent e) {
    Component c = e.getComponent();
    // System.out.println("componentResized event from " +
    // c.getClass().getName() + "; new size: " + c.getSize().width
    // + ", " + c.getSize().height);
  }

  public void componentShown(ComponentEvent e) {
    // System.out.println("componentShown event from " +
    // e.getComponent().getClass().getName());
  }

  public void setMode(int theValue) {
    if (theValue == ECONOMIC) {
      myMode = ECONOMIC;
      return;
    }
    myMode = NORMAL;
  }


  public void toggleUndecorated() {
    setUndecorated(!isUndecorated());
  }

  public void setUndecorated(boolean theFlag) {
    if (theFlag != isUndecorated()) {
      isUndecorated = theFlag;
      frame.removeNotify();
      frame.setUndecorated(isUndecorated);
      setSize(width, height);
      setBounds(0, 0, width, height);
      frame.setSize(width, height);
      frame.addNotify();
      requestFocus();
    }
  }


  public boolean isUndecorated() {
    return isUndecorated;
  }

  protected void dispose() {
    stop();
    removeAll();
    frame.removeAll();
    frame.dispose();
  }

  private void launch() {
    GraphicsDevice displayDevice = null;
    if (displayDevice == null) {
      GraphicsEnvironment environment = GraphicsEnvironment.getLocalGraphicsEnvironment();
      displayDevice = environment.getDefaultScreenDevice();
    }

    frame = new Frame(displayDevice.getDefaultConfiguration());
    // remove the grow box by default
    // users who want it back can call frame.setResizable(true)
    frame.setResizable(false);
    init();

    frame.pack(); // get insets. get more.
    frame.setLocation(x,y);
    Insets insets = frame.getInsets();

    int windowW = Math.max(width, MIN_WINDOW_WIDTH) + insets.left + insets.right;
    int windowH = Math.max(height, MIN_WINDOW_HEIGHT) + insets.top + insets.bottom;

    frame.setSize(windowW, windowH);
    frame.setLayout(null);
    frame.add(this);
    int usableWindowH = windowH - insets.top - insets.bottom;
    setBounds((windowW - width) / 2, insets.top + (usableWindowH - height) / 2, width, height);

    frame.addWindowListener(this);
    frame.addComponentListener(this);
    frame.setName(myName);
    frame.setTitle(myName + " x:" + x + " y:" + y + "   w:" + width + " h:" + height);
    frame.setVisible(true);
    requestFocus();
  }
}

