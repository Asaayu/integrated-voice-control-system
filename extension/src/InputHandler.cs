using System;
using System.Globalization;

namespace IntegratedVoiceControlSystem
{
    internal static class InputHandler
    {
        internal static string ProcessInput(string argument)
        {
            switch (argument)
            {
                // INFO: Return information about the extension
                case "info":
                    return $"Integrated AI Voice Control System [{VersionManager.GetModVersion()}]";

                // START_TEST: Starts the input test mode
                case "start_test":
                    SpeechEngineHandler.StartTest();
                    return "true";

                // END_TEST: Ends the input test mode
                case "end_test":
                    SpeechEngineHandler.EndTest();
                    return "true";

                // PTT_DOWN: Enable voice input and start listening
                case "ptt_down":
                    SpeechEngineHandler.PttDown();
                    return "true";

                // PTT_UP: Disable voice input and stop listening, processing the last input if any
                case "ptt_up":
                    SpeechEngineHandler.PttUp();
                    return "true";

                // DEFAULT: Return false as the command is not recognized
                default:
                    Logger.Warn($"The command '{argument}' is not recognized.");
                    return "false";
            }
        }

        internal static (int, string) ProcessArrayInput(string argument, string[] parameters)
        {
            switch (argument)
            {
                // OPEN_EXTERNAL_PROGRAM: Open one of the white-listed external programs
                case "open_external_program":
                    Logger.Debug($"Opening external program '{parameters[0]}'");
                    if (parameters.Length >= 1)
                    {
                        Common.OpenExternalProgram(parameters[0].Replace("\"", ""));
                        return (1, null);
                    }
                    return (0, null);

                // SET_MINIMUM_REQUIRED_CONFIDENCE: Set the confidence value for the speech recognition engine
                case "set_minimum_required_confidence":
                    if (parameters.Length >= 1 && double.TryParse(parameters[0], out double confidence))
                    {
                        SpeechEngineHandler.SetMinimumRequiredConfidence(confidence);
                        return (1, null);
                    }
                    return (0, null);

                // SET_INITIAL_SILENCE_TIMEOUT: Set the initial silence timeout
                case "set_initial_silence_timeout":
                    if (parameters.Length >= 1 && double.TryParse(parameters[0], out double initalSilence))
                    {
                        SpeechEngineHandler.SetInitialSilenceTimeout(initalSilence);
                        return (1, null);
                    }
                    return (0, null);

                // SET_END_SILENCE_TIMEOUT_AMBIGUOUS: Set the end silence timeout
                case "set_end_silence_timeout_ambiguous":
                    if (parameters.Length >= 1 && double.TryParse(parameters[0], out double endSilenceAmbiguous))
                    {
                        SpeechEngineHandler.SetEndSilenceTimeoutAmbiguous(endSilenceAmbiguous);
                        return (1, null);
                    }
                    return (0, null);

                // SET_END_SILENCE_TIMEOUT: Set the initial silence timeout
                case "set_end_silence_timeout":
                    if (parameters.Length >= 1 && double.TryParse(parameters[0], out double endSilenceFinished))
                    {
                        SpeechEngineHandler.SetEndSilenceTimeout(endSilenceFinished);
                        return (1, null);
                    }
                    return (0, null);

                // SET_END_BABBLE_TIMEOUT: Set the end babble timeout
                case "set_end_babble_timeout":
                    if (parameters.Length >= 1 && double.TryParse(parameters[0], out double endBabble))
                    {
                        SpeechEngineHandler.SetEndBabbleTimeout(endBabble);
                        return (1, null);
                    }
                    return (0, null);


                // CONVERT_NUMBER_READABLE: Convert a number from text to digits
                case "convert_number_readable":
                    string output = Common.ConvertNumberToHumanString(parameters[0]);
                    return (1, output);

                // REPLACE: Replace second argument with third argument in first argument
                case "replace":
                    if (parameters.Length < 3)
                        return (0, null);

                    parameters[1] = parameters[1].Replace("\"", "");
                    parameters[2] = parameters[2].Replace("\"", "");
                    string result = parameters[0].Replace(parameters[1], parameters[2]).Replace("\"", "");
                    return (1, result);

                // TITLE_CASE: Convert string to title case
                case "title_case":
                    if (parameters.Length < 1)
                        return (0, null);

                    return (1, CultureInfo.CurrentCulture.TextInfo.ToTitleCase(parameters[0])
                        .Replace("Team, ", "Team ")
                        .Replace("Red, ", "Red ")
                        .Replace("Green, ", "Green ")
                        .Replace("Blue, ", "Blue ")
                        .Replace("Yellow, ", "Yellow ")
                        .Replace("White, ", "White ")
                        .Replace("\"", string.Empty)); // Something causes the strings to be surrounded by quotes multiple times, idk why /shrug

                default:
                    Logger.Warn($"The array command '{argument}' is not recognized.");
                    return (-1, null);
            }
        }
    }
}