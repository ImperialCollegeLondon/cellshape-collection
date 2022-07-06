/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


package OPM;

/*import java.io.File;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.ShortBuffer;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;
import loci.formats.ImageReader; */

import loci.formats.FormatException; 

import java.util.ArrayList;
import java.io.IOException;
import java.util.Arrays;

/**
 *
 * @author imunro
 */
public class OPMReconstruction {
  
  private final OPMReconstructer[] reconstrArr;
  private final Thread[] tArr;
  private final int nthreads;
  private ArrayList<short[]> data;
  private int sizeX, sizeY, nimg;
  private int nzout, nyout;

  private static int[][] zrange;

  private final double theta;
  private final double tantheta, sintheta, costheta;

  private double scanEnd;
  private final double pixSize;
  private Boolean overSize;
  private short[] Jout;
  private short[][] Jout2D;
  private final double trg_dist;
  private final double acq_ds;
  private final double step;
  
  
  
  public OPMReconstruction(int nthreads, double theta, double pixSize , double trg_dist, double acq_ds) {
    
    this.nthreads = nthreads;
    this.tArr = new Thread[nthreads];
    this.theta = theta;
    this.Jout = null;
    tantheta = Math.tan(theta);
    sintheta = Math.sin(theta);
    costheta = Math.cos(theta);
    this.pixSize = pixSize;
    this.trg_dist = trg_dist;
    step = trg_dist / pixSize;  //Distance between two planes in pix
    this.acq_ds = acq_ds;
    
   
    reconstrArr = new OPMReconstructer[nthreads];
    
    for (int t = 0; t < nthreads; t++) {
      this.reconstrArr[t] = new OPMReconstructer(t);
    }
     // zrange determines that start and end valuse for zout for each thread
    zrange = new int[nthreads][2];
    
    this.nimg = 0;
    this.sizeX = 0;
    this.sizeY = 0;
  }
  
  
  public int getSizeZ()  {
    return nzout;
  }
  
  public int getSizeY()  {
    return nyout;
  }
  
  public short[][] getOversize()  {
    return Jout2D;
  }
 
  /**
   *
   * @param data
   * @param sizeX
   * @param sizeY
   * @param zeroValue
   * @return
   */
  
  public short[] reconstruct(ArrayList<short[]> data, int sizeX, int sizeY, short zeroValue)  {
    // zero value is the value of pixels which do not contain data. This is set in matlab code calling this script. Because short is used this should be -2^15 if adjusting to prevent overflow errors
    this.data = data;
    
    if (Jout == null || this.nimg != data.size()  || this.sizeX != sizeX   || this.sizeY  != sizeY) {
      
      nimg = data.size();
      scanEnd = nimg * trg_dist / pixSize ; //numerator is the number of images * distance between images (so real distance covered in the scan
      this.sizeX = sizeX;
      this.sizeY = sizeY;
      
      this.nzout = (int) Math.ceil(sizeY * Math.sin(theta));
      this.nyout = (int) Math.ceil(scanEnd + sizeY * Math.cos(theta));
      
      long requested = (long)nzout * (long)nyout * (long)sizeX;
      int requestedi = nzout * nyout * sizeX;
      
      // Seems to be too large to allocate a 1D array
      if (requested != requestedi ) {
        System.out.println("Oversize Array returning 2D!" );
        overSize = true;
        Jout = null;
        Jout2D = new short[nzout][nyout * sizeX];
        Arrays.fill(Jout2D, zeroValue);
      }
      else {
        System.out.println("Returning 1D array for speed!" );
        overSize = false;
        Jout = new short[nzout * nyout * sizeX];
        Arrays.fill(Jout, zeroValue);
        Jout2D = null;
      }
     
      int zblock = (int) Math.floor(nzout / nthreads) - 1;

      int zo = 0;
      for (int t = 0; t < nthreads; t++) {
        zrange[t][0] = zo;
        zo += zblock;
        zrange[t][1] = zo;
        zo += 1;
      }
      zrange[nthreads - 1][1] = nzout - 1;
      
    }
    

    for (int t = 0; t < nthreads; t++) {
      tArr[t] = new Thread(reconstrArr[t]);
      tArr[t].setPriority(Thread.MAX_PRIORITY);
      tArr[t].start();
    }
     
    for (int t = 0; t < nthreads; t++) {
      try {
        tArr[t].join();
      } catch (InterruptedException e) {
      }
    } 
     
    return Jout;
  }
  
 
// inner threaded class
  private class OPMReconstructer implements Runnable {

    //private ArrayList<short[]> Jout;
    
    private final int threadno;
    
    private OPMReconstructer(int threadno) {

      this.threadno = threadno;
      
    }

  

    @Override
    public void run() {

      
   
      double virtual_plane, l_before, l_after, za;
      double virtual_pos_before, virtual_pos_after, dz_before, dz_after;
      double m1, m2, m3, m4;
      int planeOutSize = nyout * sizeX;

      double[] line = new double[sizeX];

      int y1, y2;
      int plane_before;
      int pos_before, pos_after;
      int index;
      int z;
      short[] plane;
      int indexOut;

      int zstart = zrange[threadno][0];
      int zend = zrange[threadno][1];
      
      for (int zcnt = zstart; zcnt <= zend ; zcnt++) {

        z = zcnt + 1;
        za = z / sintheta;
        
        //short[] planeOut = new short[nyout * sizeX];

        y1 = (int) Math.floor(z / tantheta);
        if (y1 < 1) {
          y1 = 1;
        }
        y2 = (int) Math.ceil(scanEnd + z / tantheta + 1);
        if (y2 > nyout) {
          y2 = nyout;
        }
        
        int zindex = planeOutSize * zcnt;
        
        for (int y = y1; y <= y2; y++) {
          virtual_plane = y - z / tantheta - acq_ds / pixSize;
          plane_before = (int) Math.floor(virtual_plane / step);

          if (plane_before >= 1 && plane_before <= (nimg - 1)) {

            l_before = virtual_plane - plane_before * step;
            l_after = (step - l_before);

            virtual_pos_before = za + l_before * costheta;
            virtual_pos_after = za - l_after * costheta;
            pos_before = (int) Math.floor(virtual_pos_before);
            pos_after = (int) Math.floor(virtual_pos_after);

            if (pos_before >= 1 & pos_after >= 1 & pos_before < sizeY & pos_after < sizeY) {

              dz_before = virtual_pos_before - pos_before;
              dz_after = virtual_pos_after - pos_after;

              
              // pre-divide by step 
              l_before /= step;
              l_after /= step;

              // img that corresponds to plane_after + 1 == plane_after in 0...n numbering
              // plane_after = plane_before +1 
              // c style numbered plane_after = plane_after -1
              plane = data.get(plane_before);
              
              // calculate appropriate multipliers
              m1 = l_before * dz_after;
              // calculate index into plane == (pos_after + 1) again -1 for c_stylenumbering
              index = sizeX * pos_after;
              for (int x = 0; x < sizeX; x++) {
                line[x] = (double) plane[index] * m1;
                index++;
              }

              m2 = l_before * (1 - dz_after);
              // N.B. Possible to optimise by changing order ?
              index = sizeX * (pos_after - 1);
              for (int x = 0; x < sizeX; x++) {
                line[x] += (double) plane[index] * m2;
                index++;
              }

              //Get a second plane
              plane = data.get(plane_before - 1);

              m3 = l_after * dz_before;
              index = sizeX * (pos_before);
              for (int x = 0; x < sizeX; x++) {
                line[x] += (double) plane[index] * m3;
                index++;
              }

              m4 = l_after * (1 - dz_before);
              // N.B. Possible to optimise by changing order ?
              index = sizeX * (pos_before - 1);
              
             
              if (overSize == true) {
                indexOut = ((y -1) * sizeX);
                for (int x = 0; x < sizeX; x++) {
                  line[x] += (double) plane[index] * m4;   
                  Jout2D[zcnt][indexOut] = (short) Math.floor(line[x]);
                  index++;
                  indexOut++;
                }
              }  
              else {
                indexOut = zindex + ((y -1) * sizeX);
                for (int x = 0; x < sizeX; x++) {
                  line[x] += (double) plane[index] * m4;
                  Jout[indexOut] = (short) Math.floor(line[x]);
                  index++;
                  indexOut++;
                }
              }

            }
          }

        }   // end for y

     
      }  // end z 

    } //end run
  }
  

  //public static void main(String[] args)  {
  public static void main(String[] args) throws FormatException, IOException {
      
      loci.common.DebugTools.enableLogging("ERROR");

      // ask user for test file
      String filename;
      /*JFileChooser chooser = new JFileChooser(System.getProperty("java.class.path"));
      FileNameExtensionFilter filter = new FileNameExtensionFilter("TIF files", "tif");
      chooser.setFileFilter(filter);
      int returnVal = chooser.showOpenDialog(null);
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        filename = chooser.getSelectedFile().getAbsolutePath();
      } */

      /*
      //filename = "/Users/imunro/OPM-mex-reconstruction/run_00_well_C5_sensitised.tif";
      filename = "/Users/imunro/Downloads/Ians_example/large_dataset_cant_reslice.tif";
       File file = new File(filename);
      if (file.exists() & file.canRead()) {
        ImageReader reader = new ImageReader();
        try {
          reader.setId(filename);
        } catch (FormatException | IOException ex) {
          Logger.getLogger(OPMReconstruction.class.getName()).log(Level.SEVERE, null, ex);
        }
        int nnimg = reader.getImageCount();
        // should be 1000 x 1280
        int ssizeX = reader.getSizeX();
        int ssizeY = reader.getSizeY();
        ArrayList<short[]> ddata = new ArrayList<>();
        ShortBuffer sb;
        ddata.clear();
        for (int img = 0; img < nnimg; img++) {
            sb = ByteBuffer.wrap(reader.openBytes(img)).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer();
            short[] plane = new short[ssizeX * ssizeY];
            sb.get(plane);
            ddata.add(plane);
        } 
       
       
        double theta = 35 * Math.PI / 180;
        
        double pix_size = 0.25;
        double trg_dist = 1;
        double acq_ds = 0;
       
        int nthreads;
      
        long startTime, endTime, duration;
        Scanner input = new Scanner(System.in);
        System.out.println(" Number of threads!");
        String number = input.next();
        nthreads = Integer.parseInt(number);
        System.out.println(Integer.toString(nthreads) + " Threads!");
        
        OPMReconstruction reconst = new OPMReconstruction(nthreads, theta, pix_size, trg_dist, acq_ds);
        
        startTime = System.nanoTime();
        short[] result = reconst.reconstruct(ddata, ssizeX, ssizeY);
        
        System.out.println("Size = "); 
        System.out.println(Integer.toString(result.length));
        
        endTime = System.nanoTime();
        duration = (endTime - startTime);  //divide by 1000000 to get milliseconds.
        System.out.println("Run Duration in ms = " + Long.toString(duration / 1000000));  
        
        
             
      } */

    }
  }