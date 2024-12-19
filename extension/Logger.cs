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
using System.Threading.Tasks;

namespace ivcs
{
    internal class Logger
    {
        internal static bool debug;

        internal static void Setup()
        {
            bool debug = Environment.CommandLine.Contains("-debug");

            if (debug)
            {
                AllocConsole();
            }
        }

        [DllImport("kernel32")]
        static extern bool AllocConsole();

        private static bool Output(string message, string prefix = "INFO")
        {
            try
            {
                string message_text = DateTime.Now.ToString("[dd/MM/yyyy hh:mm:ss tt]") + "[" + prefix + "] " + message;
                if (debug)
                {
                    Console.WriteLine(message_text);
                }

                return true;
            }
            catch
            {
                return false;
            }
        }

        internal static bool Error(string message, Exception e, bool skipMessageBox = false)
        {
            bool response = Output(message, "ERROR");

            if (!skipMessageBox)
            {
                MessageBox.Show($"An error has occurred.\n\n\n{e.Message}\n{e.StackTrace}\n\n\nThis mod may not work correctly after this error, if it happens frequently try repairing your mod through the Arma 3 launcher.\nIf it still occurs please inform a developer.", "An error has occurred!", MessageBoxButtons.OK);
            }

            return response;
        }

        internal static bool Warn(string message)
        {
            return Output(message, "WARN");
        }
        internal static bool Info(string message)
        {
            return Output(message, "INFO");
        }
        
        internal static bool Log(string message)
        {
            return Output(message, "TRACE");
        }

        internal static bool Debug(string message)
        {
            return Output(message, "DEBUG");
        }

        internal static bool Input(string message)
        {
            return Output(message, "INPUT");
        }
    }
}