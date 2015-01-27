import javax.swing.JFileChooser;
import java.io.File;

File testFile;
imageAnalyzer a;
imageProcessor p;
String location;
String ext;
int iter = 0;
boolean switcher = false;

void setup() {
  frameRate(24);
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
  } else {
      System.out.println("No valid file extension. \nTerminating.");
      System.exit(1);
  }
  
}

void draw() {
  image(p.initialImage(), 0, 0);
  int mouseCoord[] = {pmouseX, pmouseY};
  int index = a.getIndex(mouseCoord);
  int am = a.getAmount(index);
  am = am / 10;
  int[][] coord = a.getCoordinates(index);
  color c = a.getColor(index);
  fill(c);
  noStroke();
  for (int i = 0; i < coord.length; i++) {
    arc(coord[i][0], coord[i][1], 6, 6, 0, TWO_PI);
  }
  if (switcher) {
    stroke(128, 128, 128);
    arc(pmouseX, pmouseY, am, am, 0, TWO_PI);
  }
}

void keyPressed() {
  if (key == 'w') {
    switcher = !switcher ? true : false;
  }
}

