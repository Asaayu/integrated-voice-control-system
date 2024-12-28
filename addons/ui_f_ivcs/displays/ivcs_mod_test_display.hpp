class ivcs_mod_test_display
{
    idd = 65000;
    enableSimulation = 0;

    // Start/Stop the testing engine
    onLoad = "uiNamespace setVariable ['ivcs_test_display',(_this#0)]; 'ivcs' callExtension 'start_test';";
    onUnload = "uiNamespace setVariable ['ivcs_test_display',displayNull]; 'ivcs' callExtension 'end_test';";

    class controlsbackground
    {
        class backgrounddisable: ctrlStaticBackgroundDisable {};
        class backgrounddisabletiles: ctrlStaticBackgroundDisableTiles {};
        class background_main: ctrlStaticBackground
        {
            x = X(0.25);
            y = Y(0.25);
            w = W(0.5);
            h = H(0.5);
            colorBackground[] = {0.2,0.2,0.2,1};
        };
    };
    class controls
    {
        class background_title: ctrlStaticTitle
        {
            style = 2;
            shadow = 2;

            x = X(0.25);
            y = Y(0.24);
            w = W(0.5);
            h = H(0.02);
            sizeEx = H(0.02);

            text = "$STR_IVCS_SETTINGS_TESTING_DISPLAY_TITLE";
        };
        class background_title_exit: ctrlActivePicture
        {
            x = X((0.75 - (0.02/(getResolution select 4))));
            y = Y(0.24);
            w = W((0.02/(getResolution select 4)));
            h = H(0.02);
            color[] = {1,1,1,0.7};
            colorActive[] = {1,1,1,1};
            text = "\a3\3den\Data\ControlsGroups\Tutorial\close_ca.paa";
            onButtonClick = "(ctrlParent (_this#0)) closeDisplay 0;";
        };
        class main_text: ctrlStructuredText
        {
            style = 2;
            shadow = 2;

            x = X(0.25);
            y = Y(0.28);
            w = W(0.5);
            h = H(0.025 * 5);
            size = H(0.025);
            text = "$STR_IVCS_SETTINGS_TESTING_DISPLAY_DESCRIPTION";
            class Attributes
            {
                align = "center";
                color = "#ffffff";
                colorLink = "";
                font = "RobotoCondensed";
                size = 0.9;
            };
        };
        class testing_phrase_01: ctrlStatic
        {
            idc = 1001;
            style = 2;
            shadow = 2;

            x = X(0.25);
            y = Y(0.425);
            w = W(0.5);
            h = H(0.025);
            sizeEx = H(0.025);
            font = "PuristaBold";

            text = "$STR_IVCS_SETTINGS_TESTING_DISPLAY_TEST_01";
        };
        class testing_phrase_02: testing_phrase_01
        {
            idc = 1002;
            y = Y(0.45);
            text = "$STR_IVCS_SETTINGS_TESTING_DISPLAY_TEST_02";
        };
        class testing_phrase_03: testing_phrase_01
        {
            idc = 1003;
            y = Y(0.475);
            text = "$STR_IVCS_SETTINGS_TESTING_DISPLAY_TEST_03";
        };
        class testing_phrase_04: testing_phrase_01
        {
            idc = 1004;
            y = Y(0.5);
            text = "$STR_IVCS_SETTINGS_TESTING_DISPLAY_TEST_04";
        };
        class testing_phrase_05: testing_phrase_01
        {
            idc = 1005;
            y = Y(0.525);
            text = "$STR_IVCS_SETTINGS_TESTING_DISPLAY_TEST_05";
        };
        class current_text_title: main_text
        {
            y = Y(0.65);
            h = H(0.025);
            size = H(0.025);
            text = "$STR_IVCS_SETTINGS_TESTING_DISPLAY_CURRENT_TITLE";
            class Attributes
            {
                align = "center";
                color = "#ffffff";
                colorLink = "";
                font = "RobotoCondensedBold";
                size = 1;
            };
        };
        class current_text: main_text
        {
            idc = 5000;
            x = X(0.275);
            w = W(0.45);
            y = Y(0.675);
            h = H(0.03 * 2);
            size = H(0.03);
            text = "";
            colorbackground[] = {0,0,0,0.25};
            class Attributes
            {
                align = "left";
                color = "#ffffff";
                colorLink = "";
                font = "RobotoCondensedLight";
                size = 1;
            };
        };
    };
};
