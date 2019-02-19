import oscP5.*;

OscP5 o;
PShader shader;
int margin = 50;
int numFrames = 20;

void setup() {
  //size(640, 360);
  //size(640, 360, P3D);
  frameRate(60);
  size(1280, 720);
  //shader = loadShader("shader.glsl");
  background(0);
  o = new OscP5(this, 2346);  //set a port number - it has to be same as in your Max for Live device
  colorMode(HSB);
  noStroke();
} 

int velocity1 = 0;
float duration1;
int note1 = 0;
float ease(float p, float g) {
  if (p < 0.5)
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}
float pixel_color(float x,float y,float t){
  float result = ease(map(sin(TWO_PI*(t+0.05*y)),-1,1,0,1),3.0);
  return 255*result;
}
void draw() {
  //shader(shader);
  //translate(width/2, height/2);
  //rotateZ(noise(0.23, 15 * frameCount * 0.00013));
  //rotateY(frameCount * 0.003);

  //directionalLight(30, 20, 255, 1, 1, 1);
  //directionalLight(150, 20, 255, -1, -1, -1);
  //display();
  background(0);
 
  float t = 1.0*(frameCount-1)%numFrames/numFrames;
 
  // Draws every pixel
  //for(int i=margin;i<width-margin;i++){
  //  for(int j=margin;j<height-margin;j++){
  //    stroke(pixel_color(i,j,t));
  //    point(i,j);
  //  }
  //}
 
  // Draws a white rectangle
  stroke(255);
  noFill();
  rect(margin,margin,width-2*margin,height-2*margin);
 
  // Saves the frame
  println(frameCount,"/",numFrames);
 
  // Stops when all the frames are rendered
  if(frameCount == numFrames){
    println("finished");
  }
}

void oscEvent(OscMessage theMsg) {
  if(theMsg.checkAddrPattern("/Velocity5")==true) {
      velocity1 = theMsg.get(0).intValue();
      
      //println(velocity1+"||"+ver_move1);
  }
  
  if(theMsg.checkAddrPattern("/Note5")==true) {
      note1 = theMsg.get(0).intValue();
      duration1 = map(sq(note1), 1, sq(127), 0.05, 0.5);
  }
}
