import javax.swing.JFileChooser;
import java.io.File;

File testFile;
imageAnalyzer a;
imageProcessor p;
String location;
String ext;
int iter = 0;

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
  } else {
      System.out.println("No valid file extension. \nTerminating.");
      System.exit(1);
  }
  
}

void draw() {
  image(p.initialImage(), 0, 0);
  int size = a.getListSize();
  if (iter < size) {
    a.fillColorValue(iter++);
  }  
 image(p.returnImage(), 0, 0);
}

