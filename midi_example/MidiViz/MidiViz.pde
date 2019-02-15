import java.util.Collection;
import javax.sound.midi.*;
import http.requests.*;

AMidiPlayer midiPlayer;
boolean trigger = true;

void setup() {
  size(640, 360);
  background(0);
  midiPlayer = new AMidiPlayer(); 
}

void draw() {
  if(trigger){
    PostRequest post = new PostRequest("http://127.0.0.1:8000/api/v2/midi/1/3/", "UTF-8"); //for test
    post.send();
    String midiPath = post.getContent();
    midiPlayer.load(midiPath.replaceAll("\"", ""));
    midiPlayer.start();
    trigger = false;
  }

  changeBackground(midiPlayer);
  midiPlayer.update();
}
void changeBackground(AMidiPlayer midiPlayer) {
  for (Note n : midiPlayer.getNotes()) {
    background(map(n.note % 12, 0, 11, 0, 255), 
      map(n.channel, 0, 15, 80, 255), 
      map(n.note, 0, 127, 100, 255) * random(0.9, 1.0));
  }
}
