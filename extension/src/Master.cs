using RGiesecke.DllExport;
using System;
using System.Activities;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Speech.Recognition;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using Microsoft.Win32;

namespace Extension
{
    public class Master
    {
        // Function call back stuff
        public static ExtensionCallback callback;
        public delegate int ExtensionCallback([MarshalAs(UnmanagedType.LPStr)] string name, [MarshalAs(UnmanagedType.LPStr)] string function, [MarshalAs(UnmanagedType.LPStr)] string data);

        // Do not remove these six lines
#if WIN64
        [DllExport("RVExtensionRegisterCallback", CallingConvention.Winapi)]
#else
        [DllExport("_RVExtensionRegisterCallback@4", CallingConvention = CallingConvention.Winapi)]
#endif
        public static void RVExtensionRegisterCallback([MarshalAs(UnmanagedType.FunctionPtr)] ExtensionCallback func)
        {
            callback = func;
        }

        // Do not remove these six lines
#if WIN64
        [DllExport("RVExtensionVersion", CallingConvention = CallingConvention.Winapi)]
#else
        [DllExport("_RVExtensionVersion@8", CallingConvention = CallingConvention.Winapi)]
#endif
        public static void RvExtensionVersion(StringBuilder output, int outputSize)
        {
            // Reduce output by 1 to avoid accidental overflow
            outputSize--;

            // Setup the sentry sdk
            //SentrySdk.Init("https://6181346751b5496395f06e6ec7cf70da@o970796.ingest.sentry.io/5922320");
            //SentrySdk.StartSession();
            //SentrySdk.ConfigureScope(scope =>
            //{
            //    scope.SetTag("ivcs_version", Assembly.GetExecutingAssembly().GetName().Version.ToString());
            //    scope.User = new User
            //    {
            //        Id = Environment.GetEnvironmentVariable("STEAMID")
            //    };
            //    scope.Release = Assembly.GetExecutingAssembly().GetName().Version.ToString();
            //});

            // Set the number format
            Functions.nfi.NumberDecimalSeparator = ".";
            Functions.nfi.NumberGroupSeparator = "";

            // Setup the file logging
            Log.Setup();
            Log.Info("Logging system setup complete...");

            Functions.VersionCheck();

            try
            {
                HashSet<string> languages = new HashSet<string>();
                foreach (InputLanguage lang in InputLanguage.InstalledInputLanguages)
                {
                    languages.Add(lang.Culture.EnglishName);
                }

                HashSet<string> recognizers = new HashSet<string>();
                foreach (RecognizerInfo recognizer in SpeechRecognitionEngine.InstalledRecognizers())
                {
                    if (Functions.recognizer == null && recognizer.Culture.ToString() == "en-GB")
                    {
                        Functions.recognizer = recognizer;
                        Functions.culture = "en-GB";
                        Log.Info("Added GB recognizer");
                        //SentrySdk.AddBreadcrumb("Added GB recognizer");
                    }
                    else if (Functions.recognizer == null && recognizer.Culture.ToString() == "en-US")
                    {
                        Functions.recognizer = recognizer;
                        Functions.culture = "en-US";
                        Log.Info("Added US recognizer");
                        //SentrySdk.AddBreadcrumb("Added US recognizer");
                    }
                    recognizers.Add(recognizer.Culture.EnglishName);
                }

                Log.Info($"Languages: {string.Join(", ", languages)}");
                Log.Info($"Recognizers: {string.Join(", ", recognizers)}");
                //SentrySdk.AddBreadcrumb($"Languages: {string.Join(", ", languages)}", "Information", "info", null, BreadcrumbLevel.Info);
                //SentrySdk.AddBreadcrumb($"Recognizers: {string.Join(", ", recognizers)}", "Information", "info", null, BreadcrumbLevel.Info);
            }
            catch (Exception e)
            {
                //SentrySdk.AddBreadcrumb("I think this user has no speech recognisers installed", "Information", "debug", null, BreadcrumbLevel.Debug);
                //SentrySdk.CaptureException(e);
            }

            output.Append(Assembly.GetExecutingAssembly().GetName().Version.ToString());
        }

        // Do not remove these six lines
#if WIN64
        [DllExport("RVExtension", CallingConvention = CallingConvention.Winapi)]
#else
        [DllExport("_RVExtension@12", CallingConvention = CallingConvention.Winapi)]
#endif
        public static void RvExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string function)
        {
            // Reduce output by 1 to avoid accidental overflow
            outputSize--;

            //SentrySdk.AddBreadcrumb(function.ToLower(), "Function Call", "debug", null, BreadcrumbLevel.Debug);

            switch (function.ToLower())
            {
                // PRELOAD: Preload stuff requred for the mod
                case "preload":
                    output.Append("true");
                    return;

                // INFO: Return information about the extension
                case "info":
                    output.Append(Functions.Info());
                    return;

                // RELOAD_GRAMMAR: Reload the grammer currently loaded in the speech recognition engine
                case "reload_grammar":
                    output.Append(Functions.ReloadGrammar());
                    return;

                // GET_CONFIDENCE: Get the language
                case "get_confidence":
                    output.Append(Functions.confidence.ToString(Functions.nfi));
                    return;

                // GET_LANGUAGE: Get the language
                case "get_language":
                    output.Append(Functions.language);
                    return;

                // GET_INITAL_SILENCE: Get the end silence finished timeout
                case "get_inital_silence":
                    output.Append(Functions.inital_silence.ToString(Functions.nfi));
                    return;

                // GET_END_SILENCE_FINISHED: Get the end silence finished timeout
                case "get_end_silence_finished":
                    output.Append(Functions.end_silence_finished.ToString(Functions.nfi));
                    return;

                // GET_END_SILENCE: Get the end silence timeout
                case "get_end_silence":
                    output.Append(Functions.end_silence.ToString(Functions.nfi));
                    return;

                // GET_END_BABBEL: Get the end babbel timeout
                case "get_end_babbel":
                    output.Append(Functions.end_babbel.ToString(Functions.nfi));
                    return;

                // START_TEST: Start test voice recognition
                case "start_test":
                    // Create the testing thread
                    Functions.testing_thread = new Thread(Functions.Test);
                    Functions.testing_thread.Start();
                    output.Append("true");
                    return;

                // END_TEST: Start test voice recognition
                case "end_test":
                    // End the testing thread
                    Functions.TestEnd();
                    if (Functions.testing_thread != null)
                        Functions.testing_thread.Abort();
                    output.Append("true");
                    return;

                // PTT_DOWN: Enable voice input
                case "ptt_down":
                    // Create the PTT thread
                    Functions.PttDown();
                    output.Append("true");
                    return;

                // PTT_UP: Enable voice input
                case "ptt_up":
                    // End the PTT thread
                    Functions.PttUp();
                    output.Append("true");
                    return;

                // MISSION_START: Creates the speech engine, but does not enable the input device
                case "mission_start":
                    // Only create one engine
                    if (Functions.main_thread != null)
                    {
                        output.Append("false");
                        return;
                    };

                    // Create the main thread
                    Functions.main_thread = new Thread(Functions.MissionStart);
                    Functions.main_thread.Start();
                    output.Append("true");
                    return;
                    
                // OPEN_TRAINING: Opens the control panel and opens the speech training UI
                case "open_training":
                    // Do not allow clients to edit this string
                    string training_file = $"{Environment.SystemDirectory}" + @"\Speech\SpeechUX\SpeechUXWiz.exe";
                    try
                    {
                        if (!File.Exists(training_file))
                            throw new FileNotFoundException($"File '{training_file}' could not be found.");
                        
                        Process.Start(training_file, "UserTraining");
                        output.Append("true");
                    }
                    catch (FileNotFoundException)
                    {
                        MessageBox.Show($"File '{training_file}' could not be found.", "File not found", MessageBoxButtons.OK);
                    }
                    catch (Exception e)
                    {
                        Log.Error($"An exception occurred when attempting to open Windows speech training software.", e);
                    }
                    return;
                    
                // OPEN_SPEECH_SETTINGS: Opens the speech language settings
                case "open_speech_settings":
                    // Do not allow clients to edit this string
                    string settings_file = "ms-settings:speech";
                    try
                    {
                        string windows_version = Registry.GetValue(@"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentMajorVersionNumber", "").ToString();
                        if (windows_version != "10")
                            throw new VersionMismatchException("Windows 10 is required to open this link.");

                        Process.Start(settings_file);
                        output.Append("true");
                    }
                    catch (VersionMismatchException vme)
                    {
                        Log.Error($"Windows 10 is required to open this link.", vme);
                    }
                    catch (Exception e)
                    {
                        Log.Error($"An exception occurred when attempting to open Windows speech settings software.", e);
                    }
                    return;

                    // OPEN_SOUND_CONTROL_PANEL_SETTINGS: Opens the sound control panel settings
                case "open_sound_control_panel_settings":                    
                    try
                    {
                        // Do not allow clients to edit this
                        Process.Start(Path.Combine(Environment.SystemDirectory, "control.exe"), "/name Microsoft.Sound");
                        output.Append("true");
                    }
                    catch (Exception e)
                    {
                        Log.Error($"An exception occurred when attempting to open Windows sound control panel.", e);
                    }
                    return;
            }
        }

        // Do not remove these six lines
#if WIN64
        [DllExport("RVExtensionArgs", CallingConvention = CallingConvention.Winapi)]
#else
        [DllExport("_RVExtensionArgs@20", CallingConvention = CallingConvention.Winapi)]
#endif
        public static int RvExtensionArgs(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string function, [MarshalAs(UnmanagedType.LPArray, ArraySubType = UnmanagedType.LPStr, SizeParamIndex = 4)] string[] args, int argCount)
        {
            // Reduce output by 1 to avoid accidental overflow
            outputSize--;

            if (argCount <= 0)
                return -2;

            //SentrySdk.AddBreadcrumb(function.ToLower(), "Function Call (Array)", "debug", null, BreadcrumbLevel.Debug);

            args[0] = args[0].Replace("\"", "");
            switch (function.ToLower())
            {
                // SET_CONFIDENCE: Set the confidence value that needs to be passed for a 
                case "set_confidence":
                    double value = double.Parse(args[0].Replace(",", "."), Functions.nfi);
                    if (Functions.confidence != value)
                    {
                        Log.Info($"Changing confidence value from {Functions.confidence} to {value}...");
                        Functions.confidence = value;
                    }
                    output.Append(Functions.confidence.ToString(Functions.nfi));
                    return 1;

                // SET_LANGUAGE: Set the language file to be used in the speech recognition grammar
                case "set_language":
                    if (Functions.language != args[0])
                    {
                        Log.Info($"Changing language from {Functions.language} to {args[0]}...");
                        Functions.language = args[0];
                    }
                    output.Append(Functions.language);
                    return 1;

                // SET_INITAL_SILENCE: Set the inital silence timeout
                case "set_inital_silence":
                    try
                    {
                        double _value = double.Parse(args[0].Replace(",", "."), Functions.nfi);
                        if (Functions.inital_silence != _value)
                        {
                            Log.Info($"Changing inital_silence timeout from {Functions.inital_silence} to {_value}...");
                            Functions.inital_silence = _value;
                            if (Functions.speech_engine != null)
                                Functions.speech_engine.InitialSilenceTimeout = TimeSpan.FromSeconds(Functions.inital_silence);
                        }
                        output.Append(Functions.inital_silence.ToString(Functions.nfi));
                        return 1;
                    }
                    catch (ArgumentOutOfRangeException)
                    {
                        // Reset the number to the default value
                        Functions.inital_silence = 0.15;
                        if (Functions.speech_engine != null)
                            Functions.speech_engine.InitialSilenceTimeout = TimeSpan.FromSeconds(0.15);

                        return -1;
                    }
                    

                // SET_END_SILENCE_FINISHED: Set the inital silence timeout
                case "set_end_silence_finished":
                    try
                    {
                        double __value = double.Parse(args[0].Replace(",", "."), Functions.nfi);
                        if (Functions.end_silence_finished != __value)
                        {
                            Log.Info($"Changing end silence finished timeout from {Functions.end_silence_finished} to {__value}...");
                            Functions.end_silence_finished = __value;
                            if (Functions.speech_engine != null)
                                Functions.speech_engine.EndSilenceTimeout = TimeSpan.FromSeconds(Functions.end_silence_finished);
                        }
                        output.Append(Functions.end_silence_finished.ToString(Functions.nfi));
                        return 1;
                    }
                    catch (ArgumentOutOfRangeException)
                    {
                        // Reset the number to the default value
                        Functions.end_silence_finished = 0.5;
                        if (Functions.speech_engine != null)
                            Functions.speech_engine.EndSilenceTimeout = TimeSpan.FromSeconds(0.5);

                        return -1;
                    }
                    

                // SET_END_SILENCE: Set the end silence timeout
                case "set_end_silence":
                    try
                    {
                        double ___value = double.Parse(args[0].Replace(",", "."), Functions.nfi);
                        if (Functions.end_silence != ___value)
                        {
                            Log.Info($"Changing end silence timeout from {Functions.end_silence} to {___value}...");
                            Functions.end_silence = ___value;
                            if (Functions.speech_engine != null)
                                Functions.speech_engine.EndSilenceTimeoutAmbiguous = TimeSpan.FromSeconds(Functions.end_silence);
                        }
                        output.Append(Functions.end_silence.ToString(Functions.nfi));
                        return 1;
                    }
                    catch (ArgumentOutOfRangeException)
                    {
                        // Reset the number to the default value
                        Functions.end_silence = 0.15;
                        if (Functions.speech_engine != null)
                            Functions.speech_engine.EndSilenceTimeoutAmbiguous = TimeSpan.FromSeconds(0.15);

                        return -1;
                    }
                    

                // SET_END_BABBEL: Set the end babbel timeout
                case "set_end_babbel":
                    try
                    {
                        double ____value = double.Parse(args[0].Replace(",", "."), Functions.nfi);
                        if (Functions.end_babbel != ____value)
                        {
                            Log.Info($"Changing end babbel timeout from {Functions.end_babbel} to {____value}...");
                            Functions.end_babbel = ____value;
                            if (Functions.speech_engine != null)
                                Functions.speech_engine.BabbleTimeout = TimeSpan.FromSeconds(Functions.end_babbel);
                        }
                        output.Append(Functions.end_babbel.ToString(Functions.nfi));
                        return 1;
                    }
                    catch (ArgumentOutOfRangeException)
                    {
                        // Reset the number to the default value
                        Functions.end_babbel = 0.0;
                        if (Functions.speech_engine != null)
                            Functions.speech_engine.BabbleTimeout = TimeSpan.FromSeconds(0.0);

                        return -1;
                    }
                    

                // CONVERT_NUMBER_READABLE: Convert a number from text to digets
                case "convert_number_readable":
                    output.Append(Functions.ReadableNumbers(args[0]));
                    return 1;
                    
                // REPLACE: Replace second argument with third arguemnt in first argument
                case "replace":
                    if (argCount < 3)
                        return -1;

                    args[1] = args[1].Replace("\"", "");
                    args[2] = args[2].Replace("\"", "");
                    output.Append(args[0].Replace(args[1], args[2]));
                    return 1;
                    
                // NUMBER_CHECK: Check if only numbers are in the provided string
                case "number_check":
                    if (argCount < 1)
                        return -1;

                    output.Append(args[0].All(char.IsDigit).ToString(Functions.nfi));
                    return 1;
                    
                // TITLE_CASE: Convert string to title case
                case "title_case":
                    if (argCount < 1)
                        return -1;

                    output.Append(CultureInfo.CurrentCulture.TextInfo.ToTitleCase(args[0])
                        .Replace("Team, ", "Team ")
                        .Replace("Red, ", "Red ")
                        .Replace("Green, ", "Green ")
                        .Replace("Blue, ", "Blue ")
                        .Replace("Yellow, ", "Yellow ")
                        .Replace("White, ", "White ")
                        );
                    return 1;
            }
            return 0;
        }
    }
}