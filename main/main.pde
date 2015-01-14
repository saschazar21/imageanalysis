import javax.swing.JFileChooser;
import java.io.File;

File testFile;
imageAnalyzer a;
imageProcessor p;
String location;
String ext;
int iter = 0;
boolean theSwitch = false;
float start = -HALF_PI;
int diameter = 0;
float interval = 0;

void setup() {
  frameRate(24);
  //size(640,480);
  JFileChooser chooser = new JFileChooser();
  chooser.setCurrentDirectory(new File(System.getProperty("user.home")));
  int result = chooser.showOpenDialog(this);
  if (result == JFileChooser.APPROVE_OPTION) {
    testFile = chooser.getSelectedFile();
    String fileType = testFile.getName();
    int pos = fileType.lastIndexOf(".");
    ext = fileType.substring(++pos).toLowerCase();
    location = testFile.getAbsolutePath();
    System.out.println(location + ", Selected File Type was " + ext);
  }
  this.launcher();
  size(p.theWidth, p.theHeight);
}

void launcher() {
  if (ext.equals("jpg") || ext.equals("jpeg") || ext.equals("png")
    || ext.equals("gif") || ext.equals("bmp") || ext.equals("tif")
    || ext.equals("tiff")) { 
      p = new imageProcessor(location);
      a = new imageAnalyzer(p);
      interval = radians(360.0 / (float) p.returnImage().pixels.length);
  } else {
      System.out.println("No valid file extension. \nTerminating.");
      System.exit(1);
  }
  
}

void draw() {
  int size = a.getListSize();
  if (theSwitch) {
    if (iter < size) {
      int newDia = Math.round(diameter * 0.75);
      int amount = a.getAmount(iter);
      fill(a.getColor(iter));
      noStroke();
      arc(width / 2, height / 2, newDia, newDia, start, start + interval * amount, PIE);
      start += interval * amount;
      iter++;
     }
     fill(255, 255, 255);
     noStroke();
     arc(width / 2, height / 2, diameter / 2, diameter / 2, 0, TWO_PI, PIE);
  } else {
    image(p.initialImage(), 0, 0);
    if (iter < size) {
      a.fillColorValue(iter++);
    }  
    image(p.returnImage(), 0, 0);
  }
}

void keyPressed() {
  if (key == 'w') {
    iter = 0;
    theSwitch = true;
    fill(255);
    noStroke();
    if (p.isLandscape()) {
      diameter = Math.round(height * 0.8);
    } else {
      diameter = Math.round(width * 0.8);
    }
    arc(width / 2, height / 2, diameter, diameter, 0, TWO_PI, PIE);
  }
}

