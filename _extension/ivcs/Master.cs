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

            Log.Setup();
            Log.Info("Logging system setup complete...");

            output.Append("IVCS");
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
                    if (Function.speech_engine != null)
                    {
                        // Unload all old grammars
                        Function.speech_engine.UnloadAllGrammars();

                        // Get the grammar
                        Grammar grammar = Function.GetGrammar();

                        if (grammar != null)
                        {
                            // Reload the new grammar
                            Function.speech_engine.LoadGrammar(grammar);
                        }
                        else
                        {
                            Log.Error("Cannot reload grammar as none was found!");
                        }
                    }
                    else
                    {
                        Log.Info("Speech engine not found when attempting to reload grammar!");
                    }
                    output.Append("true");
                    return;

                // GET_CONFIDENCE: Get the language
                case "get_confidence":
                    output.Append(Function.confidence.ToString());
                    return;

                // GET_CULTURE: Get the culture
                case "get_culture":
                    output.Append(Function.culture);
                    return;

                // GET_LANGUAGE: Get the language
                case "get_language":
                    output.Append(Function.language);
                    return;

                // GET_INITAL_SILENCE: Get the end silence finished timeout
                case "get_inital_silence":
                    output.Append(Function.inital_silence.ToString());
                    return;

                // GET_END_SILENCE_FINISHED: Get the end silence finished timeout
                case "get_end_silence_finished":
                    output.Append(Function.end_silence_finished.ToString());
                    return;

                // GET_END_SILENCE: Get the end silence timeout
                case "get_end_silence":
                    output.Append(Function.end_silence.ToString());
                    return;

                // GET_END_BABBEL: Get the end babbel timeout
                case "get_end_babbel":
                    output.Append(Function.end_babbel.ToString());
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
                    System.Diagnostics.Process.Start($"{Environment.SystemDirectory}" + @"\Speech\SpeechUX\SpeechUXWiz.exe", "UserTraining"); 
                    output.Append("true");
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

            args[0] = args[0].Replace("\"", "");
            switch (function.ToLower())
            {
                // SET_CONFIDENCE: Set the confidence value that needs to be passed for a 
                case "set_confidence":
                    double value = double.Parse(args[0]);
                    if (Function.confidence != value)
                    {
                        Log.Info($"Changing confidence value from {Function.confidence} to {value}...");
                        Function.confidence = value;
                    }
                    output.Append(Function.confidence.ToString());
                    return 1;

                // SET_CULTURE: Set the culture to be used in the speech recognition engine
                case "set_culture":
                    if (Function.culture != args[0])
                    {
                        Log.Info($"Changing culture from {Function.culture} to {args[0]}...");
                        Function.culture = args[0];
                    }
                    output.Append(Function.culture);
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
                    double _value = double.Parse(args[0]);
                    if (Function.inital_silence != _value)
                    {
                        Log.Info($"Changing inital_silence timeout from {Function.inital_silence} to {_value}...");
                        Function.inital_silence = _value;
                        if (Function.speech_engine != null)
                            Function.speech_engine.InitialSilenceTimeout = TimeSpan.FromSeconds(Function.inital_silence);
                    }
                    output.Append(Function.inital_silence.ToString());
                    return 1;

                // SET_END_SILENCE_FINISHED: Set the inital silence timeout
                case "set_end_silence_finished":
                    double __value = double.Parse(args[0]);
                    if (Function.end_silence_finished != __value)
                    {
                        Log.Info($"Changing end silence finished timeout from {Function.end_silence_finished} to {__value}...");
                        Function.end_silence_finished = __value;
                        if (Function.speech_engine != null)
                            Function.speech_engine.EndSilenceTimeout = TimeSpan.FromSeconds(Function.end_silence_finished);
                    }
                    output.Append(Function.end_silence_finished.ToString());
                    return 1;

                // SET_END_SILENCE: Set the end silence timeout
                case "set_end_silence":
                    double ___value = double.Parse(args[0]);
                    if (Function.end_silence != ___value)
                    {
                        Log.Info($"Changing end silence timeout from {Function.end_silence} to {___value}...");
                        Function.end_silence = ___value;
                        if (Function.speech_engine != null)
                            Function.speech_engine.EndSilenceTimeoutAmbiguous = TimeSpan.FromSeconds(Function.end_silence);
                    }
                    output.Append(Function.end_silence.ToString());
                    return 1;

                // SET_END_BABBEL: Set the end babbel timeout
                case "set_end_babbel":
                    double ____value = double.Parse(args[0]);
                    if (Function.end_babbel != ____value)
                    {
                        Log.Info($"Changing end babbel timeout from {Function.end_babbel} to {____value}...");
                        Function.end_babbel = ____value;
                        if (Function.speech_engine != null)
                            Function.speech_engine.BabbleTimeout = TimeSpan.FromSeconds(Function.end_babbel);
                    }
                    output.Append(Function.end_babbel.ToString());
                    return 1;

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

                    output.Append(args[0].All(char.IsDigit).ToString());
                    return 1;
                    
                // TITLE_CASE: Convert string to title case
                case "title_case":
                    if (argCount < 1)
                        return -1;

                    output.Append(CultureInfo.CurrentCulture.TextInfo.ToTitleCase(args[0]).Replace("Team, ", "Team "));
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
        internal static string culture = "en-US";

        internal static bool ptt = false;
        internal static bool speech = false;

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
            return "Integrated AI Voice Control System - v1.0.0";
        }

        internal static void MissionStart()
        {
            Log.Info("Game started, starting main speech engine.");

            try
            {
                // Get the grammer for the test
                Grammar grammar = GetGrammar();

                // Make sure it exists
                if (grammar == null)
                {
                    Log.Error("Grammer returned null in main call...");
                    return;
                }

                // Create the speech recognition engine
                speech_engine = new SpeechRecognitionEngine(new CultureInfo(culture));

                // Load the custom grammer into the engine
                speech_engine.LoadGrammar(grammar);

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

                // Configure input to the speech recognizer.
                speech_engine.SetInputToDefaultAudioDevice();

                Log.Info("Main speech recognition engine is now running...");
            }
            catch (ArgumentException ae)
            {
                Log.Info($"Currently selected culture '{culture}' can't be found in your operating system...");
                Log.Error(ae.ToString());
            }
            catch (ThreadAbortException)
            {
                Log.Info("Mission start main thread aborted...");
            }
            catch (Exception e)
            {
                Log.Info("Encountered error with speech recognition engine call...");
                Log.Error(e.ToString());
            };
        }

        internal static void PttDown()
        {
            Log.Info("PTT key pressed, enabling speech recognition...");

            if (!ptt)
            {
                ptt = true;
                speech = false;

                try
                {
                    // Start asynchronous, continuous speech recognition. 
                    speech_engine.RecognizeAsync(RecognizeMode.Multiple);
                }
                catch (InvalidOperationException)
                {
                    speech_engine.SetInputToDefaultAudioDevice();
                    Log.Info("An invalid operation exception error occurred. Setting the engine input to the default audio device.");
                }
                catch (Exception e)
                {
                    Log.Info("An error occurred when attempting to enable the speech engine");
                    Log.Error(e.ToString());
                }


                for (int i = 0; i <= 4; i++)
                {
                    Master.callback.Invoke("IVCS", "ctrlshow", $"['ivcs_ptt_display', {500 + i}, true]");
                }
            }
            else
            {
                Log.Error("PTT key is already down and cannot call down function again...");
            }
        }

        internal static void PttUp()
        {
            if (ptt)
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
                    Log.Info("An error occurred when attempting to disable the speech engine");
                    Log.Error(e.ToString());
                }

                for (int i = 0; i <= 4; i++)
                {
                    Master.callback.Invoke("IVCS", "ctrlshow", $"['ivcs_ptt_display', {500 + i}, false]");
                }
            }
            else
            {
                Log.Error("PTT key is already up and cannot call up function again...");
            }
        }

        static void SpeechDetected(object sender, SpeechDetectedEventArgs e)
        {
            speech = true;

            // Reset the background to black
            for (int i = 0; i <= 1; i++)
            {
                Master.callback.Invoke("IVCS", "ctrlsettextcolor", $"['ivcs_ptt_display', {100 + i}, [0,0,0,{opacity}]]");
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
                Master.callback.Invoke("IVCS", "ctrlsettextcolor", $"['ivcs_ptt_display', {100 + i}, [0.8,0.063,0.063,{opacity}]]");
            }
        }

        static void SpeechRecognized(object sender, SpeechRecognizedEventArgs e)
        {
            // Log the input text
            Log.Input($"Reconginsed text: '{e.Result.Text}' - Confidence: {Math.Round(e.Result.Confidence, 2) * 100}%");
            Log.Input($"Semantics: '{e.Result.Semantics.Value}'");

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
                    Log.Error("Text contained 'every1' in text. Error occurred");

                    // Set the background red to notify the user the phrase is not valid
                    for (int i = 0; i <= 1; i++)
                    {
                        Master.callback.Invoke("IVCS", "ctrlsettextcolor", $"['ivcs_ptt_display', {100 + i}, [0.8,0.063,0.063,{opacity}]]");
                    }
                    return;
                }
                // Set the background green to notify the user the phrase is valid and confidence was high enough
                for (int i = 0; i <= 1; i++)
                {
                    Master.callback.Invoke("IVCS", "ctrlsettextcolor", $"['ivcs_ptt_display', {100 + i}, [0.13,0.54,0.21,{opacity}]]");
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
                    Master.callback.Invoke("IVCS", "ctrlsettextcolor", $"['ivcs_ptt_display', {100 + i}, [0.988,0.518,0.012,{opacity}]]");
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
                Log.Error(e.ToString());
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
                if (grammar == null)
                {
                    Log.Error("Grammer returned null in speech recognition engine test...");
                    return;
                }

                // Load the custom grammer into the engine
                speech_testing.LoadGrammar(grammar);

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

                // Start asynchronous, continuous speech recognition.  
                speech_testing.RecognizeAsync(RecognizeMode.Multiple);                

                Log.Info($"Initial Silence: {speech_testing.InitialSilenceTimeout.TotalSeconds}");
                Log.Info($"End Silence Timeout: {speech_testing.EndSilenceTimeout.TotalSeconds}");
                Log.Info($"End Silence Timeout Ambiguous: {speech_testing.EndSilenceTimeoutAmbiguous.TotalSeconds}");
                Log.Info($"Babble Timeout: {speech_testing.BabbleTimeout.TotalSeconds}");

                Log.Info("Speech recognition engine test is now running...");
            }
            catch (ArgumentException ae)
            {
                Log.Info($"Currently selected culture '{culture}' can't be found in your operating system...");
                Log.Error(ae.ToString());
            }
            catch (ThreadAbortException)
            {
                Log.Info("Testing thread aborted...");
            }
            catch (Exception e)
            {
                Log.Info("Encountered error with speech recognition engine testing...");
                Log.Error(e.ToString());
            };
        }

        internal static void TestEnd()
        {
            // Stop the engine from listening
            speech_testing.RecognizeAsyncCancel();

            // Dispose the testing speech
            speech_testing.Dispose();

            Log.Info("Speech recognition engine test has finished running...");
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
                Master.callback.Invoke("IVCS", "ctrlsettextcolor", $"['ivcs_test_display', {int.Parse(data[1]) + 1000}, [0,1,0,1]]");
            }
        }

        internal static Grammar GetGrammar(string filename = "")
        {
            string location = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
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
                Log.Info("Grammer file not found!");
                Log.Error(fnfe.ToString());
                MessageBox.Show
                (
                    $"Intergrated Voice Control System could not find the grammer file '{grammar_file}' in the mod's install directory." +
                    Environment.NewLine +
                    Environment.NewLine +
                    "Please repair the mod installation using your Arma 3 launcher, if this problem persists please report it to the developers.", "Error: Grammer file not found",
                    MessageBoxButtons.OK, MessageBoxIcon.Error
                );
                return null;
            }
            catch (Exception e)
            {
                Log.Info("Encountered errror getting grammar file!");
                Log.Error(e.ToString());
                MessageBox.Show
                (
                    
                    $"Intergrated Voice Control System encountered an errror when attempting to read grammer file '{grammar_file}'." +
                    Environment.NewLine +
                    Environment.NewLine +
                    "Please repair the mod installation using your Arma 3 launcher, if this problem persists please report it to the developers.", "Error: Grammer file exception",
                    MessageBoxButtons.OK, MessageBoxIcon.Error
                );
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
                    return input.Substring(0, start_str) + (total_l + acc_l).ToString() + "." + (total_r + acc_r).ToString() + "," + input.Substring(end_str, input.Length - end_str);

                return input.Substring(0, start_str) + (total_l + acc_l).ToString() + "." + (total_r + acc_r).ToString() + input.Substring(end_str, input.Length - end_str);
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
                    return input.Substring(0, start_str) + (total + acc).ToString() + "," + input.Substring(end_str, input.Length - end_str);

                return input.Substring(0, start_str) + (total + acc).ToString() + input.Substring(end_str, input.Length - end_str);
            }
        }
    }

    internal class Log
    {
        internal static bool debug;
        private static string log_directory;
        private static string log_file;

        internal static void Setup()
        {
            // Check for debug parameter
            debug = Environment.CommandLine.Contains("-ivcs_debug");

            if (debug)
                AllocConsole();

            // Get current directory
            string current_directory = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);

            // Save locations and files
            log_directory = current_directory + @"\logs\";
            log_file = log_directory + "ivcs_extension_" + DateTime.Now.ToString("dd-MM-yyyy_HH-mm-ss") + ".txt";

            try
            {
                // Create directories 
                Directory.CreateDirectory(log_directory);
            }
            catch (Exception e)
            {
                Info("An error has occured when attempting to create required directories...");
                Error(e.ToString());
            };
            
            try
            {
                // Delete files that haven't been accessed for more then seven days
                string[] files = Directory.GetFiles(log_directory);

                foreach (string file in files)
                {
                    FileInfo file_info = new FileInfo(file);
                    if (file_info.LastAccessTime < DateTime.Now.AddDays(-7))
                        file_info.Delete();
                }
            }
            catch (Exception e)
            {
                Info("An error has occured when attempting to delete old files...");
                Error(e.ToString());
            };
        }

        [DllImport("kernel32")]
        static extern bool AllocConsole();

        internal static bool Info(string message, string prefix = "INFO")
        {
            try
            {
                string message_text = DateTime.Now.ToString("[dd/MM/yyyy hh:mm:ss tt]") + "[" + prefix + "] " + message;

                if (debug)
                    Console.WriteLine(message_text);

                using (StreamWriter sw = File.AppendText(log_file))
                {
                    sw.WriteLine(message_text);
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        internal static bool Error(string message)
        {
            bool response = Info(message, "ERROR");
            MessageBox.Show
                (
                    "Please report this error to the developers." +
                    Environment.NewLine +
                    Environment.NewLine +
                    message +
                    Environment.NewLine +
                    Environment.NewLine +
                    "Your game may crash when you close this window.", "Error During Execution",
                    MessageBoxButtons.OK, MessageBoxIcon.Error
                );
            return response;
        }

        internal static bool Debug(string message)
        {
            if (debug)
                return Info(message, "DEBUG");

            return false;
        }

        internal static bool Input(string message)
        {
            return Info(message, "INPUT");
        }
    }
}