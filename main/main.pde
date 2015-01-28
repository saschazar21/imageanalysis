import javax.swing.JFrame;
import javax.swing.JFileChooser;
import java.io.File;

PFrame f;
circleApplet cApplet;
File testFile;
imageAnalyzer a;
imageProcessor p;
String location;
String ext;
int iter = 0;
int globalIndex = 0;
boolean switcher = true;

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
  f = new PFrame();
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
  globalIndex = index;
  int am = (int) sqrt(a.getAmount(index));
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

public class circleApplet extends PApplet {
  int centerX = 240;
  int centerY = 240;
  int pixelSize;
  
  public void setup() {
    size(480, 480);
    pixelSize = p.getSize();
  }
  
  public void draw() {
    background(255);
    float[][] ballCoord = new float[a.getListSize()][2];
    int index = 0;
    int total = 0;
    float deg = 360f / pixelSize;
    for (int i = 0; i < pixelSize; i++) {
      int am = a.getAmount(index);
      float arcX = centerX + (centerX * 0.8) * cos(deg * total);
      float arcY = centerY + (centerY * 0.8) * sin(deg * total);
      fill(a.getColor(index));
      noStroke();
      ellipse(arcX, arcY, sqrt(am) / 2, sqrt(am) / 2);
      ballCoord[index][0] = arcX;
      ballCoord[index][1] = arcY;
      i += am;
      total += sqrt(am);
      index++;
    }
    ArrayList<Integer> aL = a.getNeighbors(globalIndex);
    for (int i : aL) {
      stroke(a.getColor(i));
      line(ballCoord[globalIndex][0], ballCoord[globalIndex][1], ballCoord[i][0], ballCoord[i][1]);
    }
  }
}

public class PFrame extends JFrame {
  public PFrame() {
    setBounds(0, 0, 480, 480);
    cApplet = new circleApplet();
    add(cApplet);
    cApplet.init();
    show();
  }
}
