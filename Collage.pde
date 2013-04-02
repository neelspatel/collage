//parameters
PImage img;

int imgh, imgw;

int numPics;

int blocks, rows;
int blockh, blockw;
int newh, neww;

PrintWriter output; //prints output to text files

boolean supersize = true;

void setup()
{
  //img = loadImage("obama.png");  
  //img = loadImage("uf.png");
  //img = loadImage("ying.png");
  //img = loadImage("field.png");
  //img = loadImage("bigisef.png");    
  //img = loadImage("mickey.jpg");      
  //img = loadImage("sts.png");  
  //img = loadImage("bigneil.png");    
  //img = loadImage("dad.png");      
  //img = loadImage("stellar.png");      
  //img = loadImage("flag.jpg");        
  //img = loadImage("harvard.png");   
  //img = loadImage("bigying.png");  
  for(int thisKid = 1; thisKid < 18; thisKid++)
  {
  String thisKidNum = thisKid + "";
  img = loadImage("kid" + thisKidNum + ".png");  
  //img = loadImage("galileo.png");  
  imgh = img.height;
  imgw = img.width;
  
  //size(imgw, imgh);
  //image(img,0,0);

  numPics = 3000;
  rows = ceiling(Math.sqrt(numPics));
  print(rows);

  blockh = ceiling(imgh/rows);  
  blockw = ceiling(imgw/rows);
  
  newh = blockh*rows;
  neww = blockw*rows;
  
  size(neww, newh);
  //image(img,0,0,neww, newh);
  
  //sets tint
  fill(255,255,255,128);
  
 
  
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
    
   //drawing guide lines
  for(int i = 0; i < rows; i++)
  {
    for(int j = 0; j< rows; j++)
    {
      //fill(r[i*rows + j], g[i*rows + j], b[i*rows + j]);
      //rect(i*blockw, j*blockh, blockw, blockh);
    }
  }
  
  PImage neel = loadImage("neel.jpg");
  PImage neil = loadImage("neil.jpg");  
  PImage data = loadImage("data.jpg");    
  PImage star = loadImage("star.png");  
  PImage obama = loadImage("obama.jpg");    
  PImage yale = loadImage("yale.jpg");      
  
  //loads directory of images
  File directory = new File("/Users/neel 1/Documents/Processing/Collage/mom");
  //File directory = new File("/Users/neel 1/Documents/Processing/Collage/sts"); 
  //File directory = new File("/Users/neel 1/Documents/Processing/Collage/isef");   
  //File directory = new File("/Users/neel 1/Documents/Processing/Collage/linds");  
  String[] names = directory.list();
  
  //checks for stupid dsStore
  if(names[0].equals(".DS_Store"))
  {
    names[0] = names[1];
  }
  
  //loads array of images
  PImage[] images = new PImage[names.length];
  for(int i = 0; i < names.length; i++)
  {
    images[i] = loadImage("/Users/neel 1/Documents/Processing/Collage/mom/" + names[i]);
    //images[i] = loadImage("/Users/neel 1/Documents/Processing/Collage/sts/" + names[i]); 
    //images[i] = loadImage("/Users/neel 1/Documents/Processing/Collage/isef/" + names[i]);     
    //images[i] = loadImage("/Users/neel 1/Documents/Processing/Collage/linds/" + names[i]);    
  }
  
  int thisnum = 0, prevnum = 0;
  
  //drawing images
  for(int i = 0; i < rows; i++)
  {
    for(int j = 0; j< rows; j++)
    {
      int total = r[i*rows + j] + g[i*rows + j] + b[i*rows + j];

      if(total < 100)
      {
        tint(r[i*rows + j]+50, g[i*rows + j]+50, b[i*rows + j]+50,200);
      }
      else
      {            
        tint(r[i*rows + j], g[i*rows + j], b[i*rows + j],160);
      }
      //image(yale, i*blockw, j*blockh, blockw, blockh);
      //image(neel, i*blockw, j*blockh, blockw, blockh);
      print((i*rows + j+1) +"\n");
      //PImage current = loadImage("/Users/neel 1/Documents/Processing/Collage/ying/" + names[(i*rows + j+1)%names.length]);
      
      Random rand = new Random();
      prevnum = thisnum;
      //while(thisnum == prevnum)
      {
        //thisnum = rand.nextInt((i*rows + j+1)%names.length+1);
      }
      PImage current = images[rand.nextInt((i*rows + j+1)%names.length+1)];
      //PImage current = images[(i*rows + j+1)%names.length];      
      image(current, i*blockw, j*blockh, blockw, blockh);      
    }
  }
  
  saveFrame("kid" + thisKidNum +  "-####.jpg");
  
  //print color values
  output = createWriter("colors.txt");
  
  for(int i = 0; i < rows; i++)
  {
    output.print((i+1) + "\t");
    for(int j = 0; j< rows; j++)
    {
      output.print("(" + r[i*rows + j]+ "," + g[i*rows + j] + "," + b[i*rows + j] + ")\t");
    }
    output.println();
  }
  }
  
  
}

static int ceiling(double num)
{
  int low = (int) num;
  if(low == num)
    return low;
  else
    return low+1;
}
