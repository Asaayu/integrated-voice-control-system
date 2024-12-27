using System;
using System.Activities;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using Microsoft.Win32;

namespace IntegratedVoiceControlSystem
{
    internal static class Common
    {
        internal static NumberFormatInfo numberFormatInfo;
        internal static Dictionary<string, long> numbersDictionary = new Dictionary<string, long>
        {
            {"zero",0},{"one",1},{"two",2},{"three",3},{"four",4},{"five",5},{"six",6},{"seven",7},{"eight",8},{"nine",9},{"ten",10},
            {"eleven",11},{"twelve",12},{"thirteen",13},{"fourteen",14},{"fifteen",15},{"sixteen",16},{"seventeen",17},{"eighteen",18},
            {"nineteen",19},{"twenty",20},{"thirty",30},{"forty",40},{"fifty",50},{"sixty",60},{"seventy",70},{"eighty",80},{"ninety",90},
            {"hundred",100},{"thousand",1000}
        };

        internal static void Setup()
        {
            // Setup the logging system
            Logger.Setup();

            // Setup the version manager
            VersionManager.Setup();

            // Setup the speech recognition engine
            SpeechEngineHandler.Setup();

            // Setup the number format info for internal conversions to avoid culture issues
            numberFormatInfo = new NumberFormatInfo
            {
                NumberDecimalSeparator = ".",
                NumberGroupSeparator = ""
            };
        }

        internal static void OpenExternalProgram(string externalProgram)
        {
            try
            {
                string systemDirectory = Environment.SystemDirectory;

                switch (externalProgram)
                {
                    case "speechTraining":
                        string speechTrainingPath = Path.Combine(systemDirectory, "Speech", "SpeechUX", "SpeechUXWiz.exe");
                        if (!File.Exists(speechTrainingPath))
                        {
                            throw new FileNotFoundException("Windows Speech Recognition Training could not be found on your system.");
                        }

                        Process.Start(speechTrainingPath);
                        break;

                    // OPEN_SPEECH_SETTINGS: Opens the speech language settings
                    case "speechSettings":
                        string currentWindowsVersion = Registry.GetValue(@"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentMajorVersionNumber", "").ToString();
                        if (currentWindowsVersion != "10" && currentWindowsVersion != "11")
                        {
                            throw new VersionMismatchException("This link requires Windows 10 or 11 to open.");
                        }

                        string speechSettingsUri = "ms-settings:speech";
                        Process.Start(speechSettingsUri);
                        break;

                    // OPEN_SOUND_CONTROL_PANEL_SETTINGS: Opens the sound control panel settings
                    case "soundControlPanel":
                        string soundControlPanelPath = Path.Combine(systemDirectory, "control.exe");
                        Process.Start(soundControlPanelPath, "/name Microsoft.Sound");
                        return;
                }
            }
            catch (FileNotFoundException fileNotFoundException)
            {
                Logger.Error("Windows speech recognition training could not be found", fileNotFoundException);
            }
            catch (VersionMismatchException versionMismatchException)
            {
                Logger.Error($"This link requires Windows 10 or 11 to open.", versionMismatchException);
            }
            catch (Exception exception)
            {
                Logger.Error($"An exception occurred when attempting to open Windows sound control panel.", exception);
            }
        }

        internal static string ConvertSemanticToArmaCompatible(string semantic, string text)
        {
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
                };
            }
            catch (Exception e)
            {
                Logger.Error($"Exception encountered while attempting to convert semantics...", e);
            }
            return "[[], '', []]";
        }

        internal static string ConvertNumberToHumanString(string inputNumberString, bool addComma = false)
        {
            string input = inputNumberString.Replace(",", "");
            string[] words = input.Split(' ');

            int startIndex = input.Length - 1;
            int endIndex = 0;

            foreach (string word in words)
            {
                string normalizedWord = word.ToLowerInvariant().Replace(",", "").Replace(" ", "");

                if (numbersDictionary.ContainsKey(normalizedWord))
                {
                    int firstIndex = input.IndexOf(normalizedWord);
                    int lastIndex = input.LastIndexOf(normalizedWord) + normalizedWord.Length;

                    startIndex = Math.Min(startIndex, firstIndex);
                    endIndex = Math.Max(endIndex, lastIndex);
                }
            }

            if (input.Contains("point") && !input.EndsWith("point"))
            {
                return ProcessDecimalNumber(input, startIndex, endIndex, addComma);
            }

            return ProcessWholeNumber(input, startIndex, endIndex, addComma);
        }

        private static string ProcessDecimalNumber(string input, int startIndex, int endIndex, bool addComma)
        {
            int pointIndex = input.IndexOf("point");
            string leftPart = input.Substring(0, pointIndex);
            string rightPart = input.Substring(pointIndex + 5);

            long leftValue = ConvertWordsToNumber(leftPart);
            long rightValue = ConvertWordsToNumber(rightPart);

            if (leftValue == 0 && rightValue == 0)
                return input;

            string formattedNumber = leftValue + "." + rightValue;
            if (addComma)
                formattedNumber += ",";

            return input.Substring(0, startIndex) + formattedNumber + input.Substring(endIndex);
        }

        private static string ProcessWholeNumber(string input, int startIndex, int endIndex, bool addComma)
        {
            long totalValue = ConvertWordsToNumber(input);

            if (totalValue == 0)
                return input;

            string formattedNumber = totalValue.ToString(numberFormatInfo);
            if (addComma)
                formattedNumber += ",";

            return input.Substring(0, startIndex) + formattedNumber + input.Substring(endIndex);
        }

        private static long ConvertWordsToNumber(string input)
        {
            var numbers = Regex.Matches(input, @"\w+")
                .Cast<Match>()
                .Select(m => m.Value.ToLowerInvariant())
                .Where(numbersDictionary.ContainsKey)
                .Select(v => numbersDictionary[v]);

            long accumulator = 0, total = 0;

            foreach (var number in numbers)
            {
                if (number >= 1000)
                {
                    total += accumulator * number;
                    accumulator = 0;
                }
                else if (number >= 100)
                {
                    accumulator *= number;
                }
                else
                {
                    accumulator += number;
                }
            }

            return total + accumulator;
        }
    }


    //static void Testing_SpeechHypothesized(object sender, SpeechHypothesizedEventArgs e)
    //{
    //    // Set the text in the display box
    //    Main.callback.Invoke("IVCS", "ctrlsettext", $"['ivcs_test_display', 5000, '<t font=\"RobotoCondensed\">{e.Result.Text}</t> - Confidence: {Math.Round(e.Result.Confidence, 2) * 100}%']");
    //}

    //static void Testing_SpeechRecognitionRejected(object sender, SpeechRecognitionRejectedEventArgs e)
    //{
    //    // Reset the text in the display box on rejection
    //    Main.callback.Invoke("IVCS", "ctrlsettext", $"['ivcs_test_display', 5000, '']");
    //}

    //static void Testing_SpeechRecognized(object sender, SpeechRecognizedEventArgs e)
    //{
    //    // Log the input text
    //    Logger.Input($"Reconginsed text: '{e.Result.Text}' - Confidence: {Math.Round(e.Result.Confidence, 2) * 100}%");

    //    // Make sure the confidence value is above the user defined value
    //    if (e.Result.Confidence >= confidence)
    //    {
    //        // Split the data to get the index of the text in the grammar xml file
    //        string[] data = ((string)e.Result.Semantics.Value).Split(':');

    //        // Set the text color for the specific ctrl based on the users input
    //        Main.callback.Invoke("IVCS", "ctrlsettextcolor", $"['ivcs_test_display', {int.Parse(data[1], nfi) + 1000}, [0,1,0,1]]");
    //    }
    //}
}