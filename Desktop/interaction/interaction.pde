import SimpleOpenNI.*;
SimpleOpenNI  context;

import java.awt.*;
import java.util.Arrays;

int art_version = 1;


float zoomF = 0.5f;
float rotX = radians(180);
float rotY = radians(0);

boolean      autoCalib=true;

PVector      bodyCenter = new PVector();
PVector      bodyDir = new PVector();
PVector      com = new PVector();                                   
PVector      com2d = new PVector();                                   
color[]       userClr = new color[] { 
  color(255, 255, 100), 

};


// shoho hamon global
PImage img;
Ripple ripple;

// yukie ballchase global
ArrayList <Mover> bouncers;
int bewegungsModus = 0;
boolean transparentBG = true;
boolean transkey;
boolean mousebew;
float righthandX, righthandY;

int frame_balls;

// sho raining global
Spot foo[] = new Spot[100]; 
int sizeX = displayWidth;
int sizeY = displayHeight;
int r1 = 170;
int g1 = 201;
int b1 = 156;
int r2 = 0;
int g2 = 199;
int b2 = 226;
int a = 150;
int backc = 188;
float BARhite = 0.0769;
int flag =  -1 ;

int maxRadius;
float interfaceW;
float interfaceH;

//float barwidth;
//float barheight;
float topbarW;
float topbarH;
float speed;

// take hand pos
PVector left = new PVector();
PVector right = new PVector();
PVector head = new PVector();
float ly;
float lly = 0.0;
float lx;
float llx = 0.0;
float ry;
float lry = 0.0;
float rx;
float lrx = 0.0;
float hx = 0.0;
float lhx = 0.0;
int X;


//gaia drawLines
float x, y, angle, c_pri;
float x_sub, y_sub, angle_sub, c_sub;
variateur v1, v2;
PVector lastRH;
float lastDistLE, lastDistRE;
PVector velRH = new PVector(0, 0, 0);
boolean flag_gaia = false;
//boolean flip = false;
int step = 0;


// kukky project
int version = 1;

int jointNum = 15;
int pointNum = 800;

PVector[][][] pos = new PVector[6][jointNum][pointNum];
PVector[][][] v = new PVector[6][jointNum][pointNum];
float[][][] err = new float[6][jointNum][pointNum];
float[][][] w = new float[6][jointNum][pointNum];
float[][][] p = new float[6][jointNum][pointNum];
float[][][] c = new float[6][jointNum][pointNum];

ArrayList[][] trackParticles = new ArrayList[6][jointNum];
int[][] userColor = new int[6][jointNum];
boolean[] isEmit = new boolean[6];
int[] emissions = new int[6];
PVector[][] savePos = new PVector[6][jointNum];

int[] userLimbOrder = {
  1, 2, 3, 4, 5, 6
};
int[][] limbOrder = new int[6][jointNum];




void init() {
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup() {
  if (art_version == 1) {

    // shoho hamon

    context = new SimpleOpenNI(this);
    context.enableDepth();
    context.enableUser();
    
    float rotX = radians(180);

    img = loadImage("data/rainbow.jpeg");
    img.resize(displayWidth, displayHeight);
    //  img.resize(1920, 1080);
    //  size(img.width, img.height, P3D);
    size(displayWidth, displayHeight, P3D);
    frame.setLocation(0, 0);

    perspective(radians(30), 
    float(width)/float(height), 
    10, 150000);
    background(0);
    ripple = new Ripple();
    frameRate(120);
  } else if (art_version == 2) {


    //yukie ballchase

    frame_balls = 0;

    textSize(25);
    
    float rotX = radians(180);


    righthandX = width/2;
    righthandY = height/2;

    size(displayWidth, displayHeight, P3D);  // strange, get drawing error in the cameraFrustum if i use P3D, in opengl there is no problem
    frame.setLocation(0, 0);
    smooth();

    bouncers = new ArrayList();
    for (int i = 0; i < 500; i++)
    {
      Mover m = new Mover();
      bouncers.add (m);
    }

    background(#57385c);
    frameRate(20);


    context = new SimpleOpenNI(this);
    if (context.isInit() == false)
    {
      println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
      exit();
      return;
    }

    // disable mirror
    context.setMirror(true);

    // enable depthMap generation 
    context.enableDepth();

    // enable skeleton generation for all joints
    context.enableUser();

    stroke(255, 255, 255);
    smooth();  
    perspective(radians(45), 
    float(width)/float(height), 
    10, 150000);
  } else if (art_version == 3) {
    
    // sho raining

    context = new SimpleOpenNI(this);
    context.enableDepth();
    context.enableUser(); 
    
    print("Here");
    rotX = radians(0);
    size(displayWidth, displayHeight, P3D);

    perspective(radians(45), float(width)/float(height), 10, 150000);
    background(0);
    frameRate(100);

    
    print("Here");

    // barwidth = 0.04;
    // barheight = 0.5;
    // interfaceW = width;
    // interfaceH = BARhite*height;
    // topbarW = barheight*width;
    // topbarH = barwidth*height;
    maxRadius = 75;
    speed = 3.0; // from 0-1

    // fill(255,0,0);
    // rect(0,0,0.02*width, interfaceH);
    
        print("Here");

    // Whenever you want to do something to all your spots you need to iterate through the array:
    for (int i=0; i<foo.length; i++) {
      
          
    print("Here");
    
      // create a random colour.  By limiting r and g and setting a minimum for b we should get a selection of blues
      // while I adjusted color for the circles later, i couldn't delete this area without losing it all
      int r = (int) random(255);
      int g = (int) random(255);
      int b = (int) random(255);
      color colour = color(r, g, b);
      // create the Spot objects:
      foo[i] = new Spot(random(-2*width,2*width), -1.1 * height, random(maxRadius), colour);
    }


    smooth();
  } else if (art_version == 4) {
    
    // gaia drawlines
    
    float rotX = radians(180);

    size(displayWidth, displayHeight, P3D);
    //size(1020, 720, P3D);
    frame.setLocation(0, 0);   // strange, get drawing error in the cameraFrustum if i use P3D, in opengl there is no problem
    context = new SimpleOpenNI(this);
    if (context.isInit() == false)
    {
      println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
      exit();
      return;
    }

    x = width/2;
    y = height/2;
    angle = random(TWO_PI);
    x_sub = width/2;
    y_sub = height/2;
    angle_sub = -angle; 
    smooth(); 
    noFill();
    stroke(0, 51);
    colorMode(HSB);
    c_pri=random(255);
    c_sub=random(255);
    background(0);  
    v1=new variateur(1, 6, 79); 
    v2=new variateur(1, 6, 79);
    textSize(20);

    // disable mirror
    context.setMirror(false);

    // enable depthMap generation 
    context.enableDepth();

    // enable skeleton generation for all joints
    context.enableUser();

    //  stroke(255,255,255);
    smooth();  
    perspective(radians(45), 
    float(width)/float(height), 
    10, 150000);
  } else if (art_version == 5) {
    
    float rotX = radians(180);

    size(1440, 900, P3D);  // strange, get drawing error in the cameraFrustum if i use P3D, in opengl there is no problem
    context = new SimpleOpenNI(this);
    if (context.isInit() == false)
    {
      println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
      exit();
      return;
    }

    // disable mirror
    context.setMirror(false);

    // enable depthMap generation 
    context.enableDepth();

    // enable skeleton generation for all joints
    context.enableUser();

    stroke(255, 255, 255);
    smooth();  
    perspective(radians(45), 
    float(width)/float(height), 
    10, 150000);

    v1InitMovePoints();
    background(0, 0, 0);
  }
}


void draw() {
  if (art_version == 1) {

    // shoho hamon
    context.update();

    loadPixels();
    img.loadPixels();
    for (int loc = 0; loc < width * height; loc++) {
      pixels[loc] = ripple.col[loc];
    }

    short ripplemap[];
    ripplemap = ripple.ripplemap;
    int sum = 0;
    for (int i=0; i<ripplemap.length; i++) {
      sum += abs(int(ripplemap[i]));
    }
    sum /= (width*height);
    //  println((int)((random(sum)/53)*255));
    updatePixels();
    ripple.newframe();

    // set the scene pos
    translate(width/2, height/2, 0);
    rotateX(rotX);
    rotateY(rotY);
    scale(-1, 1);
    scale(zoomF);

    int[]   depthMap = context.depthMap();
    int[]   userMap = context.userMap();
    int     steps   = 2;  // to speed up the drawing, draw every third point
    int     index;
    PVector realWorldPoint;

    translate(0, 0, -1000);  // set the rotation center of the scene 1000 infront of the camera

    // draw the pointcloud
    beginShape(POINTS);
    //  stroke((int)((random(sum)/53)*255), 0, 0);
    for (int y=0; y < context.depthHeight (); y+=steps) {
      for (int x=0; x < context.depthWidth (); x+=steps)
      {
        index = x + y * context.depthWidth();
        if (depthMap[index] > 0)
        { 
          // draw the projected point
          realWorldPoint = context.depthMapRealWorld()[index];
          if (userMap[index] != 0) {
            //          colorMode(HSB, 100);
            //          stroke(255, 255, 255);
            //          if (random(52)<sum){
            //            stroke(255-(int)((random(sum)/53)*255), 0, 0);
            ////            stroke(255-(int)((random(sum)/53)*255), 255-(int)((random(sum)/53)*255), 255-(int)((random(sum)/53)*255)); 
            //          }else{
            //            stroke(255, 255, 255);
            //          }

            stroke(255, 255, 255);
            strokeWeight(2);
            //          stroke(255-(int)((random(sum)/53)*255), 0, 0); 
            //          ellipse(width/2, height/2, 150, 150);     
            vertex(realWorldPoint.x, realWorldPoint.y, realWorldPoint.z);
          }
        }
      }
    } 
    endShape();

    int[] userList = context.getUsers();
    for (int i=0; i<userList.length; i++) {
      if (context.isTrackingSkeleton(userList[i])) {
        PVector left = new PVector();
        PVector right = new PVector();
        context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, left);
        context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, right);
        disturbrip(int(-left.x/2+width/2), int(-left.y/2+height/2));
        disturbrip(int(-right.x/2+width/2), int(-right.y/2+height/2));
      }
    }
  } else if (art_version == 2) {

    // yukie ballchase

    // update the cam
    context.update();

    // set the scene pos

    int[]   depthMap = context.depthMap();
    int[]   userMap = context.userMap();
    int     steps   = 3;  // to speed up the drawing, draw every third point
    int     index;
    PVector realWorldPoint;

    //addkey();
    
    checkkeys();
    transkey();
    mousebew();
    drawballs();

    // draw the kinect cam
    //context.drawCamFrustum();

    translate(width/2, height/2, 0);
    rotateX(rotX);
    rotateY(rotY);
    scale(zoomF);

    translate(0, 0, -1000);  // set the rotation center of the scene 1000 infront of the camera



    // draw the pointcloud
    beginShape(POINTS);
    for (int y=0; y < context.depthHeight (); y+=steps)
    {
      for (int x=0; x < context.depthWidth (); x+=steps)
      {
        index = x + y * context.depthWidth();
        if (depthMap[index] > 0)
        { 
          // draw the projected point
          realWorldPoint = context.depthMapRealWorld()[index];
          strokeWeight(3);
          if (userMap[index] == 0)
            stroke(100); 
          else
            stroke(userClr[ (userMap[index] - 1) % userClr.length ]);        

          point(realWorldPoint.x, realWorldPoint.y, realWorldPoint.z);
        }
      }
    }
    endShape();

    frame_balls++;
  } else if (art_version == 3) {

    // sho raining

    context.update();
    loadPixels();
    updatePixels();

    // draw the kinect cam
    context.drawCamFrustum();

    // set the scene pos
    translate(width/2, height/2, 0);
    rotateX(rotX);
    rotateY(rotY);
    scale(zoomF);
    scale(1,-1);
    stroke(255);
    strokeWeight(2);
    line(-width/2, 0, width/2, 0);
    line(0, -height/2, 0, height/2);
    background(backc);

    int[]   depthMap = context.depthMap();
    int[]   userMap = context.userMap();
    int     steps = 3;
    int     index;
    PVector realWorldPoint;

    translate(0, 0, -1000);

    int[] userList = context.getUsers();
    for (int i=0; i<userList.length; i++) {
      // calc speed
      speed += 0.05;
      speed *= 0.95;
      if (context.isTrackingSkeleton(userList[i])) {
        context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, left);
        context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, right);
        context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_HEAD, head);

        // get hands positions
        ly = -(left.y)/2 + 150;
        lx = -left.x;
        ry = -(right.y)/2 + 150;
        rx = -right.x;
        hx = -head.x;

        // chage spots direction
        for (int j =0; j<foo.length; j++) {
          if ((hx + 50.0) > (lhx)) {
            foo[j].posite();
          } else if ((hx + 50.0) < lhx) {
            foo[j].negate();
          }
        }

        // calc speed
        speed += (calcSpeed(lx, ly, llx, lly) + calcSpeed(rx, ry, lry, lrx))/1000;

        // get last hands positions
        lly = ly;
        llx = lx;
        lry = ry;
        lrx = rx;
        lhx = hx;

        if (left.dist(right) < 80) {
          mouseClicked();
        }

        println("left_hand X: " +lx + " Y: "+ ly);
        println("right_hand X: "+ rx+ " Y: " + ry);
      }
    }

    if (flag == 0) {
      X = int(rx);
    } else {
      X = int(width - rx);
    }

    //begin "if mouse gets near edges do controls of inner and outer circles
    if (ly > ((1-BARhite)*height)) {
      backc = ((255*X)/width); //change background shade
    }

    //red TOP -- INNER CIRCLE
    if (ly  < BARhite*height) { //outer circle, red control
      r2 = ((255*X)/width);
    }

    //blue TOP -- OUT CIRCLE
    if (ly > (BARhite*height) && ly < (2*BARhite*height)) {
      b1 = ((255*X)/width);
    } 

    //green TOP -- INNER CIRCLE
    if (ly  > (2*BARhite*height) && ly < (3*BARhite*height)) {
      g2 = ((255*X)/width);
    }

    //red SECOND -- OUTER CIRCLE
    if (ly  > (3*BARhite*height) && ly < (4*BARhite*height)) { //outer circle, red control
      r1 = ((255*X)/width);
    }

    //blue SECOND -- INNER CIRCLE
    if (ly  > (4*BARhite*height) && ly < (5*BARhite*height)) {
      b2 = ((255*X)/width);
    }

    //green SECOND -- INNER CIRCLE
    if (ry > (5*BARhite*height) && ry < (6*BARhite*height)) {
      g2 = ((255*X)/width);
    }   

    //red THIRD -- OUTER CIRCLE
    if (ry > (6*BARhite*height) && ry < (7*BARhite*height)) { //outer circle, red control
      backc = ((255*X)/width); //change background shade
    }

    //blue SECOND -- INNER CIRCLE
    if (ry > (7*BARhite*height) && ry < (8*BARhite*height)) {
      b2 = ((255*X)/width);
    }    

    //green TIHRD -- OUTER CIRCLE
    if (ry > (8*BARhite*height) && ry < (9*BARhite*height)) {
      g1 = ((255*X)/width);
    }

    //red 4th -- INNER CIRCLE
    if (ry > (9*BARhite*height) && ry < (10*BARhite*height)) { //outer circle, red control
      r2 = ((255*X)/width);
    }

    //blue 4th -- OUTER CIRCLE
    if (ry > (10*BARhite*height) && ry < (11*BARhite*height)) {
      b1 = ((255*X)/width);
    }

    //green 4th -- INNER CIRCLE
    if (ry > (11*BARhite*height) && ry < (12*BARhite*height)) {
      g2 = ((255*X)/width);
    }   

    // display the spots:
    for (int i=0; i<foo.length; i++) {
      foo[i].display();
    }

    println("mouse pos X: "+ mouseX + "Y: " + mouseY);
  } else if (art_version == 4) {

    context.update();
    int[] userList = context.getUsers();


    boolean from_center = false;
    boolean flip = false;

    for (int i=0; i<userList.length; i++)
    {
      if (context.isTrackingSkeleton(userList[i])) {
        PVector posRH = new PVector();
        PVector posLH = new PVector();
        PVector posLE = new PVector();
        PVector posRE = new PVector();
        context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, posRH);
        context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, posLH);
        context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_ELBOW, posLE);
        context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_ELBOW, posRE);

        if (posRH.dist(posLH) < 80) {
          background(0, 0, 0);
          from_center = true;
        }

        if ( lastDistLE >= 150 && posLE.dist(posRH) < 150) {
          flip = true;
        }
        lastDistLE = posLE.dist(posRH);

        if ( lastDistRE >= 150 && posRE.dist(posLH) < 150) {
          from_center = true;
        }
        lastDistRE = posRE.dist(posLH);


        if (!flag_gaia) {
          velRH.x = 0;
          velRH.y = 0;
          velRH.z = 0;
          flag_gaia = true;
        } else {
          velRH.x = posRH.x - lastRH.x;
          velRH.y = posRH.y - lastRH.y;
          velRH.z = posRH.z - lastRH.z;
        }
        lastRH = posRH;
        //drawLine(velRH.mag());
      } else {
        //text("Skeleton tracking -incompleted-", width/4, height/4);
        velRH.x = 0;
        velRH.y = 0;
        velRH.z = 0;
        flag_gaia = false;
      }
    }
    if (step == 0 || step == 1600 || from_center) {
      drawLine(velRH.mag(), step, flip, true);
    } else {
      drawLine(velRH.mag(), step, flip, false);
    }

    if (step == 2000) {
      step = 0;
    } else {
      step += 1;
    }
  } else if (art_version == 5) {

    switch (version) {
    case 1:
      version1();
      break;
    case 2:
      version2();
      break;
    case 3:
      version3();
      break;
    default :
      version1();
      break;
    }
  }
}


// -----------------------------------------------------------------
// SimpleOpenNI user events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


// -----------------------------------------------------------------


//shoho hamon

class Ripple {
  int i, a, b;
  int oldind, newind, mapind;
  short ripplemap[]; // the height map
  int col[]; // the actual pixels
  int riprad;
  int rwidth, rheight;
  int ttexture[];
  int ssize;

  Ripple() {
    // constructor
    riprad = 4;
    rwidth = width >> 1;
    rheight = height >> 1;
    ssize = width * (height + 2) * 2;
    ripplemap = new short[ssize];
    col = new int[width * height];
    ttexture = new int[width * height];
    oldind = width;
    newind = width * (height + 3);
  }



  void newframe() {
    // update the height map and the image
    i = oldind;
    oldind = newind;
    newind = i;

    i = 0;
    mapind = oldind;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        short data = (short)((ripplemap[mapind - width] + ripplemap[mapind + width] + 
          ripplemap[mapind - 1] + ripplemap[mapind + 1]) >> 1);
        data -= ripplemap[newind + i];
        data -= data >> 6;
        if (x == 0 || y == 0) // avoid the wraparound effect
          ripplemap[newind + i] = 0;
        else
          ripplemap[newind + i] = data;

        // where data = 0 then still, where data > 0 then wave
        data = (short)(1024 - data);

        // offsets
        a = ((x - rwidth) * data / 1024) + rwidth;
        b = ((y - rheight) * data / 1024) + rheight;

        //bounds check
        if (a >= width) 
          a = width - 1;
        if (a < 0) 
          a = 0;
        if (b >= height) 
          b = height-1;
        if (b < 0) 
          b=0;

        col[i] = img.pixels[a + (b * width)];
        mapind++;
        i++;
      }
    }
  }
}

void disturbrip(int x, int y) {
  for (int j = y - ripple.riprad; j < y + ripple.riprad; j++) {
    for (int k = x - ripple.riprad; k < x + ripple.riprad; k++) {
      if (j >= 0 && j < height && k>= 0 && k < width) {
        ripple.ripplemap[ripple.oldind + (j * width) + k] += 512;
      }
    }
  }
}

// yukie ballchase

void addkey() {
  if ( frame_balls % 150 == 0 ) {
    if ( bewegungsModus == 0 ) {
      bewegungsModus = 1;
      background(#57385c);  //navy
    } else {
      bewegungsModus = 0;
      background(#008b8b);  //dark green
    }
  }
}


void drawballs() {
  if (transparentBG)
  {

    // fill (#57385c, 40);
    noStroke();
    if (bewegungsModus == 0) {
      fill(#57385c, 60);  //navy
    } else if (bewegungsModus ==1 ) {
      fill(#008b8b, 60);
    } else if (bewegungsModus == 2) {
      fill(#483d8b, 60);  //blue
    } else if (bewegungsModus == 3 ) {
      fill(#8b008b, 60);  //purple
    } else {
      fill(#8b4513, 60);   //brown
    }
    rect (0, 0, width, height);
  } 
  //else background (#57385c);

  int i = 0;
  while (i < bouncers.size () )
  {
    Mover m = bouncers.get(i);
    if (bewegungsModus != 5) m.update (bewegungsModus);
    else
    {
      m.flock (bouncers);
      m.move();
      m.checkEdges();
      m.display();
    }
    i = i + 1;
  }
}


void checkkeys() {
  //  int righthand = SimpleOpenNI.SKEL_RIGHT_HAND;
  //  print(righthand);
  //mousebew = false;

  int[] userList = context.getUsers();

  for (int i=0; i<userList.length; i++) {
    if (context.isTrackingSkeleton(userList[i])) {
      PVector righthand_PV = new PVector(0, 0, 0);
      PVector lefthand_PV = new PVector(0, 0, 0);
      PVector head_PV = new PVector(0, 0, 0);
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, righthand_PV);
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, lefthand_PV);
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_HEAD, head_PV);
      //print(1);     
      if ( lefthand_PV == null || righthand_PV == null) {
        //print("null");
      } else {
        //print( lefthand_PV.y );
        //print( head_PV.y );
        if ( lefthand_PV.dist( righthand_PV ) < 80 ) {
          //mousebew = true;
          if ( bewegungsModus == 0 ) {
            bewegungsModus = 1;
            background(#57385c);  //navy
          }else {
            bewegungsModus = 0;
            background(#008b8b);  //dark green
          }
          delay(300);
          //          delay(700);
          //print("left>head");
        }
      }

      if ( righthand_PV == null) {
      } else {
        righthandX = ( righthand_PV.x /4  + width /2  );
        righthandY = - ( righthand_PV.y /4  - height/2 );
      }
    }
  }
}


void transkey()
{
  if (transkey == false) transparentBG = !transparentBG;
  if (transkey == true)
  {
    float noiseScale = random (5, 400);
    float noiseStrength = random (0.5, 6);
    float forceStrength = random (0.5, 4);

    for (int i = 0; i < bouncers.size (); i++)
    {
      Mover currentMover = bouncers.get(i);
      currentMover.noiseScale = noiseScale;
      currentMover.noiseStrength = noiseStrength;
      currentMover.forceStrength = forceStrength;
    }
  }
}

void mousebew()
{
  if (mousebew == true)
  {
    bewegungsModus++;

    if (bewegungsModus > 1)
    {
      bewegungsModus = 0;
    }

    if (bewegungsModus == 0) {
      background(#57385c);  //navy
    } else if (bewegungsModus ==1 ) {
      background(#008b8b);  //dark green
    } else if (bewegungsModus == 2) {
      background(#483d8b);  //blue
    } else if (bewegungsModus == 3 ) {
      background(#8b008b);  //purple
    } else {
      background(#8b4513); //brown
    }
  }
}

//mover class
class Mover
{
  PVector direction;
  PVector location;

  float speed;
  float SPEED;

  float noiseScale;
  float noiseStrength;
  float forceStrength;

  float ellipseSize;

  color c;


  Mover () // Konstruktor = setup der Mover Klasse
  {
    setRandomValues();
  }

  Mover (float x, float y) // Konstruktor = setup der Mover Klasse
  {
    setRandomValues ();
  }

  // SET ---------------------------

  void setRandomValues ()
  {
    location = new PVector (random (width), random (height));
    ellipseSize = random (4, 15);

    float angle = random (TWO_PI);
    direction = new PVector (cos (angle), sin (angle));

    speed = random (4, 7);
    SPEED = speed;
    noiseScale = 80;
    noiseStrength = 1;
    forceStrength = random (0.1, 0.2);

    setRandomColor();
  }

  void setRandomColor ()
  {
    int colorDice = (int) random (4);

    if (colorDice == 0) c = #ffedbc;
    else if (colorDice == 1) c = #A75265;
    else if (colorDice == 2) c = #ec7263;
    else c = #febe7e;
  }

  // GENEREL ------------------------------

  void update ()
  {
    update (0);
  }

  void update (int mode)
  {
    if (mode == 0) // bouncing ball
    {
      speed = SPEED * 0.7;
      move();
      checkEdgesAndBounce();
    } else if (mode == 2) // noise
    {
      speed = SPEED * 0.7;
      addNoise ();
      move();
      checkEdgesAndRelocate ();
    } else if (mode == 1) // steer
    {
      steer (righthandX, righthandY);
      move();
    } else if (mode == 3) // seek
    {
      speed = SPEED * 0.7;
      seek (righthandX, righthandY);
      move();
    } else // radial
    {
      speed = SPEED * 0.7;
      addRadial ();
      move();
      checkEdges();
    }

    display();
  }

  // FLOCK ------------------------------

  void flock (ArrayList <Mover> boids)
  {

    PVector other;
    float otherSize ;

    PVector cohesionSum = new PVector (0, 0);
    float cohesionCount = 0;

    PVector seperationSum = new PVector (0, 0);
    float seperationCount = 0;

    PVector alignSum = new PVector (0, 0);
    float speedSum = 0;
    float alignCount = 0;

    for (int i = 0; i < boids.size (); i++)
    {
      other = boids.get(i).location;
      otherSize = boids.get(i).ellipseSize;

      float distance = PVector.dist (other, location);


      if (distance > 0 && distance <70) //align + cohesion
      {
        cohesionSum.add (other);
        cohesionCount++;

        alignSum.add (boids.get(i).direction);
        speedSum += boids.get(i).speed;
        alignCount++;
      }

      if (distance > 0 && distance < (ellipseSize+otherSize)*1.2) // seperate bei collision
      {
        float angle = atan2 (location.y-other.y, location.x-other.x);

        seperationSum.add (cos (angle), sin (angle), 0);
        seperationCount++;
      }

      if (alignCount > 8 && seperationCount > 12) break;
    }

    // cohesion: bewege dich in die Mitte deiner Nachbarn
    // seperation: renne nicht in andere hinein
    // align: bewege dich in die Richtung deiner Nachbarn

    if (cohesionCount > 0)
    {
      cohesionSum.div (cohesionCount);
      cohesion (cohesionSum, 1);
    }

    if (alignCount > 0)
    {
      speedSum /= alignCount;
      alignSum.div (alignCount);
      align (alignSum, speedSum, 1.3);
    }

    if (seperationCount > 0)
    {
      seperationSum.div (seperationCount);
      seperation (seperationSum, 2);
    }
  }

  void cohesion (PVector force, float strength)
  {
    steer (force.x, force.y, strength);
  }

  void seperation (PVector force, float strength)
  {
    force.limit (strength*forceStrength);

    direction.add (force);
    direction.normalize();

    speed *= 1.1;
    speed = constrain (speed, 0, SPEED * 1.5);
  }

  void align (PVector force, float forceSpeed, float strength)
  {
    speed = lerp (speed, forceSpeed, strength*forceStrength);

    force.normalize();
    force.mult (strength*forceStrength);

    direction.add (force);
    direction.normalize();
  }

  // HOW TO MOVE ----------------------------

  void steer (float x, float y)
  {
    steer (x, y, 1);
  }

  void steer (float x, float y, float strength)
  {

    float angle = atan2 (y-location.y, x -location.x);

    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength * strength);

    direction.add (force);
    direction.normalize();

    float currentDistance = dist (x, y, location.x, location.y);

    if (currentDistance < 70)
    {
      speed = map (currentDistance, 0, 70, 0, SPEED);
    } else speed = SPEED;
  }

  void seek (float x, float y)
  {
    seek (x, y, 1);
  }

  void seek (float x, float y, float strength)
  {

    float angle = atan2 (y-location.y, x -location.x);

    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength * strength);

    direction.add (force);
    direction.normalize();
  }

  void addRadial ()
  {

    float m = noise (frameCount / (2*noiseScale));
    m = map (m, 0, 1, - 1.2, 1.2);

    float maxDistance = m * dist (0, 0, width/2, height/2);
    float distance = dist (location.x, location.y, width/2, height/2);

    float angle = map (distance, 0, maxDistance, 0, TWO_PI);

    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength);

    direction.add (force);
    direction.normalize();
  }

  void addNoise ()
  {
    float noiseValue = noise (location.x /noiseScale, location.y / noiseScale, frameCount / noiseScale);
    noiseValue*= TWO_PI * noiseStrength;

    PVector force = new PVector (cos (noiseValue), sin (noiseValue));
    //Processing 2.0:
    //PVector force = PVector.fromAngle (noiseValue);
    force.mult (forceStrength);
    direction.add (force);
    direction.normalize();
  }

  // MOVE -----------------------------------------

  void move ()
  {
    PVector velocity = direction.get();
    velocity.mult (speed);
    location.add (velocity);
  }

  // CHECK --------------------------------------------------------

  void checkEdgesAndRelocate ()
  {
    float diameter = ellipseSize;

    if (location.x < -diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
    } else if (location.x > width+diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
    }

    if (location.y < -diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
    } else if (location.y > height + diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
    }
  }


  void checkEdges ()
  {
    float diameter = ellipseSize;

    if (location.x < -diameter / 2)
    {
      location.x = width+diameter /2;
    } else if (location.x > width+diameter /2)
    {
      location.x = -diameter /2;
    }

    if (location.y < -diameter /2)
    {
      location.y = height+diameter /2;
    } else if (location.y > height+diameter /2)
    {
      location.y = -diameter /2;
    }
  }

  void checkEdgesAndBounce ()
  {
    float radius = ellipseSize / 2;

    if (location.x < radius )
    {
      location.x = radius ;
      direction.x = direction.x * -1;
    } else if (location.x > width-radius )
    {
      location.x = width-radius ;
      direction.x *= -1;
    }

    if (location.y  < radius )
    {
      location.y = radius ;
      direction.y *= -1;
    } else if (location.y  > height-radius )
    {
      location.y = height-radius ;
      direction.y *= -1;
    }
  }

  // DISPLAY ---------------------------------------------------------------
  void display ()
  {
    noStroke();
    fill (c);
    ellipse (location.x, location.y, ellipseSize, ellipseSize);
  }
}


//sho raining

void mouseClicked() {
  if (art_version == 3) {
    if (flag == 0) {
      flag = -1;
      println(flag);
    } else {
      flag = 0;
      println(flag);
    }
  }
}

float calcSpeed(float X, float Y, float x, float y) {
  float speed = 0;
  speed = sqrt(sq((X - x)) + sq((Y - y)));
  return speed;
}

class Spot {
  float x, y, radius;
  float vx, vy; // to store velocities
  color colour;

  Spot(float xpos, float ypos, float r, color c) {
    x = xpos;
    y = -ypos;
    vx = random(-1, 1);  // create small random horizontal velocity
    vy = 1 + random(3);  // set a vertical velocity
    radius = r;
    colour = c;
  }

  void posite() {
    vx = abs(vx);
  }

  void negate() {
    vx = -abs(vx);
  }

  void display() {
    println("particle pos X:"+ x + " Y :" + y);
    color from = color(r1, g1, b1, a);
    color to = color(r2, g2, b2, a);
    color interA = lerpColor(from, to, .25);
    color interB = lerpColor(from, to, .5);
    color interC = lerpColor(from, to, .75);

    noStroke();

    fill(from);
    ellipse(x, y, radius*2.8, radius*2.0);

    fill(interA);
    ellipse(x, y, radius*2.6, radius*2.4);

    fill(interB);
    ellipse(x, y, radius*2.4, radius*2.8);

    fill(interC);
    ellipse(x, y, radius*2.2, radius*3.2);

    fill(to);
    ellipse(x, y, radius*3.0, radius*4.0);
    x += 2*vx*speed;
    y -= vy*speed; 

    // If they go beyond the bottom of the screen one option is to simply place them back at the top:
    print(height * 1.1);
    if (y < -height *1.1 - (maxRadius * 5)) {
      // by resetting all these it will look like a different ball
      int r = (int) random(255);
      int g = (int) random(255);
      int b = (int) random(255);
      colour = color(r, g, b);
      radius = 1+random(75);
      vx = random(-1, 1);  // create small random horizontal velocity
      vy = 1 + random(3);  // set a vertical velocity
      x = random(-2*width, 2*width);
      y = 1.1*height;
    }
  }
}  

// gaia drawlines

void drawRect(int col, int x, int y) {
  fill(col, 200, 255, 51);
  rect(x, y, 60, 60);
}

void drawLine(float velocity, int step, boolean flip, boolean restart) { 
  
  
  velocity=constrain(velocity, 0, 100);

  updateXY(velocity, 0.2, 2, 0.5, 0.04);
  //float velocity, float color_speed, float angle_speed, float natural, float manual

  //flip colors
  if (flip) {
    c_pri = 255 - c_pri;
    c_sub = 255 - c_sub;
  }

  //go to the center again
  if (restart) {
    x = width/2;
    y = height/2;
    x_sub = width/2;
    y_sub = height/2;
    angle = random(TWO_PI);
    angle_sub = -angle;
  }

  if (step <= 1600) {
    drawXY(x, y, c_pri, false);
    drawXY(x_sub, y_sub, c_sub, false);
  } else {
    drawXY(x, y, c_pri, true);
    drawXY(x_sub, y_sub, c_sub, true);
  }
}

void updateXY(float velocity, float color_speed, float angle_speed, float natural, float manual) {
  c_pri+=random(0.1, 0.5) * color_speed;
  c_sub+=random(0.1, 0.5) * color_speed;
  if (c_pri>255) {
    c_pri-=255;
  }
  if (c_sub>255) {
    c_sub-=255;
  }

  angle+=random(-0.1, 0.1) * angle_speed;
  angle_sub+=random(-0.1, 0.1) * angle_speed;

  x=constrain(x+cos(angle) * natural + cos(angle)*manual*(velocity), 0, width);
  y=constrain(y+sin(angle) * natural + sin(angle)*manual*(velocity), 0, height);
  x_sub=constrain(x_sub+cos(angle_sub) * natural + cos(angle_sub)*manual*(velocity), 0, width);
  y_sub=constrain(y_sub+sin(angle_sub) * natural + sin(angle_sub)*manual*(velocity), 0, height);
  if ((random(100)<2)||x==0||y==0||x==width||y==height) {
    angle+=random(-1, 1);
  }
  if ((random(100)<2)||x_sub==0||y_sub==0||x_sub==width||y_sub==height) {
    angle_sub+=random(-1, 1);
  }
}



void drawXY(float x, float y, float col, boolean dark) {
  strokeWeight(3);
  if (dark) {
    stroke(col, 200, 50, 51);
  } else {
    stroke(col, 200, 255, 51);
  }
  float t1 = v1.avance();
  float t2 = v2.avance();
  float an = atan2(y-height/2, x-width/2);
  float p1x=width/2+(x-width/2)*0.3;
  float p1y=height/2+(y-height/2)*0.3;
  float p2x=width/2+(x-width/2)*0.6;
  float p2y=height/2+(y-height/2)*0.6;
  beginShape();
  curveVertex(width/2, height/2);
  curveVertex(width/2, height/2);
  curveVertex(p1x+cos(an+PI/2)*t1, p1y+sin(an+PI/2)*t1);
  curveVertex(p2x+cos(an-PI/2)*t2, p2y+sin(an-PI/2)*t2);
  curveVertex(x, y);
  curveVertex(x, y);
  endShape();
}


class variateur {
  float etat, mini, maxi, pas, ecart, v;
  variateur(float _min, float _max, float _pas) {
    ecart=(_max-_min)/2;
    mini=_min+ecart;
    etat = random(-1, 1);
    v=random(0.01, 0.02);
  }
  float avance() {
    etat+=v;
    return (mini+cos(etat)*ecart);
  }
}


// kukky project

void version1()
{
  // update the cam
  context.update();

  background(0, 0, 0);

  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);
  scale(-1, 1);

  int[]   depthMap = context.depthMap();
  int[]   userMap = context.userMap();
  int     steps   = 3;  // to speed up the drawing, draw every third point
  int     index;
  PVector realWorldPoint;

  translate(0, 0, -1000);  // set the rotation center of the scene 1000 infront of the camera

  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for (int i=0; i<userList.length; i++)
  {
    if (context.isTrackingSkeleton(userList[i]))
      v1DrawSkeleton(userList[i]);
  }    

  if (frameCount % 600 == 0) {
    int[] users = Arrays.copyOf(userList, userList.length);
    v1Shuffle(users);
    for (int i=0; i<6; i++) {
      v1Shuffle(limbOrder[i]);
      if (i<users.length) {
        userLimbOrder[i] = users[i];
      } else {
        userLimbOrder[i] = i+1;
      }
    }
  }
}

// draw the skeleton with the selected joints
void v1DrawSkeleton(int userId)
{
  // to get the 3d joint data
  v1DrawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK, limbOrder[userId][0]);

  v1DrawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER, limbOrder[userId][1]);
  v1DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW, limbOrder[userId][2]);
  v1DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND, limbOrder[userId][3]);

  v1DrawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER, limbOrder[userId][4]);
  v1DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW, limbOrder[userId][5]);
  v1DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND, limbOrder[userId][6]);

  v1DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO, limbOrder[userId][7]);
  v1DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO, limbOrder[userId][8]);

  v1DrawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP, limbOrder[userId][9]);
  v1DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE, limbOrder[userId][10]);
  v1DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT, limbOrder[userId][11]);

  v1DrawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP, limbOrder[userId][12]);
  v1DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE, limbOrder[userId][13]);
  v1DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT, limbOrder[userId][14]);
}

void v1DrawLimb(int userId, int jointType1, int jointType2, int limb)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float  confidence;

  PVector[] pos_ = pos[userLimbOrder[userId-1]][limb];
  PVector[] v_ = v[userLimbOrder[userId-1]][limb];
  float[] err_ = err[userLimbOrder[userId-1]][limb];
  float[] w_ = w[userLimbOrder[userId-1]][limb];
  float[] p_ = p[userLimbOrder[userId-1]][limb];
  float[] c_ = c[userLimbOrder[userId-1]][limb];

  // draw the joint position
  confidence = context.getJointPositionSkeleton(userId, jointType1, jointPos1);
  confidence = context.getJointPositionSkeleton(userId, jointType2, jointPos2);

  colorMode(HSB);
  strokeWeight(1);

  for (int i=0; i<pointNum; i++) {
    stroke(c_[i], 255, 255);
    point(pos_[i].x, pos_[i].y, pos_[i].z);
  }

  for (int i=0; i<pointNum; i++) {
    pos_[i].x = pos_[i].x + v_[i].x;
    pos_[i].y = pos_[i].y + v_[i].y;
    pos_[i].z = pos_[i].z + v_[i].z;
  }

  for (int i=0; i<pointNum; i++) {
    v_[i].x = w_[i] * v_[i].x + ((jointPos1.x + (jointPos2.x - jointPos1.x)/pointNum*i + err_[i]) - pos_[i].x)/p_[i];
    v_[i].y = w_[i] * v_[i].y + ((jointPos1.y + (jointPos2.y - jointPos1.y)/pointNum*i + err_[i]) - pos_[i].y)/p_[i];
    v_[i].z = w_[i] * v_[i].z + ((jointPos1.z + (jointPos2.z - jointPos1.z)/pointNum*i + err_[i]) - pos_[i].z)/p_[i];
    c_[i] = map(v_[i].mag(), 0, 30, 180, 0);
  }
}

void v1InitMovePoints() {
  int[] order = {
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  };
  for (int u=0; u<6; u++) {
    for (int i=0; i<jointNum; i++) {
      for (int j=0; j<pointNum; j++) {
        pos[u][i][j] = new PVector();
        v[u][i][j] = new PVector();
        pos[u][i][j].x = random(-width/2, width/2);
        pos[u][i][j].y = random(-height/2, height/2);
        pos[u][i][j].z = random(-500, 500);
        v[u][i][j].x = 0;
        v[u][i][j].y = 0;
        v[u][i][j].z = 0;
        err[u][i][j] = random(-10, 10) + random(-10, 10) + random(-10, 10) + random(-10, 10) + random(-10, 10);
        w[u][i][j] = random(0.5, 0.98);
        p[u][i][j] = random(20, 100);
        c[u][i][j] = 180;
      }
    }
    limbOrder[u] = Arrays.copyOf(order, order.length);
  }
}

void v1Shuffle(int[] array) {
  for (int i = 0; i < array.length; i++) {
    int dst = floor(random(1) * (i + 1));
    v1Swap(array, i, dst);
  }
}

void v1Swap(int[] array, int i, int j) {
  int tmp = array[i];
  array[i] = array[j];
  array[j] = tmp;
}


//  .oooooo..o oooooooooooo   .oooooo.   ooooooooooooo ooooo   .oooooo.   ooooo      ooo      .oooo.  
// d8P'    `Y8 `888'     `8  d8P'  `Y8b  8'   888   `8 `888'  d8P'  `Y8b  `888b.     `8'    .dP""Y88b 
// Y88bo.       888         888               888       888  888      888  8 `88b.    8           ]8P'
//  `"Y8888o.   888oooo8    888               888       888  888      888  8   `88b.  8         .d8P' 
//      `"Y88b  888    "    888               888       888  888      888  8     `88b.8       .dP'    
// oo     .d8P  888       o `88b    ooo       888       888  `88b    d88'  8       `888     .oP     .o
// 8""88888P'  o888ooooood8  `Y8bood8P'      o888o     o888o  `Y8bood8P'  o8o        `8     8888888888

void version2()
{
  // update the cam
  context.update();

  background(0, 0, 0);

  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);
  scale(-1, 1);

  int[]   depthMap = context.depthMap();
  int[]   userMap = context.userMap();
  int     steps   = 3;  // to speed up the drawing, draw every third point
  int     index;
  PVector realWorldPoint;

  translate(0, 0, -1000);  // set the rotation center of the scene 1000 infront of the camera

  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for (int i=0; i<userList.length; i++)
  {
    if (context.isTrackingSkeleton(userList[i]))
      v2DrawSkeleton(userList[i]);
  }
}

// draw the skeleton with the selected joints
void v2DrawSkeleton(int userId)
{
  // to get the 3d joint data
  v2DrawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK, limbOrder[userId][0]);

  v2DrawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER, limbOrder[userId][1]);
  v2DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW, limbOrder[userId][2]);
  v2DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND, limbOrder[userId][3]);

  v2DrawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER, limbOrder[userId][4]);
  v2DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW, limbOrder[userId][5]);
  v2DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND, limbOrder[userId][6]);

  v2DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO, limbOrder[userId][7]);
  v2DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO, limbOrder[userId][8]);

  v2DrawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP, limbOrder[userId][9]);
  v2DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE, limbOrder[userId][10]);
  v2DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT, limbOrder[userId][11]);

  v2DrawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP, limbOrder[userId][12]);
  v2DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE, limbOrder[userId][13]);
  v2DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT, limbOrder[userId][14]);
}

void v2DrawLimb(int userId, int jointType1, int jointType2, int limb)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float  confidence;

  PVector[] pos_ = pos[userId][limb];
  PVector[] v_ = v[userId][limb];
  float[] err_ = err[userId][limb];
  float[] w_ = w[userId][limb];
  float[] p_ = p[userId][limb];
  float[] c_ = c[userId][limb];

  // draw the joint position
  confidence = context.getJointPositionSkeleton(userId, jointType1, jointPos1);
  confidence = context.getJointPositionSkeleton(userId, jointType2, jointPos2);

  colorMode(HSB);
  strokeWeight(1);

  for (int i=0; i<pointNum; i++) {
    stroke(255 - c_[i], 255, 255, c_[i]);
    point(pos_[i].x, pos_[i].y, pos_[i].z);
    if (i%5 == 3) {
      line(pos_[i].x, pos_[i].y, pos_[i].z, pos_[i-1].x, pos_[i-1].y, pos_[i-1].z);
    }
  }

  for (int i=0; i<pointNum; i++) {
    pos_[i].x = pos_[i].x + v_[i].x;
    pos_[i].y = pos_[i].y + v_[i].y;
    pos_[i].z = pos_[i].z + v_[i].z;
  }

  for (int i=0; i<pointNum; i++) {
    v_[i].x = w_[i] * v_[i].x + ((jointPos1.x + (jointPos2.x - jointPos1.x)/pointNum*i + err_[i]) - pos_[i].x)/p_[i];
    v_[i].y = w_[i] * v_[i].y + ((jointPos1.y + (jointPos2.y - jointPos1.y)/pointNum*i + err_[i]) - pos_[i].y)/p_[i];
    v_[i].z = w_[i] * v_[i].z + ((jointPos1.z + (jointPos2.z - jointPos1.z)/pointNum*i + err_[i]) - pos_[i].z)/p_[i];
    c_[i] = map(v_[i].mag(), 0, 30, 0, 255);
  }
}

void v2InitMovePoints() {
  int[] order = {
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  };
  for (int u=0; u<6; u++) {
    for (int i=0; i<jointNum; i++) {
      for (int j=0; j<pointNum; j++) {
        pos[u][i][j] = new PVector();
        v[u][i][j] = new PVector();
        pos[u][i][j].x = random(-width/2, width/2);
        pos[u][i][j].y = random(-height/2, height/2);
        pos[u][i][j].z = random(-500, 500);
        v[u][i][j].x = 0;
        v[u][i][j].y = 0;
        v[u][i][j].z = 0;
        err[u][i][j] = random(-50, 50);
        w[u][i][j] = random(0.5, 0.98);
        p[u][i][j] = random(20, 100);
        c[u][i][j] = 180;
      }
    }
    limbOrder[u] = Arrays.copyOf(order, order.length);
  }
}


//  .oooooo..o oooooooooooo   .oooooo.   ooooooooooooo ooooo   .oooooo.   ooooo      ooo      .oooo.  
// d8P'    `Y8 `888'     `8  d8P'  `Y8b  8'   888   `8 `888'  d8P'  `Y8b  `888b.     `8'    .dP""Y88b 
// Y88bo.       888         888               888       888  888      888  8 `88b.    8           ]8P'
//  `"Y8888o.   888oooo8    888               888       888  888      888  8   `88b.  8         <88b. 
//      `"Y88b  888    "    888               888       888  888      888  8     `88b.8          `88b.
// oo     .d8P  888       o `88b    ooo       888       888  `88b    d88'  8       `888     o.   .88P 
// 8""88888P'  o888ooooood8  `Y8bood8P'      o888o     o888o  `Y8bood8P'  o8o        `8     `8bd88P'  

void version3()
{
  // update the cam
  context.update();

  background(0, 0, 0);

  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);
  scale(-1, 1);

  int[]   depthMap = context.depthMap();
  int[]   userMap = context.userMap();
  int     steps   = 3;  // to speed up the drawing, draw every third point
  int     index;
  PVector realWorldPoint;

  translate(0, 0, -2000);  // set the rotation center of the scene 1000 infront of the camera

  beginShape(POINTS);
  for (int y=0; y < context.depthHeight (); y+=steps)
  {
    for (int x=0; x < context.depthWidth (); x+=steps)
    {
      index = x + y * context.depthWidth();
      if (depthMap[index] > 0)
      { 
        // draw the projected point
        realWorldPoint = context.depthMapRealWorld()[index];
        if (userMap[index] == 0) {
        } else {
          stroke(150);
          vertex(realWorldPoint.x, realWorldPoint.y, realWorldPoint.z);
        }
      }
    }
  } 
  endShape();

  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for (int i=0; i<userList.length; i++)
  {
    if (context.isTrackingSkeleton(userList[i])) {
      if (frameCount % 1 == 0) {
        v3TrackSkeleton(userList[i]);
      }
      v3DrawSkeleton(userList[i]);
    }
  }
  rotY += 0.005f;
  //  rotX += 0.005f;
}

// draw the skeleton with the selected joints
void v3TrackSkeleton(int userId)
{
  // to get the 3d joint data
  v3Track(userId, SimpleOpenNI.SKEL_HEAD);
  v3Track(userId, SimpleOpenNI.SKEL_NECK);

  v3Track(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  v3Track(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
  v3Track(userId, SimpleOpenNI.SKEL_LEFT_HAND);

  v3Track(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  v3Track(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  v3Track(userId, SimpleOpenNI.SKEL_RIGHT_HAND);

  v3Track(userId, SimpleOpenNI.SKEL_TORSO);

  v3Track(userId, SimpleOpenNI.SKEL_LEFT_HIP);
  v3Track(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
  v3Track(userId, SimpleOpenNI.SKEL_LEFT_FOOT);

  v3Track(userId, SimpleOpenNI.SKEL_RIGHT_HIP);
  v3Track(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
  v3Track(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
}

void v3DrawSkeleton(int userId) {
  ArrayList<PVector>[] tracker = trackParticles[userId-1];
  PVector left = new PVector();
  PVector right = new PVector();
  float  confidence;

  confidence = context.getJointPositionSkeleton(userId, 6, left);
  confidence = context.getJointPositionSkeleton(userId, 7, right);

  noFill();
  colorMode(HSB);
  for (int i=0; i<jointNum; i++) {
    if (i == 6 || i == 7) {
      boolean isSaved = true;
      beginShape(TRIANGLES);
      for (int j=tracker[i].size ()-1; j>3; j--) {
        if (j > 100 && isSaved) {
          if (PVector.dist(tracker[i].get(0), tracker[i].get(j)) < 140) {
            isSaved = true;
          } else {
            isSaved = false;
          }
        }
        int save = isSaved ? 120 : 200;
        stroke(userColor[userId-1][i], save, 255, j);
        //        fill(userColor[userId-1][i], save, 255, 1.0*j/pointNum*30);
        vertex(tracker[i].get(j).x, tracker[i].get(j).y, tracker[i].get(j).z);
        vertex(tracker[i].get(j-3).x, tracker[i].get(j-3).y, tracker[i].get(j-3).z);
      }
      endShape();
      if (tracker[i].size()>200 && isSaved) {
        isEmit[userId-1] = true;
        savePos[userId-1][6] = new PVector(tracker[6].get(0).x, tracker[6].get(0).y, tracker[6].get(0).z);
        savePos[userId-1][7] = new PVector(tracker[7].get(0).x, tracker[7].get(0).y, tracker[7].get(0).z);
      }
      if (isEmit[userId-1]) {
        int emission = emissions[userId-1];
        PVector posl = tracker[6].get(tracker[6].size()-1);
        PVector posr = tracker[7].get(tracker[7].size()-1);
        strokeWeight(2);
        beginShape(POINTS);
        for (int j=0; j<500; j++) {
          float x, y, z, r;
          x = random(-1, 1);
          y = random(-1, 1);
          z = random(1) < 0.5 ? sqrt(1 - x*x - y*y) : sqrt(1 - x*x - y*y)*(-1);
          r = random(-1, 1)*random(-1, 1)*(random(30, 80)+random(30, 80)+random(30, 80)+random(30, 80)+random(30, 80));
          stroke(userColor[userId-1][6], 120, 255, 120);
          vertex(posl.x + r*x, posl.y + r*y, posl.z + r*z);
          stroke(userColor[userId-1][7], 120, 255, 120);
          vertex(posr.x + r*x, posr.y + r*y, posr.z + r*z);
        }
        endShape();
        strokeWeight(1);
        emissions[userId-1] += 1;
      }
      if (emissions[userId-1] > 100) {
        isEmit[userId-1] = false;
        emissions[userId-1] = 1;
        userColor[userId-1][6] = int(random(255));
        userColor[userId-1][7] = int(random(255));
      }
    }
  }
}

void v3Track(int userId, int jointType) {
  PVector jointPos = new PVector();
  PVector trackPos1 = new PVector();
  PVector trackPos2 = new PVector();
  PVector trackPos3 = new PVector();
  float  confidence;
  ArrayList<PVector> tracker = trackParticles[userId-1][jointType];

  // draw the joint position
  confidence = context.getJointPositionSkeleton(userId, jointType, jointPos);

  if (isEmit[userId-1] && PVector.dist(jointPos, savePos[userId-1][jointType]) > 500) {
    if (tracker.size() > pointNum) {
      tracker.remove(0);
      tracker.remove(1);
      tracker.remove(2);
    }
    trackPos1 = PVector.sub(jointPos, savePos[userId-1][jointType]);
    trackPos2 = PVector.sub(jointPos, savePos[userId-1][jointType]);
    trackPos3 = PVector.sub(jointPos, savePos[userId-1][jointType]);
    trackPos1.mult(random(10000));
    trackPos2.mult(random(0));
    trackPos3.mult(random(0));
    trackPos1.add(savePos[userId-1][jointType]);
    trackPos2.add(savePos[userId-1][jointType]);
    trackPos3.add(savePos[userId-1][jointType]);
    tracker.add(trackPos1);
    tracker.add(trackPos2);
    tracker.add(trackPos3);
  } else {
    if (tracker.size() > pointNum) {
      tracker.remove(0);
      tracker.remove(1);
      tracker.remove(2);
    }
    float x, y, z, r;
    x = random(-1, 1);
    y = random(-1, 1);
    z = sqrt(1 - x * x - y * y);
    r = random(40);
    trackPos1 = new PVector(random(-20, 20), random(-20, 20), random(-20, 20));
    x = random(-1, 1);
    y = random(-1, 1);
    z = sqrt(1 - x * x - y * y);
    r = random(40);
    trackPos2 = new PVector(random(-20, 20), random(-20, 20), random(-20, 20));
    x = random(-1, 1);
    y = random(-1, 1);
    z = sqrt(1 - x * x - y * y);
    r = random(40);
    trackPos3 = new PVector(random(-20, 20), random(-20, 20), random(-20, 20));
    trackPos1.add(jointPos);
    trackPos2.add(jointPos);
    trackPos3.add(jointPos);
    tracker.add(trackPos1);
    tracker.add(trackPos2);
    tracker.add(trackPos3);
  }
}

void v3InitMovePoints() {
  for (int u=0; u<6; u++) {
    for (int i=0; i<jointNum; i++) {
      for (int j=0; j<pointNum; j++) {
        trackParticles[u][i] = new ArrayList<PVector>();
        userColor[u][i] = int(random(255));
        isEmit[u] = false;
        emissions[u] = 1;
        savePos[u][i] = new PVector();
      }
    }
  }
}

void v3InitUser(int userId) {
  for (int i=0; i<jointNum; i++) {
    for (int j=0; j<pointNum; j++) {
      trackParticles[userId-1][i] = new ArrayList<PVector>();
      userColor[userId-1][i] = int(random(255));
      isEmit[userId-1] = false;
      emissions[userId-1] = 1;
      savePos[userId-1][i] = new PVector();
    }
  }
}







// change art_versions





void keyPressed() {
  if (key == '1') {
    art_version = 1;
    setup();
  } else if (key == '2') {
    art_version = 2;
    setup();
  } else if (key == '3') {
    art_version = 5;
    setup();
  } else if (key == '4') {
    art_version = 4;
    setup();
  } else if (key == '5') {
    art_version = 3;
    setup();
  } else {


    if (art_version == 1) {

      if (key=='f') {
        img = loadImage("data/fire.jpeg");
      } else if (key=='s') {
        img = loadImage("data/space.jpeg");
      } else if (key=='r') {
        img = loadImage("data/rainbow.jpeg");
      }
      img.resize(displayWidth, displayHeight);
    } else if (art_version == 2) {
    } else if (art_version == 3) {
    } else if (art_version == 4) {
    } else if (art_version == 5) {
      switch(key)
      {
      case ' ':
        context.setMirror(!context.mirror());
        break;
      case 'p':
        version = 1;
        pointNum = 800;
        v1InitMovePoints();
        rotY = 0;
        break;
      case 'l':
        version = 2;
        pointNum = 800;
        v2InitMovePoints();
        rotY = 0;
        break;
      case 'h':
        version = 3;
        pointNum = 400;
        v3InitMovePoints();
        rotY = -90;
        zoomF =0.3f;
        break;
      }

      switch(keyCode)
      {
      case LEFT:
        rotY += 0.01f;
        break;
      case RIGHT:
        // zoom out
        rotY -= 0.01f;
        break;
      case UP:
        if (keyEvent.isShiftDown())
          zoomF += 0.001f;
        else
          rotX += 0.01f;
        break;
      case DOWN:
        if (keyEvent.isShiftDown())
        {
          zoomF -= 0.001f;
          if (zoomF < 0.001)
            zoomF = 0.001;
        } else
          rotX -= 0.01f;
        break;
      }
    }
  }
}


