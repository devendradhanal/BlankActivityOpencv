<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    xmlns:opencv="http://schemas.android.com/apk/res-auto"
    android:layout_width=<#if buildApi lt 8 >"fill_parent"<#else>"match_parent"</#if>
    android:layout_height=<#if buildApi lt 8 >"fill_parent"<#else>"match_parent"</#if>
    tools:context=".${activityClass}">

    <org.opencv.android.JavaCameraView
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:visibility="gone"
        android:adjustViewBounds="true"
        android:gravity="center_vertical"
        android:id="@+id/java_surface_view0" />
    
    <org.opencv.android.JavaCameraView
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:visibility="gone"
        opencv:camera_id="1" 
        android:adjustViewBounds="true"
        android:gravity="center_vertical"
        android:id="@+id/java_surface_view1" />

</LinearLayout>
