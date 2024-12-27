class ivcs_ptt_display
{
    idd = 66000;
    duration = 1e39;
    fadeIn = 0;
    movingEnable = 0;

    onLoad = "uiNamespace setVariable ['ivcs_ptt_display',(_this#0)];";
    onUnload = "uiNamespace setVariable ['ivcs_ptt_display',displayNull];";

    class controlsbackground
    {
        #define SIZE 0.005
        class background_surround_left: ctrlStatic
        {
            idc = 500;
            x = X(0);
            y = Y(0);
            w = W(SIZE);
            h = H(1);
            colorBackground[] = {0.13,0.54,0.21,0.75};
        };
        class background_surround_bottom: background_surround_left
        {
            idc = 501;
            x = X(SIZE);
            y = Y((1-(SIZE*(getResolution select 4))));
            w = W((1-SIZE));
            h = H(SIZE*(getResolution select 4));
        };
        class background_surround_right: background_surround_left
        {
            idc = 502;
            x = X((1-(SIZE)));
            y = Y(SIZE*(getResolution select 4));
            h = H((1-(SIZE*3.75)));
        };
        class background_surround_top: background_surround_bottom
        {
            idc = 504;
            y = Y(0);
        };


        class background_gradient_right: ctrlStaticPicture
        {
            idc = 100;
            fade = 1;
            x = X(0.5);
            y = Y(0.75);
            w = W(0.35);
            h = H(0.2);
            text = "\z\ivcs\addons\ui_f_ivcs\data\ptt_gradient_right_ca.paa";
            colorText[] = {0,0,0,0.5};
        };
        class background_gradient_left: background_gradient_right
        {
            idc = 101;
            fade = 1;
            x = X(0.15);
            text = "\z\ivcs\addons\ui_f_ivcs\data\ptt_gradient_left_ca.paa";
        };
    };
    class controls
    {
        class predicted_text: ctrlStructuredText
        {
            idc = 1000;
            fade = 1;
            style = 2;
            shadow = 2;

            x = X(0.3);
            y = Y(0.832);
            w = W(0.4);
            h = H(0.036);
            size = H(0.036);
            text = "";
            class Attributes
            {
                align = "center";
                color = "#ffffff";
                colorLink = "";
                font = "RobotoCondensed";
                size = 1;
            };
        };
        class confidence_text: predicted_text
        {
            idc = 1001;

            x = X(0.3);
            y = Y(0.868);
            w = W(0.4);
            h = H(0.036*0.5);
            size = H(0.036*0.5);
            text = "";
            class Attributes
            {
                align = "center";
                color = "#c2c2c2";
                colorLink = "";
                font = "RobotoCondensedBold";
                size = 1;
            };
        };
    };
};
