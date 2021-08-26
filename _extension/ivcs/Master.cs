using RGiesecke.DllExport;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Speech.Recognition;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Windows.Forms;
using Sentry;
using System.Reflection;
using System.Net;
using System.Net.Http;
using System.Activities;
using System.Diagnostics;
using System.Security.Authentication;
using Microsoft.Win32;

namespace ivcs
{
    public class Master
    {
        // Function call back stuff
        public static ExtensionCallback callback;
        public delegate int ExtensionCallback([MarshalAs(UnmanagedType.LPStr)] string name, [MarshalAs(UnmanagedType.LPStr)] string function, [MarshalAs(UnmanagedType.LPStr)] string data);

        // Do not remove these six lines
#if WIN64
        [DllExport("RVExtensionRegisterCallback", CallingConvention = CallingConvention.Winapi)]
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
            SentrySdk.Init("https://6181346751b5496395f06e6ec7cf70da@o970796.ingest.sentry.io/5922320");
            SentrySdk.StartSession();
            SentrySdk.ConfigureScope(scope =>
            {
                scope.SetTag("ivcs_version", Assembly.GetExecutingAssembly().GetName().Version.ToString());
                scope.User = new User
                {
                    Id = Environment.GetEnvironmentVariable("STEAMID")
                };
                scope.Release = Assembly.GetExecutingAssembly().GetName().Version.ToString();
            });

            // Set the number format
            Function.nfi.NumberDecimalSeparator = ".";
            Function.nfi.NumberGroupSeparator = "";

            // Setup the file logging
            Log.Setup();
            Log.Info("Logging system setup complete...");

            Function.VersionCheck();

            HashSet<string> languages = new HashSet<string>();
            foreach (InputLanguage lang in InputLanguage.InstalledInputLanguages)
            {
                languages.Add(lang.Culture.EnglishName);
            }

            HashSet<string> recognizers = new HashSet<string>();
            foreach (RecognizerInfo recognizer in SpeechRecognitionEngine.InstalledRecognizers())
            {
                recognizers.Add(recognizer.Culture.EnglishName);
            }

            Log.Info($"Languages: {string.Join(", ", languages)}");
            Log.Info($"Recognizers: {string.Join(", ", recognizers)}");
            SentrySdk.AddBreadcrumb($"Languages: {string.Join(", ",languages)}", "Information", "info", null, BreadcrumbLevel.Info);
            SentrySdk.AddBreadcrumb($"Recognizers: {string.Join(", ", recognizers)}", "Information", "info", null, BreadcrumbLevel.Info);

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

            SentrySdk.AddBreadcrumb(function.ToLower(), "Function Call", "debug", null, BreadcrumbLevel.Debug);

            switch (function.ToLower())
            {
                // PRELOAD: Preload stuff requred for the mod
                case "preload":
                    output.Append("true");
                    return;

                // INFO: Return information about the extension
                case "info":
                    output.Append(Function.Info());
                    return;

                // RELOAD_GRAMMAR: Reload the grammer currently loaded in the speech recognition engine
                case "reload_grammar":
                    output.Append(Function.ReloadGrammar());
                    return;

                // GET_CONFIDENCE: Get the language
                case "get_confidence":
                    output.Append(Function.confidence.ToString(Function.nfi));
                    return;

                // GET_LANGUAGE: Get the language
                case "get_language":
                    output.Append(Function.language);
                    return;

                // GET_INITAL_SILENCE: Get the end silence finished timeout
                case "get_inital_silence":
                    output.Append(Function.inital_silence.ToString(Function.nfi));
                    return;

                // GET_END_SILENCE_FINISHED: Get the end silence finished timeout
                case "get_end_silence_finished":
                    output.Append(Function.end_silence_finished.ToString(Function.nfi));
                    return;

                // GET_END_SILENCE: Get the end silence timeout
                case "get_end_silence":
                    output.Append(Function.end_silence.ToString(Function.nfi));
                    return;

                // GET_END_BABBEL: Get the end babbel timeout
                case "get_end_babbel":
                    output.Append(Function.end_babbel.ToString(Function.nfi));
                    return;

                // START_TEST: Start test voice recognition
                case "start_test":
                    // Create the testing thread
                    Function.testing_thread = new Thread(Function.Test);
                    Function.testing_thread.Start();
                    output.Append("true");
                    return;

                // END_TEST: Start test voice recognition
                case "end_test":
                    // End the testing thread
                    Function.TestEnd();
                    if (Function.testing_thread != null)
                        Function.testing_thread.Abort();
                    output.Append("true");
                    return;

                // PTT_DOWN: Enable voice input
                case "ptt_down":
                    // Create the PTT thread
                    Function.PttDown();
                    output.Append("true");
                    return;

                // PTT_UP: Enable voice input
                case "ptt_up":
                    // End the PTT thread
                    Function.PttUp();
                    output.Append("true");
                    return;

                // MISSION_START: Creates the speech engine, but does not enable the input device
                case "mission_start":
                    // Only create one engine
                    if (Function.main_thread != null)
                    {
                        output.Append("false");
                        return;
                    };

                    // Create the main thread
                    Function.main_thread = new Thread(Function.MissionStart);
                    Function.main_thread.Start();
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
                    catch (FileNotFoundException fnfe)
                    {
                        Log.Error($"File '{training_file}' could not be found.", fnfe);
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
                        if (windows_version == "10")
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

            SentrySdk.AddBreadcrumb(function.ToLower(), "Function Call (Array)", "debug", null, BreadcrumbLevel.Debug);

            args[0] = args[0].Replace("\"", "");
            switch (function.ToLower())
            {
                // SET_CONFIDENCE: Set the confidence value that needs to be passed for a 
                case "set_confidence":
                    double value = double.Parse(args[0].Replace(",", "."), Function.nfi);
                    if (Function.confidence != value)
                    {
                        Log.Info($"Changing confidence value from {Function.confidence} to {value}...");
                        Function.confidence = value;
                    }
                    output.Append(Function.confidence.ToString(Function.nfi));
                    return 1;

                // SET_LANGUAGE: Set the language file to be used in the speech recognition grammar
                case "set_language":
                    if (Function.language != args[0])
                    {
                        Log.Info($"Changing language from {Function.language} to {args[0]}...");
                        Function.language = args[0];
                    }
                    output.Append(Function.language);
                    return 1;

                // SET_INITAL_SILENCE: Set the inital silence timeout
                case "set_inital_silence":
                    try
                    {
                        double _value = double.Parse(args[0].Replace(",", "."), Function.nfi);
                        if (Function.inital_silence != _value)
                        {
                            Log.Info($"Changing inital_silence timeout from {Function.inital_silence} to {_value}...");
                            Function.inital_silence = _value;
                            if (Function.speech_engine != null)
                                Function.speech_engine.InitialSilenceTimeout = TimeSpan.FromSeconds(Function.inital_silence);
                        }
                        output.Append(Function.inital_silence.ToString(Function.nfi));
                        return 1;
                    }
                    catch (ArgumentOutOfRangeException)
                    {
                        // Reset the number to the default value
                        Function.inital_silence = 0.15;
                        if (Function.speech_engine != null)
                            Function.speech_engine.InitialSilenceTimeout = TimeSpan.FromSeconds(0.15);

                        return -1;
                    }
                    

                // SET_END_SILENCE_FINISHED: Set the inital silence timeout
                case "set_end_silence_finished":
                    try
                    {
                        double __value = double.Parse(args[0].Replace(",", "."), Function.nfi);
                        if (Function.end_silence_finished != __value)
                        {
                            Log.Info($"Changing end silence finished timeout from {Function.end_silence_finished} to {__value}...");
                            Function.end_silence_finished = __value;
                            if (Function.speech_engine != null)
                                Function.speech_engine.EndSilenceTimeout = TimeSpan.FromSeconds(Function.end_silence_finished);
                        }
                        output.Append(Function.end_silence_finished.ToString(Function.nfi));
                        return 1;
                    }
                    catch (ArgumentOutOfRangeException)
                    {
                        // Reset the number to the default value
                        Function.end_silence_finished = 0.5;
                        if (Function.speech_engine != null)
                            Function.speech_engine.EndSilenceTimeout = TimeSpan.FromSeconds(0.5);

                        return -1;
                    }
                    

                // SET_END_SILENCE: Set the end silence timeout
                case "set_end_silence":
                    try
                    {
                        double ___value = double.Parse(args[0].Replace(",", "."), Function.nfi);
                        if (Function.end_silence != ___value)
                        {
                            Log.Info($"Changing end silence timeout from {Function.end_silence} to {___value}...");
                            Function.end_silence = ___value;
                            if (Function.speech_engine != null)
                                Function.speech_engine.EndSilenceTimeoutAmbiguous = TimeSpan.FromSeconds(Function.end_silence);
                        }
                        output.Append(Function.end_silence.ToString(Function.nfi));
                        return 1;
                    }
                    catch (ArgumentOutOfRangeException)
                    {
                        // Reset the number to the default value
                        Function.end_silence = 0.15;
                        if (Function.speech_engine != null)
                            Function.speech_engine.EndSilenceTimeoutAmbiguous = TimeSpan.FromSeconds(0.15);

                        return -1;
                    }
                    

                // SET_END_BABBEL: Set the end babbel timeout
                case "set_end_babbel":
                    try
                    {
                        double ____value = double.Parse(args[0].Replace(",", "."), Function.nfi);
                        if (Function.end_babbel != ____value)
                        {
                            Log.Info($"Changing end babbel timeout from {Function.end_babbel} to {____value}...");
                            Function.end_babbel = ____value;
                            if (Function.speech_engine != null)
                                Function.speech_engine.BabbleTimeout = TimeSpan.FromSeconds(Function.end_babbel);
                        }
                        output.Append(Function.end_babbel.ToString(Function.nfi));
                        return 1;
                    }
                    catch (ArgumentOutOfRangeException)
                    {
                        // Reset the number to the default value
                        Function.end_babbel = 0.0;
                        if (Function.speech_engine != null)
                            Function.speech_engine.BabbleTimeout = TimeSpan.FromSeconds(0.0);

                        return -1;
                    }
                    

                // CONVERT_NUMBER_READABLE: Convert a number from text to digets
                case "convert_number_readable":
                    output.Append(Function.ReadableNumbers(args[0]));
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

                    output.Append(args[0].All(char.IsDigit).ToString(Function.nfi));
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

    internal class Function
    {
        internal static double opacity = 0.5;
        internal static double confidence = 0.8;
        internal static double inital_silence = 5.0;
        internal static double end_silence_finished = 0.5;
        internal static double end_silence = 0.15;
        internal static double end_babbel = 0.0;

        internal static string language = "english";
        internal static string culture = "en";
        internal static NumberFormatInfo nfi = new NumberFormatInfo();

        internal static bool ptt = false;
        internal static bool speech = false;
        internal static bool mission_start_complete = false;

        internal static SpeechRecognitionEngine speech_testing;
        internal static SpeechRecognitionEngine speech_engine;

        internal static Thread testing_thread;
        internal static Thread main_thread;

        internal static Dictionary<string, long> numbers_dictionary = new Dictionary<string, long>
        {
            {"zero",0},{"one",1},{"two",2},{"three",3},{"four",4},{"five",5},{"six",6},{"seven",7},{"eight",8},{"nine",9},{"ten",10},
            {"eleven",11},{"twelve",12},{"thirteen",13},{"fourteen",14},{"fifteen",15},{"sixteen",16},{"seventeen",17},{"eighteen",18},
            {"nineteen",19},{"twenty",20},{"thirty",30},{"forty",40},{"fifty",50},{"sixty",60},{"seventy",70},{"eighty",80},{"ninety",90},
            {"hundred",100},{"thousand",1000}
        };

        internal static string Info()
        {
            return $"Integrated AI Voice Control System - v{Assembly.GetExecutingAssembly().GetName().Version}";
        }
        
        internal static async void VersionCheck()
        {
            try
            {
                ServicePointManager.Expect100Continue = true;
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                using (HttpClient client = new HttpClient(new HttpClientHandler {UseDefaultCredentials = true}))
                {
                    string output = await client.GetStringAsync("http://raw.githubusercontent.com/Asaayu/integrated-voice-control-system/main/version_check.txt");

                    // Check if a new version is avaliable
                    if (!output.Contains(Assembly.GetExecutingAssembly().GetName().Version.ToString()))
                    {
                        MessageBox.Show($"A new version of the mod is avaliable to download.\nClick on the three dots under the mod in your Arma 3 launcher then click 'Repair' to update the mod.", "Mod Update Avaliable", MessageBoxButtons.OK);
                        SentrySdk.AddBreadcrumb("User informed new version avaliable", "Update Popup", "info", null, BreadcrumbLevel.Info);
                    }
                }
            }
            catch (Exception e)
            {
                SentrySdk.AddBreadcrumb("Version Check Error", "Version Check Error", "error", null, BreadcrumbLevel.Error);
                SentrySdk.CaptureException(e);
            };
        }

        internal static void MissionStart()
        {
            Log.Info("Game started, starting main speech engine.");

            try
            {
                // Setup the culture required
                Thread.CurrentThread.CurrentCulture = new CultureInfo(culture);
                Thread.CurrentThread.CurrentUICulture = new CultureInfo(culture);

                // Setup the decial character                
                nfi.NumberDecimalSeparator = ".";
                nfi.NumberGroupSeparator = "";

                // Get the grammer for the test
                Grammar grammar = GetGrammar();

                // Make sure it exists
                if (grammar != null)
                {
                    try
                    {
                        // Create the speech recognition engine
                        speech_engine = new SpeechRecognitionEngine(new CultureInfo("en-US"));

                        try
                        {
                            if (!speech_engine.Grammars.Contains(grammar))
                            {
                                // Load the custom grammer into the engine
                                speech_engine.LoadGrammar(grammar);
                            }

                            // Add a handler for the speech recognized event.  
                            speech_engine.SpeechRecognized += new EventHandler<SpeechRecognizedEventArgs>(SpeechRecognized);
                            speech_engine.SpeechHypothesized += new EventHandler<SpeechHypothesizedEventArgs>(SpeechHypothesized);
                            speech_engine.SpeechRecognitionRejected += new EventHandler<SpeechRecognitionRejectedEventArgs>(SpeechRecognitionRejected);
                            speech_engine.SpeechDetected += new EventHandler<SpeechDetectedEventArgs>(SpeechDetected);
                            speech_engine.RecognizeCompleted += new EventHandler<RecognizeCompletedEventArgs>(RecognizeCompleted);

                            speech_engine.InitialSilenceTimeout = TimeSpan.FromSeconds(inital_silence);
                            speech_engine.EndSilenceTimeoutAmbiguous = TimeSpan.FromSeconds(end_silence);
                            speech_engine.EndSilenceTimeout = TimeSpan.FromSeconds(end_silence_finished);
                            speech_engine.BabbleTimeout = TimeSpan.FromSeconds(end_babbel);

                            try
                            {
                                // Configure input to the speech recognizer.
                                speech_engine.SetInputToDefaultAudioDevice();
                            }
                            catch (InvalidOperationException ioe)
                            {
                                Log.Error("The mod can't connect to your microphone, make sure it's set as the default input device in your sound settings and try again.", ioe);
                            }                            

                            Log.Info("Main speech recognition engine is now running...");
                        }
                        catch (InvalidOperationException ioe)
                        {
                            MessageBox.Show($"The grammer file appears to be broken, repair the mod through the Arma 3 Launcher to fix this issue.\nMake sure you've installed and set your operating systems speech language to \"English (United States)\".\nIf it continues to happen please report it to a developer.", "Incorrect Grammer Language", MessageBoxButtons.OK);
                            SentrySdk.CaptureException(ioe);
                        }
                    }
                    catch (ArgumentException ae)
                    {
                        // This user does not have the correct culture installed
                        MessageBox.Show($"Your operating system does not have the required language installed.\nGo in to your operating system's language settings and install \"English (United States)\", then change your operating systems speech language to \"English (United States)\".\n\nThis mod will not work until the required language is installed and the game is restarted.", "Missing Required Language", MessageBoxButtons.OK);
                        SentrySdk.CaptureException(ae);
                    }
                }
                else
                {
                    Log.Error("Grammer returned null in main call...", new Exception("Could not find main grammer file"));
                }
            }
            catch (CultureNotFoundException cnfe)
            {
                // This user does not have the correct culture installed
                MessageBox.Show($"Your operating system does not have the required language installed.\nGo in to your operating system's language settings and install \"English (United States)\", then change your operating systems speech language to \"English (United States)\".\n\nThis mod will not work until the required language is installed and the game is restarted.", "Missing Required Language", MessageBoxButtons.OK);
                SentrySdk.CaptureException(cnfe);
            }
            catch (ThreadAbortException)
            {
                Log.Info("Mission start main thread aborted...");
            }
            catch (Exception e)
            {
                Log.Info("Encountered error with speech recognition engine call...");
                Log.Error("Encountered error with speech recognition engine call...", e);
            };

            // Set that the thread has reached it's end
            mission_start_complete = true;
        }

        internal static string ReloadGrammar()
        {
            if (!mission_start_complete)
            {
                Log.Info("Attempted to reload grammer before the mission start thread could run!");
                SentrySdk.AddBreadcrumb("Attempted to reload grammer before the mission start thread could run", "Log Message", "error", null, BreadcrumbLevel.Error);
                return "false";
            }
            else
            {
                if (speech_engine != null)
                {
                    // Unload all old grammars
                    speech_engine.UnloadAllGrammars();

                    // Get the grammar
                    Grammar grammar = GetGrammar();

                    if (!grammar.Equals(null))
                    {
                        try
                        {
                            if (!speech_engine.Grammars.Contains(grammar))
                            {
                                // Load the custom grammer into the engine
                                speech_engine.LoadGrammar(grammar);
                            }
                        }
                        catch (InvalidOperationException ioe)
                        {
                            MessageBox.Show($"The grammer file appears to be broken, repair the mod through the Arma 3 Launcher to fix this issue.\nMake sure you've installed and set your operating systems speech language to \"English (United States)\".\nIf it continues to happen please report it to a developer.", "Incorrect Grammer Language", MessageBoxButtons.OK);
                            SentrySdk.CaptureException(ioe);
                            return "false";
                        }
                    }
                    else
                    {
                        Log.Error("Cannot reload grammar as none was found!", new Exception("Could not find main grammer file when attempting to reload the grammer"));
                        return "false";
                    }
                }
                else
                {
                    SentrySdk.AddBreadcrumb("Speech engine not found when attempting to reload grammar! Attempting to restart mission thread!", "Log Message", "error", null, BreadcrumbLevel.Error);

                    if (main_thread != null)
                    {
                        // Abort the old thread first
                        main_thread.Abort();
                    }

                    // Start a new thread
                    main_thread = new Thread(MissionStart);
                    main_thread.Start();


                    return "true";
                }
                return "true";
            }
        }

        internal static void PttDown()
        {
            Log.Info("PTT key pressed, enabling speech recognition...");

            if (!ptt && speech_engine != null)
            {
                ptt = true;
                speech = false;

                try
                {
                    // Sometimes it dosen't load any grammars?
                    if (speech_engine.Grammars.Count <= 0)
                    {
                        ReloadGrammar();
                    }

                    // Try to set the default audio device
                    speech_engine.SetInputToDefaultAudioDevice();

                    // Start asynchronous, continuous speech recognition. 
                    speech_engine.RecognizeAsync(RecognizeMode.Multiple);
                }
                catch (InvalidOperationException ioe)
                {
                    Log.Error("The mod can't connect to your microphone, make sure it's enabled and set as the default input device in your sound settings before trying again.", ioe);
                }
                catch (Exception e)
                {
                    Log.Error("Something went wrong when trying to activate the speech engine.", e);
                }

                for (int i = 0; i <= 4; i++)
                {
                    Master.callback.Invoke("IVCS", "ctrlshow", $"['ivcs_ptt_display', {500 + i}, true]");
                }
            }
            else
            {
                Log.Info("PTT key is already down and cannot call down function again...");
            }
        }

        internal static void PttUp()
        {
            if (ptt && speech_engine != null)
            {
                ptt = false;
                Log.Info("PTT key released, disabling speech recognition...");

                try
                {
                    // Stop speech recognition.  
                    speech_engine.RecognizeAsyncStop();
                }
                catch (Exception e)
                {
                    Log.Error("An error occurred when attempting to disable the speech engine", e);
                }

                for (int i = 0; i <= 4; i++)
                {
                    Master.callback.Invoke("IVCS", "ctrlshow", $"['ivcs_ptt_display', {500 + i}, false]");
                }
            }
            else
            {
                Log.Info("PTT key is already up and cannot call up function again...");
            }
        }

        static void SpeechDetected(object sender, SpeechDetectedEventArgs e)
        {
            speech = true;

            // Reset the background to black
            for (int i = 0; i <= 1; i++)
            {
                Master.callback.Invoke("IVCS", "ctrlsettextcolor", $"['ivcs_ptt_display', {100 + i}, [0,0,0,{opacity.ToString(Function.nfi).Replace(",",".")}]]");
            }

            // Fade display in
            Master.callback.Invoke("IVCS", "fadedisplay", $"['ivcs_ptt_display', 0.2, 0]");
        }

        static void SpeechHypothesized(object sender, SpeechHypothesizedEventArgs e)
        {
            // Set the text in the display box
            Master.callback.Invoke("IVCS", "ctrlsettext_readable", $"['ivcs_ptt_display', 1000, '{e.Result.Text.Replace(",","")}']");
            Master.callback.Invoke("IVCS", "ctrlsettext", $"['ivcs_ptt_display', 1001, '{Math.Round(e.Result.Confidence, 2) * 100}% confident']");
        }

        static void SpeechRecognitionRejected(object sender, SpeechRecognitionRejectedEventArgs e)
        {
            // Set the background red to notify the user the phrase is not valid
            for (int i = 0; i <= 1; i++)
            {
                Master.callback.Invoke("IVCS", "ctrlsettextcolor", $"['ivcs_ptt_display', {100 + i}, [0.8,0.063,0.063,{opacity.ToString(Function.nfi).Replace(",", ".")}]]");
            }
        }

        static void SpeechRecognized(object sender, SpeechRecognizedEventArgs e)
        {
            // Log the input text
            Log.Input($"Reconginsed text: '{e.Result.Text}' - Confidence: {Math.Round(e.Result.Confidence, 2) * 100}%");
            Log.Input($"Semantics: '{e.Result.Semantics.Value}'");
            Log.Input($"Culture: '{speech_engine.RecognizerInfo.Culture}'");

            foreach (KeyValuePair<string,SemanticValue> value in e.Result.Semantics)
            {
                Log.Input($"Semantic: '{value.Key}':'{value.Value}'");
            }

            Log.Input($"Semantics: '{e.Result.Semantics.Value}'");

            Master.callback.Invoke("IVCS", "ctrlsettext_readable", $"['ivcs_ptt_display', 1000, '{e.Result.Text.Replace(",", "")}']");

            // Make sure the confidence value is above the user defined value
            if (e.Result.Confidence >= confidence)
            {
                if (e.Result.Text.Contains("every1"))
                {
                    Log.Error("Text contained 'every1' in text. Error occurred", new Exception("Text contained 'every1'"));

                    // Set the background red to notify the user the phrase is not valid
                    for (int i = 0; i <= 1; i++)
                    {
                        Master.callback.Invoke("IVCS", "ctrlsettextcolor", $"['ivcs_ptt_display', {100 + i}, [0.8,0.063,0.063,{opacity.ToString(Function.nfi).Replace(",", ".")}]]");
                    }
                    return;
                }
                // Set the background green to notify the user the phrase is valid and confidence was high enough
                for (int i = 0; i <= 1; i++)
                {
                    Master.callback.Invoke("IVCS", "ctrlsettextcolor", $"['ivcs_ptt_display', {100 + i}, [0.13,0.54,0.21,{opacity.ToString(Function.nfi).Replace(",", ".")}]]");
                }

                //string data = ConvertSemantic((string)e.Result.Semantics.Value, e.Result.Text);
                string data = ConvertSemantic((string)e.Result.Semantics.Value, ReadableNumbers(e.Result.Text, true));
                Log.Debug(data);

                Master.callback.Invoke("IVCS", "call_function", data);
            }
            else
            {
                // Set the background orange to notify the user that the phrase is valid, but confidence was not high enough.
                for (int i = 0; i <= 1; i++)
                {
                    Master.callback.Invoke("IVCS", "ctrlsettextcolor", $"['ivcs_ptt_display', {100 + i}, [0.988,0.518,0.012,{opacity.ToString(Function.nfi).Replace(",", ".")}]]");
                }
            }
        }
        
        static void RecognizeCompleted(object sender, RecognizeCompletedEventArgs e)
        {
            if (speech)
            {
                // Sleep for 1 second
                Thread.Sleep(1_000);

                // Fade display
                Master.callback.Invoke("IVCS", "fadedisplay", $"['ivcs_ptt_display', 0.2, 1]");
            }
        }

        internal static string ConvertSemantic(string semantic, string text)
        {
            Log.Info($"Converting semantic '{semantic}' with '{text}'.");

            try
            {
                string command = "";
                string key = "";

                string[] data = semantic.Split(':');
                foreach (string t in data)
                {
                    if (t.Contains("["))
                    {
                        // Get the command id from the square brackets
                        command = t.Split('[', ']')[1];
                        key = t.Split('[')[0];
                        break;
                    }
                }

                switch (data.Length)
                {
                    case 1:
                        {
                            string[] data_list = text.Split(new string[] { key }, StringSplitOptions.RemoveEmptyEntries);

                            // This is probably a call to all units
                            if (data_list.Length <= 0)
                            {
                                return $"[['All'], '{command}']";
                            }
                            else
                            {
                                string left_data = string.Join("','", data_list[0].Replace(", ", ",").Replace(" ", ",").Split(',').Where(x => !string.IsNullOrEmpty(x)).ToArray());
                                return $"[['{left_data}'], '{command}', []]".Replace(",''", "");
                            };
                        };
                    case 2:
                        {
                            string[] data_list = text.Split(new string[] { key }, StringSplitOptions.RemoveEmptyEntries);
                            string left_data;
                            string right_data;

                            // Probably a call to all units
                            if (data_list.Length == 1)
                            {
                                left_data = "All";
                                right_data = string.Join("','", data_list[0].Replace(", ", ",").Replace(" ", ",").Split(',').Where(x => !string.IsNullOrEmpty(x)).ToArray());
                            }
                            else
                            {
                                left_data = string.Join("','", data_list[0].Replace(", ", ",").Replace(" ", ",").Split(',').Where(x => !string.IsNullOrEmpty(x)).ToArray());
                                right_data = string.Join("','", data_list[1].Replace(", ", ",").Replace(" ", ",").Split(',').Where(x => !string.IsNullOrEmpty(x)).ToArray());
                            };
                            return $"[['{left_data}'], '{command}', ['{right_data}']]".Replace(",''", "");
                        };
                }                
            }
            catch (Exception e)
            {
                Log.Info($"Exception encountered while attempting to convert semantics...");
                Log.Error($"Exception encountered while attempting to convert semantics...", e);
            }
            return "[[], '', []]";
        }

        internal static void Test()
        {
            Log.Info("Starting speech recognition engine test...");

            try
            {
                // Create the speech recognition engine
                speech_testing = new SpeechRecognitionEngine(new CultureInfo(culture));

                // Get the grammer for the test
                Grammar grammar = GetGrammar("testing");

                // Make sure it exists
                if (grammar != null)
                {
                    try
                    {

                        if (!speech_testing.Grammars.Contains(grammar))
                        {
                            // Load the custom grammer into the engine
                            speech_testing.LoadGrammar(grammar);
                        }

                        // Add a handler for the speech recognized event.  
                        speech_testing.SpeechRecognized += new EventHandler<SpeechRecognizedEventArgs>(Testing_SpeechRecognized);
                        speech_testing.SpeechHypothesized += new EventHandler<SpeechHypothesizedEventArgs>(Testing_SpeechHypothesized);
                        speech_testing.SpeechRecognitionRejected += new EventHandler<SpeechRecognitionRejectedEventArgs>(Testing_SpeechRecognitionRejected);

                        // Configure input to the speech recognizer.
                        speech_testing.SetInputToDefaultAudioDevice();

                        speech_testing.InitialSilenceTimeout = TimeSpan.FromSeconds(inital_silence);
                        speech_testing.EndSilenceTimeoutAmbiguous = TimeSpan.FromSeconds(end_silence);
                        speech_testing.EndSilenceTimeout = TimeSpan.FromSeconds(end_silence_finished);
                        speech_testing.BabbleTimeout = TimeSpan.FromSeconds(end_babbel);

                        try
                        {
                            // Start asynchronous, continuous speech recognition.  
                            speech_testing.RecognizeAsync(RecognizeMode.Multiple);
                        }
                        catch (InvalidOperationException ioe)
                        {
                            Log.Error("The mod can't connect to your microphone, make sure it's set as the default input device in your sound settings and try again.", ioe);
                        }                        

                        Log.Info($"Initial Silence: {speech_testing.InitialSilenceTimeout.TotalSeconds}");
                        Log.Info($"End Silence Timeout: {speech_testing.EndSilenceTimeout.TotalSeconds}");
                        Log.Info($"End Silence Timeout Ambiguous: {speech_testing.EndSilenceTimeoutAmbiguous.TotalSeconds}");
                        Log.Info($"Babble Timeout: {speech_testing.BabbleTimeout.TotalSeconds}");

                        Log.Info("Speech recognition engine test is now running...");
                    }
                    catch (InvalidOperationException ioe)
                    {
                        // This user does not have the correct culture installed
                        MessageBox.Show($"The grammer file appears to be broken, repair the mod through the Arma 3 Launcher to fix this issue.\nMake sure you've installed and set your operating systems speech language to \"English (United States)\".\nIf it continues to happen please report it to a developer.", "Incorrect Grammer Language", MessageBoxButtons.OK);
                        SentrySdk.CaptureException(ioe);
                        return;
                    }
                }
                else
                {
                    Log.Error("Grammer returned null in speech recognition engine test...", new Exception("Could not find testing grammer file"));
                };
            }
            catch (ArgumentException ae)
            {
                // This user does not have the correct culture installed
                MessageBox.Show($"Your operating system does not have the required language installed.\nGo in to your operating system's language settings and install \"English (United States)\", then change your operating systems speech language to \"English (United States)\".\n\nThis mod will not work until the required language is installed and the game is restarted.", "Missing Required Language", MessageBoxButtons.OK);
                SentrySdk.CaptureException(ae);
            }
            catch (NullReferenceException ae)
            {
                // This user does not have the correct culture installed
                MessageBox.Show($"Your operating system does not have the required language installed.\nGo in to your operating system's language settings and install \"English (United States)\", then change your operating systems speech language to \"English (United States)\".\n\nThis mod will not work until the required language is installed and the game is restarted.", "Missing Required Language", MessageBoxButtons.OK);
                SentrySdk.CaptureException(ae);
            }
            catch (ThreadAbortException)
            {
                Log.Info("Testing thread aborted...");
            }
            catch (Exception e)
            {
                Log.Info("Encountered error with speech recognition engine testing...");
                Log.Error("Encountered error with speech recognition engine testing...", e);
            };
        }

        internal static void TestEnd()
        {
            try
            {
                if (speech_testing != null)
                {
                    // Stop the engine from listening
                    speech_testing.RecognizeAsyncCancel();

                    // Dispose the testing speech
                    speech_testing.Dispose();
                }

                Log.Info("Speech recognition engine test has finished running...");
            }
            catch (Exception e)
            {
                Log.Info("Encountered error when attempting to stop the speech test...");
                Log.Error("Encountered error when attempting to stop the speech test...", e);
            }            
        }

        static void Testing_SpeechHypothesized(object sender, SpeechHypothesizedEventArgs e)
        {
            // Set the text in the display box
            Master.callback.Invoke("IVCS", "ctrlsettext", $"['ivcs_test_display', 5000, '<t font=\"RobotoCondensed\">{e.Result.Text}</t> - Confidence: {Math.Round(e.Result.Confidence, 2)*100}%']");
        }
        
        static void Testing_SpeechRecognitionRejected(object sender, SpeechRecognitionRejectedEventArgs e)
        {
            // Reset the text in the display box on rejection
            Master.callback.Invoke("IVCS", "ctrlsettext", $"['ivcs_test_display', 5000, '']");
        }

        static void Testing_SpeechRecognized(object sender, SpeechRecognizedEventArgs e)
        {
            // Log the input text
            Log.Input($"Reconginsed text: '{e.Result.Text}' - Confidence: {Math.Round(e.Result.Confidence, 2) * 100}%");

            // Make sure the confidence value is above the user defined value
            if (e.Result.Confidence >= confidence)
            {
                // Split the data to get the index of the text in the grammar xml file
                string[] data = ((string)e.Result.Semantics.Value).Split(':');

                // Set the text color for the specific ctrl based on the users input
                Master.callback.Invoke("IVCS", "ctrlsettextcolor", $"['ivcs_test_display', {int.Parse(data[1], nfi) + 1000}, [0,1,0,1]]");
            }
        }

        internal static Grammar GetGrammar(string filename = "")
        {
            string location = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            string grammar_file = location + $@"\grammar\grammar_{language}.xml";

            try
            {
                Log.Info("Loading grammer file");

                if (filename != "")
                    grammar_file = location + $@"\grammar\{filename}.xml";

                Log.Debug($"Grammer file: {grammar_file}");

                if (!File.Exists(grammar_file))
                    throw new FileNotFoundException();

                Grammar grammar = new Grammar(grammar_file);
                return grammar;
            }
            catch (FileNotFoundException fnfe)
            {
                Log.Error("Grammer file not found!", fnfe);
                return null;
            }
            catch (Exception e)
            {
                Log.Error("Encountered errror getting grammar file!", e);
                return null;
            };
        }

        internal static string ReadableNumbers(string old_text, bool add_comma = false)
        {
            string input = old_text.Replace(",", "");
            string[] words = input.Split(' ');

            int start_str = input.Length - 1;
            int end_str = 0;
            foreach (string word in words)
            {
                string _word = word.ToLowerInvariant().Replace(",", "").Replace(" ", "");

                if (numbers_dictionary.ContainsKey(_word))
                {
                    int first_index = input.IndexOf(_word);
                    int last_index = input.LastIndexOf(_word) + _word.Length;

                    if (first_index < start_str)
                    {
                        start_str = first_index;
                        Log.Info($"Setting start index:{start_str}");
                    }

                    if (last_index > end_str)
                    {
                        end_str = last_index;
                        Log.Info($"Setting end index:{end_str}");
                    }
                }
            }

            if (input.Contains("point") && !input.EndsWith("point"))
            {
                int index_point = input.IndexOf("point");
                string points_l = input.Substring(0, index_point);
                string points_r = input.Substring(index_point + 5, input.Length - (index_point + 5));


                // This word -> number converter is from https://www.c-sharpcorner.com/blogs/convert-words-to-numbers-in-c-sharp
                // Original author: Amit Mohanty
                var numbers_left = Regex.Matches(points_l, @"\w+").Cast<Match>().Select(m => m.Value.ToLowerInvariant()).Where(v => numbers_dictionary.ContainsKey(v)).Select(v => numbers_dictionary[v]);
                var numbers_right = Regex.Matches(points_r, @"\w+").Cast<Match>().Select(m => m.Value.ToLowerInvariant()).Where(v => numbers_dictionary.ContainsKey(v)).Select(v => numbers_dictionary[v]);

                long acc_l = 0, total_l = 0L;
                foreach (var n in numbers_left)
                {
                    if (n >= 1000)
                    {
                        total_l += acc_l * n;
                        acc_l = 0;
                    }
                    else if (n >= 100)
                    {
                        acc_l *= n;
                    }
                    else acc_l += n;
                }

                long acc_r = 0, total_r = 0L;
                foreach (var n in numbers_right)
                {
                    if (n >= 1000)
                    {
                        total_r += acc_r * n;
                        acc_r = 0;
                    }
                    else if (n >= 100)
                    {
                        acc_r *= n;
                    }
                    else acc_r += n;
                }

                // Return input if no numbers found
                if (total_l + acc_l <= 0)
                    return input;

                if (add_comma)
                    return input.Substring(0, start_str) + (total_l + acc_l).ToString(Function.nfi) + "." + (total_r + acc_r).ToString(Function.nfi) + "," + input.Substring(end_str, input.Length - end_str);

                return input.Substring(0, start_str) + (total_l + acc_l).ToString(Function.nfi) + "." + (total_r + acc_r).ToString(Function.nfi) + input.Substring(end_str, input.Length - end_str);
            }
            else
            {
                // This word -> number converter is from https://www.c-sharpcorner.com/blogs/convert-words-to-numbers-in-c-sharp
                // Original author: Amit Mohanty
                var numbers_left = Regex.Matches(input, @"\w+").Cast<Match>().Select(m => m.Value.ToLowerInvariant()).Where(v => numbers_dictionary.ContainsKey(v)).Select(v => numbers_dictionary[v]);
                long acc = 0, total = 0L;
                foreach (var n in numbers_left)
                {
                    if (n >= 1000)
                    {
                        total += acc * n;
                        acc = 0;
                    }
                    else if (n >= 100)
                    {
                        acc *= n;
                    }
                    else acc += n;
                }

                // Return input if no numbers found
                if (total + acc <= 0)
                    return input;

                if (add_comma)
                    return input.Substring(0, start_str) + (total + acc).ToString(Function.nfi) + "," + input.Substring(end_str, input.Length - end_str);

                return input.Substring(0, start_str) + (total + acc).ToString(Function.nfi) + input.Substring(end_str, input.Length - end_str);
            }
        }
    }

    internal class Log
    {
        internal static bool debug;

        internal static void Setup()
        {
            // Check for debug parameter
            debug = Environment.CommandLine.Contains("-ivcs_debug");

            if (debug)
                AllocConsole();
        }

        [DllImport("kernel32")]
        static extern bool AllocConsole();

        internal static bool Info(string message, string prefix = "INFO")
        {
            try
            {
                if (prefix != "INPUT")
                    SentrySdk.AddBreadcrumb(message, "Log Message", prefix.ToLower(), null, BreadcrumbLevel.Info);

                string message_text = DateTime.Now.ToString("[dd/MM/yyyy hh:mm:ss tt]") + "[" + prefix + "] " + message;
                if (debug)
                    Console.WriteLine(message_text);

                return true;
            }
            catch
            {
                return false;
            }
        }

        internal static bool Error(string message, Exception e)
        {
            bool response = Info(message, "ERROR");
            SentrySdk.CaptureException(e);

            MessageBox.Show($"An error has occurred.\n\n\n{e.Message}\n{e.StackTrace}\n\n\nThis mod may not work correctly after this error, if it happens frequently try repairing your mod through the Arma 3 launcher.\nIf it still occurs please inform a developer.", "An error has occurred!", MessageBoxButtons.OK);
            return response;
        }

        internal static bool Debug(string message)
        {
            return Info(message, "DEBUG");
        }

        internal static bool Input(string message)
        {
            return Info(message, "INPUT");
        }
    }
}