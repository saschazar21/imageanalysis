import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;

class imageAnalyzer {
  
  public final int TOLERANCE = 7;
  imageProcessor img;
  ArrayList<Pixel> thePixels;
  LinkedList<Coordinate> coordinates;
  
  public imageAnalyzer(imageProcessor img) {
    this.img = img;
    this.thePixels = new ArrayList<Pixel>();
    this.coordinates = new LinkedList<Coordinate>();
    this.coordinates.add(new Coordinate(0, 0));
    this.launcher();
  }
  
  public int getListSize() {
    return this.thePixels.size();
  }
  
  private class Pixel {
    
    private color c;
    public int amount;
    
    Pixel(color c) {
      this.c = c;
      this.amount = 0;
    }
    
    public void iterate() {
      this.amount++;
    }
    
    public color getColor() {
      return this.c;
    }
    
    public String toString() {
      int r,g,b;
      r = (this.c >> 16) & 0xFF;
      g = (this.c >> 8) & 0xFF;
      b = (this.c) & 0xFF;
      
      return this.amount + " Pixels of RGB(" + r + ", " + g + ", " + b + ")";
    }
    
    public int compareTo(color c) {
      int r1,g1,b1;
      int r2,g2,b2;
      int diff = 0;
      
      r1 = (this.c >> 16) & 0xFF;
      g1 = (this.c >> 8) & 0xFF;
      b1 = (this.c) & 0xFF;
      r2 = (c >> 16) & 0xFF;
      g2 = (c >> 8) & 0xFF;
      b2 = (c) & 0xFF;
      
      diff += r1 - r2;
      diff += g1 - g2;
      diff += b1 - b2;
      
      if (diff < TOLERANCE && diff >= -TOLERANCE) {
        return 0;
      } else {
        return diff;
      }
    }
    
    public void colorAvg(color c) {
      int r1,g1,b1;
      int r2,g2,b2;
      int diff = 0;
      
      r1 = (this.c >> 16) & 0xFF;
      g1 = (this.c >> 8) & 0xFF;
      b1 = (this.c) & 0xFF;
      r2 = (c >> 16) & 0xFF;
      g2 = (c >> 8) & 0xFF;
      b2 = (c) & 0xFF;
      
      if (this.amount < 1) {
        int refR = Math.round((r1 + r2) / 2.0f);
        int refG = Math.round((g1 + g2) / 2.0f);
        int refB = Math.round((b1 + b2) / 2.0f);
        this.c = color(refR, refG, refB);
      } else {
        int refR = this.amount * r1 + r2;
        int refG = this.amount * g1 + g2;
        int refB = this.amount * b1 + b2;
        
        refR = Math.round(refR / (float) (this.amount + 1));
        refG = Math.round(refG / (float) (this.amount + 1));
        refB = Math.round(refB / (float) (this.amount + 1));
        this.c = color(refR, refG, refB); 
      }
      
      this.amount++;
    }
  }
  
  private class Coordinate {
    public int x, y;
    
    public Coordinate(int x, int y) {
      this.x = x;
      this.y = y;
    }
  }
  
  private void launcher() {
    this.fillList();
    Comparator<Pixel> c = new ColorComparator();
    Collections.sort(this.thePixels, c);
    
    if (this.thePixels.size() > 3) {
      System.out.println(this.thePixels.get(0));
      System.out.println(this.thePixels.get(1));
      System.out.println(this.thePixels.get(2));
    } else {
      for (Pixel p : this.thePixels) {
        System.out.println(p);
      }
    }
    
    //color[] pixelArray = this.convertToArray();
    //this.img.setPixelArray(pixelArray);
  }
  
  private void fillList() {
    color[] pixelArray = this.img.getPixelArray();
    System.out.println("Amount of Pixels in Image: " + pixelArray.length);
    for (color c : pixelArray) {
      boolean found = false;
      int iter = 0;
      for (Pixel p : this.thePixels) {
        if (p.compareTo(c) == 0 && !found) {
          found = true;
          p.colorAvg(c);
        }
        iter++;
      }
      if (!found) {
        this.thePixels.add(new Pixel(c));
      }
    }
  }
  
  public void fillColorValue(int index) {
    int iter = 0;
    color[] pixelArray = this.img.getPixelArray();
    Pixel p = this.thePixels.get(index);
    float sq = (float) Math.sqrt(p.amount);
    
    int restCol = 0;
    if ((int) sq > 0) {
      //restCol = (p.amount - (int) sq) / (int) sq;
      sq = Math.round(sq);
    }
    
    Coordinate c = this.coordinates.get(iter++);
    while ((c.x + sq) > this.img.theWidth || (c.y + sq + restCol) > this.img.theHeight) {
      if (iter < this.coordinates.size()) {
        c = this.coordinates.get(iter++);
      } else {
        break;
      }
    }
    this.coordinates.remove(--iter);
    int current = c.x + c.y * this.img.theWidth;
    for (int i = 0; i < ((int) sq + restCol); i++) {
      for (int j = 0; j < (int) sq; j++) {
        if ((current + j) < pixelArray.length) {
          pixelArray[current + j] = color(p.getColor());
        } else {
          break;
        }
      }
      current += this.img.theWidth;
    }
    this.coordinates.addLast(new Coordinate(c.x + (int) sq, c.y));
    this.coordinates.addLast(new Coordinate(c.x, c.y + (int) sq + restCol));
    
    this.img.setPixelArray(pixelArray);
  }
  
  private color[] convertToArray() {
    int iter = 0;
    color[] pixelArray = new color[this.img.getPixelArray().length];
    for (Pixel p : this.thePixels) {
      int pixelCount = p.amount;
      for (int i = 0; i < pixelCount; i++) {
        pixelArray[iter++] = p.getColor();
      }
    }
    return pixelArray;
  }
  
  private class ColorComparator implements Comparator<Pixel> {
    public int compare(Pixel p1, Pixel p2) {
      return p2.amount - p1.amount;
    }
  }
}
