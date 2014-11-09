import SimpleOpenNI.*;
SimpleOpenNI kinect;
int x;
PImage newImage;
int time;
int wait = 20000;
void setup() {
  size(640*2, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  // turn on user tracking
  kinect.enableUser();
  newImage = createImage(640, 480, RGB);
  time = millis();
}
void draw() {
  kinect.update();
  PImage depth = kinect.depthImage();
  PImage kin = kinect.rgbImage();
  newImage = kin.get();
  image(depth, 0, 0);
  image(newImage, kinect.depthWidth() + 10, 0);
  //fill(255,0,0);
  stroke(255, 0, 0);
  strokeWeight(50);
  ellipse(50, 50, 30, 30);
  // make a vector of ints to store the list of users
  IntVector userList = new IntVector();
  // write the list of detected users
  // into our vector
  kinect.getUsers(userList);
  // if we found any users
  if (userList.size() > 0) {
    // get the first user
    int userId = userList.get(0);
    // if we’re successfully calibrated
    if ( kinect.isTrackingSkeleton(userId)) {
      // make a vector to store the left hand
      PVector rightHand = new PVector();
      // put the position of the left hand into that vector
      float confidence = kinect.getJointPositionSkeleton(userId, 
      SimpleOpenNI.SKEL_LEFT_HAND, 
      rightHand);
      // convert the detected hand position
      // to "projective" coordinates
      // that will match the depth image
      PVector convertedRightHand = new PVector();
      kinect.convertRealWorldToProjective(rightHand, convertedRightHand);
      // and display it
      strokeWeight(0);
      fill(255, 0, 0);
      ellipse(convertedRightHand.x, convertedRightHand.y, 10, 10);

      //newImage.save("outputImage.jpg");
      if ((convertedRightHand.x > 40 && convertedRightHand.x <60) && (convertedRightHand.y > 40 && convertedRightHand.y <60)) {
       saveImg();
       // newImage = kin.get();
        //newImage.save("G:/Processing/handTracking_kinect/data/"+timestamp()+".jpg");
      }
    }
  }
}

// -----------------------------------------------------------------
// SimpleOpenNI user events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  kinect.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

String timestamp()
{
  return year()+nf(month(), 2)+nf(day(), 2)+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2);
} 
void saveImg(){
  if(millis() - time >= wait){
    newImage.saveFrame("G:/Processing/handTracking_kinect/data/"+timestamp()+".jpg");
    //println("tick");//if it is, do something
    time = millis();//also update the stored time
  }
}


// -----------------------------------------------------------------

