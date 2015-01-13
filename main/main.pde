import javax.swing.JFileChooser;
import java.io.File;

File testFile;
imageAnalyzer a;
imageProcessor p;
String location;
String ext;
int iter = 0;

int mX, mY;

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
  mX = width / 2;
  mY = height / 2;
}

void draw() {
  int rad = a.getRect(iter);
  int[] c = a.getColor(iter);
  image(p.initialImage(), 0, 0);
  image(p.returnImage(), 0, 0);
  fill(c[0], c[1], c[2]);
  noStroke();
  rectMode(CENTER);
  rect(mX, mY, rad, rad);
}

void mouseDragged() {
  mX = mouseX;
  mY = mouseY;
}

void keyPressed() {
  int size = a.getListSize();
  if (key == TAB) {
    if (iter < size - 1) {
      if (mX != (width / 2) && mY != (height / 2)) {
        a.imprintRect(mX, mY, iter);
      }
      iter++;
      mX = width / 2;
      mY = height / 2;
    }
  }
  if (key == 'q') {
    if (iter > 0) {
      if (mX == (width / 2) && mY == (height / 2)) {
        iter--;
      }
    }
  }
}

