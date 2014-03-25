package ${packageName};

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.opencv.android.BaseLoaderCallback;
import org.opencv.android.CameraBridgeViewBase.CvCameraViewListener;
import org.opencv.android.JavaCameraView;
import org.opencv.android.LoaderCallbackInterface;
import org.opencv.android.OpenCVLoader;
import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Mat;

import org.opencv.core.Point;

import org.opencv.core.Scalar;
import org.opencv.core.Size;
import org.opencv.highgui.Highgui;
import org.opencv.imgproc.Imgproc;

import android.net.Uri;
import android.os.Environment;
import android.annotation.SuppressLint;

import android.content.Intent;
import android.hardware.Camera;
import android.util.DisplayMetrics;

import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.SurfaceView;
import android.view.WindowManager;
import android.widget.Toast;
import android.widget.LinearLayout.LayoutParams;


import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;
<#if parentActivityClass != "">
import android.view.MenuItem;
import android.support.v4.app.NavUtils;
<#if minApiLevel < 11>
import android.annotation.TargetApi;
import android.os.Build;
</#if>
</#if>

public class ${activityClass} extends Activity implements CvCameraViewListener {
    public static final int     VIEW_MODE_RGBA  =                 0;
    public static int           viewMode = VIEW_MODE_RGBA;
    private boolean bShootNow = false, bDisplayTitle = true;
    private double dTextScaleFactor;

    private int iFileOrdinal = 0, iCamera = 0, iNumberOfCameras = 0;

    private JavaCameraView mOpenCvCameraView0;
    private JavaCameraView mOpenCvCameraView1;
    private long lFrameCount = 0, lMilliStart = 0, lMilliNow = 0, lMilliShotTime = 0;
    private Mat mRgba,mIntermediateMat;


    private Scalar colorRed, colorGreen;
    private Size sMatSize;
    private String string, sShotText;

    private BaseLoaderCallback  mLoaderCallback = new BaseLoaderCallback(this) {
        @Override
        public void onManagerConnected(int status) {
            switch (status) {
                case LoaderCallbackInterface.SUCCESS:
                {
                    mOpenCvCameraView0.enableView();
                    
                    if (iNumberOfCameras > 1)    
                        mOpenCvCameraView1.enableView();
                         } break;
                default:
                {
                    super.onManagerConnected(status);
                } break;
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        iNumberOfCameras = Camera.getNumberOfCameras();
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        setContentView(R.layout.${layoutName});

         mOpenCvCameraView0 = (JavaCameraView) findViewById(R.id.java_surface_view0);
        
        if (iNumberOfCameras > 1)
            mOpenCvCameraView1 = (JavaCameraView) findViewById(R.id.java_surface_view1);
        
        mOpenCvCameraView0.setVisibility(SurfaceView.VISIBLE);
        mOpenCvCameraView0.setCvCameraViewListener(this);
        
        mOpenCvCameraView0.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));

        if (iNumberOfCameras > 1) {
            mOpenCvCameraView1.setVisibility(SurfaceView.GONE);
            mOpenCvCameraView1.setCvCameraViewListener(this);
            mOpenCvCameraView1.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
            }

        OpenCVLoader.initAsync(OpenCVLoader.OPENCV_VERSION_2_4_4, this, mLoaderCallback);

        <#if parentActivityClass != "">
        // Show the Up button in the action bar.
        setupActionBar();
        </#if>
    }

    <#if parentActivityClass != "">
    /**
     * Set up the {@link android.app.ActionBar}<#if minApiLevel < 11>, if the API is available</#if>.
     */
    <#if minApiLevel < 11>@TargetApi(Build.VERSION_CODES.HONEYCOMB)
    </#if>private void setupActionBar() {
        <#if minApiLevel < 11>if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {</#if>
        getActionBar().setDisplayHomeAsUpEnabled(true);
        <#if minApiLevel < 11>}</#if>
    }
    </#if>

     @Override
    public void onPause()
        {
        super.onPause();
        if (mOpenCvCameraView0 != null) 
            mOpenCvCameraView0.disableView();
        if (iNumberOfCameras > 1)
            if (mOpenCvCameraView1 != null) 
                mOpenCvCameraView1.disableView();
        }


    public void onResume()
        {
        super.onResume();
            
        viewMode = VIEW_MODE_RGBA;
            
        OpenCVLoader.initAsync(OpenCVLoader.OPENCV_VERSION_2_4_4, this, mLoaderCallback);
        }

        
    public void onDestroy() {
        super.onDestroy();
        if (mOpenCvCameraView0 != null) 
            mOpenCvCameraView0.disableView();
        if (iNumberOfCameras > 1)
            if (mOpenCvCameraView1 != null) 
                mOpenCvCameraView1.disableView();
        }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.action_info) {
            Intent myIntent1 = new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.barrythomas.co.uk/machinevision.html"));
            startActivity(myIntent1);
        } else if (item.getItemId() == R.id.action_rgbpreview) {
            viewMode = VIEW_MODE_RGBA;
            lFrameCount = 0;
            lMilliStart = 0;
        } else if (item.getItemId() == R.id.action_toggletitles) {
            if (bDisplayTitle == true)
                bDisplayTitle = false;
            else
                bDisplayTitle = true;
        } else if (item.getItemId() == R.id.action_swapcamera) {
            if (iNumberOfCameras > 1) {
                if (iCamera == 0) {
                    mOpenCvCameraView0.setVisibility(SurfaceView.GONE);
                    mOpenCvCameraView1 = (JavaCameraView) findViewById(R.id.java_surface_view1);
                    mOpenCvCameraView1.setCvCameraViewListener(this);
                    mOpenCvCameraView1.setVisibility(SurfaceView.VISIBLE);
                
                    iCamera = 1;
                    }
                else {
                    mOpenCvCameraView1.setVisibility(SurfaceView.GONE);
                    mOpenCvCameraView0 = (JavaCameraView) findViewById(R.id.java_surface_view0);
                    mOpenCvCameraView0.setCvCameraViewListener(this);
                    mOpenCvCameraView0.setVisibility(SurfaceView.VISIBLE);
                    
                    iCamera = 0;
                    }
                }
            else
                Toast.makeText(getApplicationContext(), "Sadly, your device does not have a second camera",
                        Toast.LENGTH_LONG).show();
            }
        
        return true;
        }

        @Override
    public void onCameraViewStarted(int width, int height) {
    colorRed = new Scalar(255, 0, 0, 255);
        colorGreen = new Scalar(0, 255, 0, 255);
               mIntermediateMat = new Mat();
                mRgba = new Mat();
                sMatSize = new Size();
                string = "";

        DisplayMetrics dm = this.getResources().getDisplayMetrics(); 
        int densityDpi = dm.densityDpi;
        dTextScaleFactor = ((double)densityDpi / 240.0) * 0.9;

        mRgba = new Mat(height, width, CvType.CV_8UC4);
        mIntermediateMat = new Mat(height, width, CvType.CV_8UC4);
        
        
    }

    @Override
    public void onCameraViewStopped() {
        releaseMats();
    }

    public void releaseMats () {
        mRgba.release();
        mIntermediateMat.release();
          }

          @Override
    public Mat onCameraFrame(Mat inputFrame) {
    if (lMilliStart == 0)
            lMilliStart = System.currentTimeMillis();

        if ((lMilliNow - lMilliStart) > 10000) {
            lMilliStart = System.currentTimeMillis(); 
            lFrameCount = 0;
            }

        inputFrame.copyTo(mRgba);
        sMatSize.width = mRgba.width();
        sMatSize.height = mRgba.height();
        
        switch (viewMode) {

        case VIEW_MODE_RGBA:
            
            if (bDisplayTitle)
                ShowTitle ("BGR Preview", 1, colorGreen);
            
            break;
                 }
        
        // get the time now in every frame
        lMilliNow = System.currentTimeMillis(); 
            
        // update the frame counter
        lFrameCount++;
        
        if (bDisplayTitle) {
            string = String.format("FPS: %2.1f", (float)(lFrameCount * 1000) / (float)(lMilliNow - lMilliStart));

            ShowTitle (string, 2, colorGreen);
            }
        
        if (bShootNow) {
            // get the time of the attempt to save a screenshot
            lMilliShotTime = System.currentTimeMillis();
            bShootNow = false;
            
            // try it, and set the screen text accordingly.
            // this text is shown at the end of each frame until 
            // 1.5 seconds has elapsed
            if (SaveImage (mRgba)) {
                sShotText = "SCREENSHOT SAVED";
                }
            else {
                sShotText = "SCREENSHOT FAILED";
                }
                
            }

        if (System.currentTimeMillis() - lMilliShotTime < 1500)
            ShowTitle (sShotText, 3, colorRed);
        
        return mRgba;
    }

    public boolean onTouchEvent(final MotionEvent event) {
        
        bShootNow = true;
        return false; // don't need more than one touch event
            
        }

         @SuppressLint("SimpleDateFormat")
    public boolean SaveImage (Mat mat) {
        
        Imgproc.cvtColor(mat, mIntermediateMat, Imgproc.COLOR_RGBA2BGR, 3);

        File path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
        
        String filename = "OpenCV_";
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss");
        Date date = new Date(System.currentTimeMillis());
        String dateString = fmt.format(date);
        filename += dateString + "-" + iFileOrdinal;
        filename += ".png";
        
        File file = new File(path, filename);
            
        Boolean bool = null;
        filename = file.toString();
        bool = Highgui.imwrite(filename, mIntermediateMat);
        
        //if (bool == false)
            //Log.d("Baz", "Fail writing image to external storage");
        
        return bool;
        
        }

        private void ShowTitle (String s, int iLineNum, Scalar color) {
        Core.putText(mRgba, s, new Point(10, (int)(dTextScaleFactor * 60 * iLineNum)), 
                 Core.FONT_HERSHEY_SIMPLEX, dTextScaleFactor, color, 2);
        }
    

    <#include "include_onCreateOptionsMenu.java.ftl">
    <#include "include_onOptionsItemSelected.java.ftl">

}
