import rwmidi.*;

MidiInput mymididevice;
int mypitch;

void setup(){
  size(480, 108);
  smooth();
  background(70);
  
  MidiInputDevice devices[] = RWMidi.getInputDevices();
  
  for(int i = 0; i < devices.length; i++){
    println(i+":"+devices[i].getName());
  }
  mymididevice = RWMidi.getInputDevices()[0].createInput(this);
}
void draw(){
  background(102);
  ellipse(width/2, height/2, mypitch, mypitch);
}

//Note ON recieved 
void noteOnReceived(Note myreceivednote) {
    println("note on " + myreceivednote.getChannel() + "  " + myreceivednote.getPitch()+ "  " + myreceivednote.getVelocity());
    mypitch = myreceivednote.getPitch();
}

// Note Off recieved 
void noteOffReceived(Note myreceivednote) {
    println("note off " + myreceivednote.getChannel() + "  " + myreceivednote.getPitch()+ "  " + myreceivednote.getVelocity());
}

// Program Change recieved  
void programChangeReceived(ProgramChange pc) {
    println("note off " + pc.getChannel() + "  " + pc.getNumber());
  }

// Control Change recieved 
void controllerChangeReceived(Controller cc) {
  println("cc channell is: " + cc.getChannel() + "  " + "cc number is: " + cc.getCC() + "  " + "cc value is:  " + cc.getValue() );
}

// System Exclusive recieved 
void sysexReceived(SysexMessage msg) {
  println("sysex " + msg);
}
