import oscP5.*;
import java.util.Collection;
import javax.sound.midi.*;
import http.requests.*;

// OSC loading stuff
OscP5 o;

B_String string1, string2;
boolean initial = true;
int mills;
int count;
int result;
ArrayList<Midi> list = new ArrayList();
float starttime = 0;

JSONObject json;
int notes[] = {};
int velocities[] = {};
float starttimes[] = {};
float endtimes[] = {};
AMidiPlayer midiPlayer;

void setup() {
  size(640, 360);
  stroke(255);
  background(0);
  midiPlayer = new AMidiPlayer();
  o = new OscP5(this, 2346);  //set a port number  
  string1=new B_String (width*0.1, width*0.3 , width*0.7, width*0.9, height*0.2, 250);
  string2=new B_String (width*0.1, width*0.3 , width*0.7, width*0.9, height*0.3, 50);
} 

int velocity1, velocity2 = 0;
float ver_move1, ver_move2;
float duration1, duration2;
int note1, note2 = 0;
boolean trigger = false;
JSONArray values = new JSONArray();

void draw() {
  background(0);
  //translate(width/3, height/3);
  //noFill();
  //stroke(250, 0, 0);
  
  string1.display(ver_move1);
  string2.display(ver_move2);
  if (ver_move1>0){
    ver_move1 = ver_move1 -duration1;}
  
  if (ver_move2>0){
    ver_move2 = ver_move2 -duration2;}
    
  ver_move1 = - ver_move1;
  ver_move2 = - ver_move2;
  
  if(trigger){
    String midiPath = interplay(values.toString());
    midiPlayer.load(midiPath.replaceAll("\"", "")); //input midi file path
    midiPlayer.start();
    trigger = false;
  }
  changeBackground(midiPlayer);
  midiPlayer.update();
}

String interplay(String jsonData){
  PostRequest post = new PostRequest("http://127.0.0.1:8000/api/v2/midi/json/", "UTF-8");
  post.addHeader("Content-Type", "application/json");
  post.addJson(jsonData);
  post.send();
  return post.getContent();
}


void oscEvent(OscMessage theMsg) {
  if(theMsg.checkAddrPattern("/Velocity1")==true) {
      velocity1 = theMsg.get(0).intValue();
      ver_move1 = map(velocity1, 0, 127, 0, 60);
  }
  
  if(theMsg.checkAddrPattern("/Note1")==true) {
      json = new JSONObject();
      note1 = theMsg.get(0).intValue();
      duration1 = map(sq(note1), 1, sq(127), 0.05, 0.5);

      if(result==21){
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
        trigger = true;
      }
      if(count==1){  
        float endtime = (millis()-mills)/1000.0 + starttime;
        endtime = round(endtime*100)/100.0;
        mills = millis();
        println(note1+"|"+velocity1+"|"+starttime+"|"+endtime);
        notes = (int[])append(notes, note1);
        velocities = (int[])append(velocities, 100);
        starttimes = (float[])append(starttimes, starttime);
        endtimes = (float[])append(endtimes, endtime);
        starttime = endtime;
        count = 0;
      }else if(count==0){
        count+=1;
        result++;
      }
      if(initial){
        mills = millis();
        initial = false;
      }
      
  }
}
void changeBackground(AMidiPlayer midiPlayer) {
  for (Note n : midiPlayer.getNotes()) {
    //note2 = n.note;
    //duration2 = map(sq(note2), 1, sq(127), 0.05, 0.5);
    background(map(n.note % 12, 0, 11, 0, 255), 
      map(n.channel, 0, 15, 80, 255), 
      map(n.note, 0, 127, 100, 255) * random(0.9, 1.0));
  }
}

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
