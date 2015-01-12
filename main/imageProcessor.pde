
class imageProcessor extends PImage {
  
  public final int MAX_WIDTH = 640;   //2592;
  public final int MAX_HEIGHT = 480;  //1728;
  private PImage theImage;
  private PImage initialImage;
  
  public int theWidth;
  public int theHeight;
  
  imageProcessor(String path) {
    this.theImage = loadImage(path);
    this.initialImage = loadImage(path);
    
    if (this.theImage.width > MAX_WIDTH || this.theImage.height > MAX_HEIGHT) {
      this.resize();
    }
    
    this.theWidth = this.theImage.width;
    this.theHeight = this.theImage.height;
    
    this.convertTo255();
    this.theImage.loadPixels();
  }
  
  public void resize() {
    float newWidth, newHeight;
    
    float widthFactor = (float) this.theImage.width / (float) MAX_WIDTH;
    float heightFactor = (float) this.theImage.height / (float) MAX_HEIGHT;
    
    if (widthFactor > heightFactor) {
      newWidth = MAX_WIDTH;
      newHeight = this.theImage.height / widthFactor;
    } else {
      newWidth = this.theImage.width / heightFactor;//newWidth = widthFactor < 1.0 ? MAX_WIDTH * widthFactor : MAX_WIDTH / widthFactor;
      newHeight = MAX_HEIGHT;
    }
    System.out.println("Specs: " + newWidth + ", " + newHeight);
    System.out.println("Factors: " + widthFactor + ", " + heightFactor);
//    if (this.isLandscape()) {
      this.theImage.resize(Math.round(newWidth), Math.round(newHeight));
//    } else {
//      this.theImage.resize(Math.round(newHeight), Math.round(newWidth));
//    }
  }
  
  public boolean isLandscape() {
    float alignment = (float) this.theImage.width / (float) this.theImage.height;
    return alignment > 1.0;
  }
  
  public void convertTo255() {
    this.theImage.filter(POSTERIZE, 255);
  }
  
  public color[] getPixelArray() {
    return this.theImage.pixels;
  }
  
  public void setPixelArray(color[] c) {
    this.theImage.pixels = c;
    this.theImage.updatePixels();
  }
  
  public PImage returnImage() {
    return this.theImage;
  }
  
  public PImage initialImage() {
    return this.initialImage;
  }
}
