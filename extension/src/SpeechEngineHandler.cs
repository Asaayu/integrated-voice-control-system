using System;
using System.Globalization;
using System.Linq;
using System.Speech.Recognition;
using System.Threading;
using System.Windows.Forms;
using static IntegratedVoiceControlSystem.Types;

namespace IntegratedVoiceControlSystem
{
    internal static class SpeechEngineHandler
    {
        private static SpeechRecognitionEngine speechEngine;
        private static bool usingTestGrammar = false;
        private static bool ptt = false;
        private static bool speech = false;

        private static double minimumRequiredConfidence = 0.8;

        /// <summary>
        /// The time interval during which a SpeechRecognitionEngine accepts input containing only silence before finalizing recognition.
        /// </summary>
        private static double initialSilenceTimeout = 5.0;

        /// <summary>
        /// The interval of silence that the SpeechRecognitionEngine will accept at the end of ambiguous input before finalizing a recognition operation.
        /// </summary>
        private static double endSilenceTimeoutAmbiguous = 0.5;

        /// <summary>
        /// The interval of silence that the SpeechRecognitionEngine will accept at the end of unambiguous input before finalizing a recognition operation.
        /// </summary>
        private static double endSilenceTimeout = 0.5;

        /// <summary>
        ///  The time interval during which a SpeechRecognitionEngine accepts input containing only background noise, before finalizing recognition.
        /// </summary>
        private static double babbleTimeout = 0.0;

        internal static void Setup()
        {
            try
            {
                // Check that there is at least one supported culture on the system
                CultureInfo firstSupportedCulture = GrammarHandler.GetFirstSupportedCultureOnSystem() ?? throw new CultureNotFoundException();

                Logger.Debug($"Setting up speech recognition engine for culture '{firstSupportedCulture.EnglishName}'.");
                speechEngine = new SpeechRecognitionEngine(firstSupportedCulture);                              

                speechEngine.SpeechRecognized += new EventHandler<SpeechRecognizedEventArgs>(SpeechRecognized);
                speechEngine.SpeechHypothesized += new EventHandler<SpeechHypothesizedEventArgs>(SpeechHypothesized);
                speechEngine.SpeechRecognitionRejected += new EventHandler<SpeechRecognitionRejectedEventArgs>(SpeechRecognitionRejected);
                speechEngine.SpeechDetected += new EventHandler<SpeechDetectedEventArgs>(SpeechDetected);
                speechEngine.RecognizeCompleted += new EventHandler<RecognizeCompletedEventArgs>(RecognizeCompleted);

                speechEngine.InitialSilenceTimeout = TimeSpan.FromSeconds(initialSilenceTimeout);
                speechEngine.EndSilenceTimeoutAmbiguous = TimeSpan.FromSeconds(endSilenceTimeoutAmbiguous);
                speechEngine.EndSilenceTimeout = TimeSpan.FromSeconds(endSilenceTimeout);
                speechEngine.BabbleTimeout = TimeSpan.FromSeconds(babbleTimeout);

                LoadBaseGrammar();

                speechEngine.SetInputToDefaultAudioDevice();
            }
            catch (CultureNotFoundException cultureNotFoundException)
            {
                CultureInfo[] supportedCultures = GrammarHandler.GetAllSupportedCultures();
                string[] messages =
                {
                    "Your operating system does not a language pack installed that is supported by the 'Integrated AI Voice Control' mod.",
                    "",
                    "Currently the following languages are supported by the mod:",
                    string.Join(", ", supportedCultures.Select(culture => culture.EnglishName)),
                    "",
                    "Would you like to view instructions for installing a language pack for Windows?"
                };
                Logger.DisplayMessageBox(messages, "Language Pack Not Installed", MessageBoxButtons.YesNo, MessageBoxIcon.Error, MessageBoxHelpLink.InstallLanguagePack);
                Logger.Error("No supported language pack was found on the operating system.", cultureNotFoundException, true);
            }
            catch (InvalidOperationException invalidOperationException)
            {
                string[] messages =
                {
                    "The 'Integrated AI Voice Control' mod can't connect to your microphone.",
                    "Make sure your microphone is connected, has been set as the default input device in your sound settings, and try again."
                };

                Logger.DisplayMessageBox(messages, "Microphone Connection Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                Logger.Error("The 'Integrated AI Voice Control' mod can't connect to the microphone.", invalidOperationException, true);
            }
            catch (NullReferenceException nullReferenceException)
            {
                Logger.Error("NullReferenceException in mission start function thread", nullReferenceException);
            }
            catch (Exception exception)
            {
                Logger.Error("An error occurred when attempting to enable the speech engine", exception);
            };
        }

        internal static void StartTest()
        {
            try
            {
                Logger.Debug("Starting test mode...");
                speechEngine.SetInputToDefaultAudioDevice();
                speechEngine.RecognizeAsync(RecognizeMode.Multiple);

                LoadTestGrammar();
            }
            catch (Exception e)
            {
                Logger.Error("An error occurred when attempting to start test mode", e);
            }
        }

        internal static void EndTest()
        {
            try
            {
                Logger.Debug("Ending test mode...");
                speechEngine.RecognizeAsyncStop();

                LoadBaseGrammar();
            }
            catch (Exception e)
            {
                Logger.Error("An error occurred when attempting to end test mode", e);
            }
        }

        internal static void LoadBaseGrammar()
        {
            try
            {
                CultureInfo culture = speechEngine.RecognizerInfo.Culture;
                Logger.Debug($"Loading base grammar for culture '{culture.EnglishName}'.");

                Grammar grammarData = GrammarHandler.GetGrammarData(culture);

                speechEngine.UnloadAllGrammars();
                speechEngine.LoadGrammar(grammarData);
                usingTestGrammar = false;
            }
            catch (Exception e)
            {
                Logger.Error("An error occurred when attempting to load the base grammar", e);
            }
        }

        internal static void LoadTestGrammar()
        {
            try
            {
                CultureInfo culture = speechEngine.RecognizerInfo.Culture;
                Logger.Debug($"Loading test grammar for culture '{culture.EnglishName}'.");

                Grammar grammarData = GrammarHandler.GetGrammarData(culture, true);

                speechEngine.UnloadAllGrammars();
                speechEngine.LoadGrammar(grammarData);
                usingTestGrammar = true;
            }
            catch (Exception e)
            {
                Logger.Error("An error occurred when attempting to load the base grammar", e);
            }
        }

        private static void SpeechDetected(object sender, SpeechDetectedEventArgs speechDetectedEventArgs)
        {
            speech = true;

            UiManager.SetPttBackgroundColor(PttBackgroundColorState.Listening);
            UiManager.SetPttBackgroundDisplay(true);
        }

        private static void SpeechHypothesized(object sender, SpeechHypothesizedEventArgs speechHypothesizedEventArgs)
        {
            if (!usingTestGrammar)
            {
                UiManager.SetPttText(speechHypothesizedEventArgs.Result.Text.Replace(",", ""), Math.Round(speechHypothesizedEventArgs.Result.Confidence, 2) * 100);
            }
            else
            {
                UiManager.SetTestText(speechHypothesizedEventArgs.Result.Text, Math.Round(speechHypothesizedEventArgs.Result.Confidence, 2) * 100);
            }            
        }

        private static void SpeechRecognitionRejected(object sender, SpeechRecognitionRejectedEventArgs speechRecognitionRejectedEventArgs)
        {
            Logger.Debug("Speech recognition rejected...");

            if (!usingTestGrammar)
            {
                UiManager.SetPttBackgroundColor(PttBackgroundColorState.Rejected);
            }
            else
            {
                UiManager.SetTestTextEmpty();
            }
        }

        private static void SpeechRecognized(object sender, SpeechRecognizedEventArgs speechRecognizedEventArgs)
        {
            Logger.Input($"Recognized Text: '{speechRecognizedEventArgs.Result.Text}' - Confidence: {Math.Round(speechRecognizedEventArgs.Result.Confidence, 2) * 100}% - Semantic value: '{speechRecognizedEventArgs.Result.Semantics.Value}'");
            UiManager.SetPttText(speechRecognizedEventArgs.Result.Text.Replace(",", ""), Math.Round(speechRecognizedEventArgs.Result.Confidence, 2) * 100);

            // Make sure the confidence value is above the user defined value
            if (speechRecognizedEventArgs.Result.Confidence >= minimumRequiredConfidence)
            {
                if (!usingTestGrammar)
                {
                    if (speechRecognizedEventArgs.Result.Text.Contains("every1"))
                    {
                        UiManager.SetPttBackgroundColor(PttBackgroundColorState.Rejected);
                        return;
                    }

                    UiManager.SetPttBackgroundColor(PttBackgroundColorState.Recognized);

                    string data = Common.ConvertSemanticToArmaCompatible(speechRecognizedEventArgs.Result.Semantics.Value.ToString(), Common.ConvertNumberToHumanString(speechRecognizedEventArgs.Result.Text, true));
                    Main.callback.Invoke("IVCS", "speech_recognition_result", data);
                }
                else
                {
                    string[] data = speechRecognizedEventArgs.Result.Semantics.Value.ToString().Split(':');
                    UiManager.SetTestTextColor(int.Parse(data[1]) + 1000);
                }
            }
            else if (!usingTestGrammar)
            {
                UiManager.SetPttBackgroundColor(PttBackgroundColorState.BelowThreshold);
            }
        }

        private static void RecognizeCompleted(object sender, RecognizeCompletedEventArgs recognizeCompletedEventArgs)
        {
            if (speech)
            {
                Thread.Sleep(1000);
                UiManager.SetPttBackgroundDisplay(false);
            }
        }

        internal static void PttDown()
        {
            try
            {
                if (ptt) return;
                Logger.Info("PTT key pressed, enabling speech recognition...");

                ptt = true;
                speech = false;

                speechEngine.SetInputToDefaultAudioDevice();
                speechEngine.RecognizeAsync(RecognizeMode.Multiple);
            }
            catch (Exception e)
            {
                Logger.Error("An error occurred when attempting to enable the speech engine", e);
            }
        }

        internal static void PttUp()
        {
            try
            {
                if (!ptt) return;
                Logger.Info("PTT key released, disabling speech recognition...");

                ptt = false;

                speechEngine.RecognizeAsyncStop();
            }
            catch (Exception e)
            {
                Logger.Error("An error occurred when attempting to disable the speech engine", e);
            }
        }

        internal static void SetMinimumRequiredConfidence(double confidence)
        {
            try
            {
                Logger.Debug($"Setting confidence value to {confidence}...");
                minimumRequiredConfidence = confidence;
            }
            catch (Exception e)
            {
                Logger.Error("An error occurred when attempting to set the minimum required confidence", e);
            }
        }

        internal static void SetInitialSilenceTimeout(double timeout)
        {
            try
            {
                Logger.Debug($"Setting initial silence timeout to {timeout}...");
                initialSilenceTimeout = timeout;
            }
            catch (Exception e)
            {
                Logger.Error("An error occurred when attempting to set the initial silence timeout", e);
            }
        }

        internal static void SetEndSilenceTimeoutAmbiguous(double timeout)
        {
            try
            {
                Logger.Debug($"Setting end silence timeout ambiguous to {timeout}...");
                endSilenceTimeoutAmbiguous = timeout;
            }
            catch (Exception e)
            {
                Logger.Error("An error occurred when attempting to set the end silence timeout ambiguous", e);
            }
        }

        internal static void SetEndSilenceTimeout(double timeout)
        {
            try
            {
                Logger.Debug($"Setting end silence timeout to {timeout}...");
                endSilenceTimeout = timeout;
            }
            catch (Exception e)
            {
                Logger.Error("An error occurred when attempting to set the end silence timeout", e);
            }
        }

        internal static void SetEndBabbleTimeout(double timeout)
        {
            try
            {
                Logger.Debug($"Setting end babble timeout to {timeout}...");
                babbleTimeout = timeout;
            }
            catch (Exception e)
            {
                Logger.Error("An error occurred when attempting to set the end babble timeout", e);
            }
        }
    }
}