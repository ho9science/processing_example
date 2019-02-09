//import the necessary libraries to use send, receive and understand OSC data
import oscP5.*;
//import netP5.*;

// OSC loading stuff
OscP5 o;
//NetAddress myRemoteLocation;

B_String string1, string2, string3, string4, string5, string6, string7, string8;
boolean initial = true;
int mills;
int count;
int result;
ArrayList<Midi> list = new ArrayList();
float starttime = 0;

JSONObject json;
int notes[] = new int[100];
int velocities[] = new int[100];
float starttimes[] = new float[100];
float endtimes[] = new float[100];

void setup() {
  size(640, 360);
  stroke(255);
  background(0);

  o = new OscP5(this, 2346);  //set a port number - it has to be same as in your Max for Live device
  //myRemoteLocation = new NetAddress("127.0.0.1", 2346);
  
  string1=new B_String (width*0.1, width*0.3 , width*0.7, width*0.9, height*0.2, 250);
  
} 

int velocity1, velocity2, velocity3, velocity4, velocity5, velocity6, velocity7, velocity8 = 0;
float ver_move1, ver_move2, ver_move3, ver_move4, ver_move5, ver_move6, ver_move7, ver_move8;
float duration1, duration2, duration3, duration4, duration5, duration6, duration7, duration8;
int note1, note2, note3, note4, note5, note6, note7, note8  = 0;

void draw() {
  background(0);
  //translate(width/3, height/3);
  //noFill();
  //stroke(250, 0, 0);
  
  string1.display(ver_move1);
  
  
  if (ver_move1>0){
    ver_move1 = ver_move1 -duration1;}
  
  ver_move1 = - ver_move1;
  
}


void oscEvent(OscMessage theMsg) {
  if(theMsg.checkAddrPattern("/Velocity1")==true) {
      velocity1 = theMsg.get(0).intValue();
      ver_move1 = map(velocity1, 0, 127, 0, 60);
      //println(velocity1+"||"+ver_move1);
  }
  
  if(theMsg.checkAddrPattern("/Note1")==true) {
      json = new JSONObject();
      note1 = theMsg.get(0).intValue();
      duration1 = map(sq(note1), 1, sq(127), 0.05, 0.5);
      println(note1+"|"+duration1);
      
      if(count==1){  
        println((millis()-mills)/1000.0);
        float endtime = (millis()-mills)/1000.0;
        mills = millis();
        println(note1+"|"+velocity1+"|"+starttime+"|"+endtime);
        append(notes, note1);
        append(velocities, 100);
        append(starttimes, starttime);
        append(endtimes, endtime);
        starttime = starttime+endtime;
        count = 0;
      }else if(count==0){
        count+=1;
        result++;
      }
      if(initial){
        mills = millis();
        initial = false;
      }
      if(result==7){
         JSONArray values = new JSONArray();
  
        for(int i = 0; i < notes.length; i++){
          if(notes[i]==0){
            break;
          }
          JSONObject midi = new JSONObject();
          midi.setInt("note", notes[i]);
          midi.setInt("velocity", velocities[i]);
          midi.setFloat("starttime",starttimes[i]);
          midi.setFloat("endtime",endtimes[i]);
          values.setJSONObject(i, midi);
          
        }
      println(values);
      }
      
  }
}

/*float log10 (int x) {
  return (log(x) / log(10));
}*/

class B_String {
  float osc_points, p11, p21, p31, p41, shade;
  
  B_String(float a1, float b1, float c1, float d1, float i, int colour) {
    noFill();
    //fill(250, 0, 0, 55);
    stroke(200, colour, 0);
    bezier(a1, i, b1, i, c1, i, d1, i);
    osc_points = i;
    p11 = a1;
    p21 = b1;
    p31 = c1;
    p41 = d1;
    shade = colour;
    //fill(0, 0, 0);
  }
  
  void display(float velocity) { 
      noFill();
      stroke(200, shade, 0);
      bezier(p11, osc_points, p21, osc_points+velocity, p31, osc_points+velocity, p41, osc_points);
      bezier(p11, osc_points, p21, osc_points+0.8*velocity, p31, osc_points+0.8*velocity, p41, osc_points);
      bezier(p11, osc_points, p21, osc_points+0.6*velocity, p31, osc_points+0.6*velocity, p41, osc_points);
      bezier(p11, osc_points, p21, osc_points+0.4*velocity, p31, osc_points+0.4*velocity, p41, osc_points);
      bezier(p11, osc_points, p21, osc_points+0.2*velocity, p31, osc_points+0.2*velocity, p41, osc_points);
      bezier(p11, osc_points, p21, osc_points, p31, osc_points, p41, osc_points);
  }
}
