using System;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Speech.Recognition;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace IntegratedVoiceControlSystem
{
    class VersionManager
    {
        private static readonly string GIT_REPO = "Asaayu/integrated-voice-control-system/main";
        private static readonly string GIT_VERSION_CHECK_URL = $"http://raw.githubusercontent.com/{GIT_REPO}/version_check.txt";
        private static Version version;

        internal static void Setup()
        {
            try
            {
                string executingDirectory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
                string versionFilePath = $"{executingDirectory}\\version_check.txt";

                Logger.Debug($"Checking if version file exists.");
                if (!File.Exists(versionFilePath))
                {
                    throw new FileNotFoundException();
                }

                // Load the version from the file
                version = Version.Parse(File.ReadAllText(versionFilePath).ToLower().Trim());

                // Once the version has been loaded, check if there is a new version available
                CheckModVersion();
            }
            catch (FileNotFoundException fileNotFoundException)
            {
                Logger.Error("The version file could not be found.", fileNotFoundException);
                version = Version.Parse("0.0.0.0");
            }
            catch (Exception exception)
            {
                Logger.Error("An error occurred while attempting to get the mod version.", exception);
                version = Version.Parse("0.0.0.0");
            }
        }

        internal static Version GetModVersion()
        {
            return version;
        }

        internal static async void CheckModVersion()
        {
            try
            {
                ServicePointManager.Expect100Continue = true;
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                using (HttpClient client = new HttpClient(new HttpClientHandler { UseDefaultCredentials = true }))
                {
                    string output = await client.GetStringAsync(GIT_VERSION_CHECK_URL);
                    if (string.IsNullOrEmpty(output)) throw new Exception("The version check returned an empty response.");

                    Version remoteVersion = new Version(output);
                    Version localVersion = GetModVersion();

                    if (localVersion < remoteVersion)
                    {
                        string[] messageLines =
                        {
                            "A new version of 'Integrated AI Voice Control' is available to download.",
                            "Click on the three dots under the mod in the Arma 3 Launcher then click 'Repair' to update the mod."
                        };

                        Logger.DisplayMessageBox(messageLines, "Mod Update Available", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                        Logger.Debug($"A new version of the mod is available to download. Local version: {localVersion}, Remote version: {remoteVersion}");
                    }
                    else if (localVersion > remoteVersion)
                    {
                        Logger.Debug($"The mod is up to date. Local version: {localVersion}, Remote version: {remoteVersion}");
                    }
                    else
                    {
                        Logger.Debug($"The mod is up to date. Local version: {localVersion}, Remote version: {remoteVersion}");
                    }
                }
            }
            catch (HttpRequestException httpRequestException)
            {
                // This is probably related to a user who's firewall is blocking the connection, don't do anything
                Logger.Error("An error occurred while attempting to check for a new version of the mod.", httpRequestException, true);
            }
            catch (Exception exception)
            {
                Logger.Error("An error occurred while attempting to check for a new version of the mod.", exception, true);
            };
        }
    }
}

    