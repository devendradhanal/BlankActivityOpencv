<resources>
    <#if !isNewProject>
    <string name="title_${activityToLayout(activityClass)}">${escapeXmlString(activityTitle)}</string>
    </#if>

    <string name="action_settings">Settings</string>

    <#if navType != "none">
    <string name="title_section1">Section 1</string>
    <string name="title_section2">Section 2</string>
    <string name="title_section3">Section 3</string>
    <#else>
    <string name="hello_world">Hello world!</string>
    </#if>

    <string name="app_name">OpenCV App</string>
    <string name="action_info">Info (web site)</string>
    <string name="action_rgbpreview">RGB Preview</string>
    <string name="action_swapcamera">Swap Camera</string>
    <string name="action_toggletitles">Toggle Titles</string>
</resources>
