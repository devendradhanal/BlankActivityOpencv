<menu xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:id="@+id/action_settings"
        android:title="@string/action_settings"
        android:orderInCategory="100"<#if buildApi gte 11>
        android:showAsAction="never"</#if> />

    <item android:id="@+id/action_info" 
	    android:orderInCategory="100"
	    <#if buildApi gte 11> 
	    android:showAsAction="never" 
	    </#if>
	    android:title="@string/action_info"/>
    
    <item android:id="@+id/action_rgbpreview" 
	    android:orderInCategory="100"
	    <#if buildApi gte 11> 
	    android:showAsAction="never" 
	    </#if>
	    android:title="@string/action_rgbpreview"/>   

     <item android:id="@+id/action_swapcamera" 
	     android:orderInCategory="100" 
	     <#if buildApi gte 11>
	     android:showAsAction="never" 
	     </#if>
	     android:title="@string/action_swapcamera"/>

    <item android:id="@+id/action_toggletitles" 
	    android:orderInCategory="100" 
	    <#if buildApi gte 11>
	    android:showAsAction="never" 
	    </#if>
	    android:title="@string/action_toggletitles"/> 
</menu>
