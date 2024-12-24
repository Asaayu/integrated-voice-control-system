using System;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Speech.Recognition;
using System.Windows.Forms;

namespace IntegratedVoiceControlSystem
{
    internal static class GrammarHandler
    {
        internal static Grammar GetGrammarData(CultureInfo culture, bool testGrammar = false)
        {
            try
            {
                string executingDirectory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
                string grammarFilePath = $"{executingDirectory}\\grammar\\{culture.Name}{(testGrammar ? "_test" : "")}.xml";

                Logger.Debug($"Checking if grammar file '{culture.Name}' exists.");
                if (!File.Exists(grammarFilePath))
                {
                    throw new FileNotFoundException();
                }

                Logger.Debug($"Grammar file found for culture '{culture.Name}'.");
                return new Grammar(grammarFilePath);
            }
            catch (FileNotFoundException fileNotFoundException)
            {
                string[] messages =
                {
                    $"A grammar file for the language '{culture.EnglishName}' could not be found.",
                    "If you would you like to help the mod support this language please get in contact with the mod author."
                };
                Logger.DisplayMessageBox(messages, "Grammar File Not Found", MessageBoxButtons.OK, MessageBoxIcon.Error);
                Logger.Error("No grammar file was found for the specified culture or fall back culture.", fileNotFoundException, true);
                return null;
            }
            catch (Exception exception)
            {
                Logger.Error("An error occurred while attempting to load the grammar file!", exception);
                return null;
            }
        }

        internal static CultureInfo GetFirstSupportedCultureOnSystem()
        {
            try
            {
                var installedRecognizers = SpeechRecognitionEngine.InstalledRecognizers();
                Logger.Debug($"Found {installedRecognizers.Count} installed recognizers on the system - [{string.Join(", ", installedRecognizers.Select(recognizer => recognizer.Culture.EnglishName))}]");

                foreach (RecognizerInfo recognizer in installedRecognizers)
                {
                    CultureInfo culture = recognizer.Culture;
                    if (IsCultureSupported(culture))
                    {
                        Logger.Debug($"The first supported culture on the system is '{culture.EnglishName}'");
                        return culture;
                    }
                }

                return null;
            }
            catch (Exception exception)
            {
                Logger.Error("An error occurred while attempting to get the first supported culture.", exception);
                return null;
            }
        }

        internal static CultureInfo[] GetAllSupportedCultures()
        {
            try
            {
                string executingDirectory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
                string[] grammarFiles = Directory.GetFiles($"{executingDirectory}\\grammar", "*.xml");
                CultureInfo[] supportedCultures = new CultureInfo[grammarFiles.Length];

                for (int i = 0; i < grammarFiles.Length; i++)
                {
                    string cultureName = Path.GetFileNameWithoutExtension(grammarFiles[i]).Replace("_test", "");
                    supportedCultures[i] = new CultureInfo(cultureName);
                }

                // Remove duplicates
                supportedCultures = supportedCultures.Distinct().ToArray();

                return supportedCultures;
            }
            catch (Exception exception)
            {
                Logger.Error("An error occurred while attempting to get all supported cultures.", exception);
                return null;
            }
        }

        internal static bool IsCultureSupported(CultureInfo culture)
        {
            try
            {
                string executingDirectory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);

                string[] cultures = { culture.Name, culture.TwoLetterISOLanguageName };
                for (int i = 0; i < cultures.Length; i++)
                {
                    string grammarPath = $"{executingDirectory}\\grammar\\{cultures[i]}.xml";
                    Logger.Debug($"Checking if grammar file '{cultures[i]}' exists.");
                    if (File.Exists(grammarPath))
                    {
                        return true;
                    }
                }

                return false;
            }
            catch (Exception exception)
            {
                Logger.Error("An error occurred while attempting to check if a culture is supported.", exception);
                return false;
            }
        }

        
    }
}