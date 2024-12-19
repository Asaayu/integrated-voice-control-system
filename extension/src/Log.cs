using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using Sentry;

namespace IVCS
{
    internal class Log
    {
        internal static bool debug;

        internal static void Setup()
        {
            // Check for debug parameter
            debug = Environment.CommandLine.Contains("-debug");

            if (debug) AllocConsole();
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
            //SentrySdk.CaptureException(e);

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