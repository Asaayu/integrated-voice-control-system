using System.Runtime.InteropServices;
using System.Text;
using RGiesecke.DllExport;

namespace IntegratedVoiceControlSystem
{
    public class Main
    {
        public static ExtensionCallback callback;
        public delegate int ExtensionCallback([MarshalAs(UnmanagedType.LPStr)] string name, [MarshalAs(UnmanagedType.LPStr)] string function, [MarshalAs(UnmanagedType.LPStr)] string data);

#if WIN64
        [DllExport("RVExtensionRegisterCallback", CallingConvention = CallingConvention.Winapi)]
#else
        [DllExport("_RVExtensionRegisterCallback@4", CallingConvention = CallingConvention.Winapi)]
#endif
        public static void RVExtensionRegisterCallback([MarshalAs(UnmanagedType.FunctionPtr)] ExtensionCallback func)
        {
            callback = func;
        }

        /// <summary>
        /// Gets called when Arma starts up and loads all extensions.
        /// </summary>
        /// <param name="output">The string builder object that contains the result of the function</param>
        /// <param name="outputSize">The maximum size of bytes that can be returned</param>
#if WIN64
        [DllExport("RVExtensionVersion", CallingConvention = CallingConvention.Winapi)]
#else
        [DllExport("_RVExtensionVersion@8", CallingConvention = CallingConvention.Winapi)]
#endif
        public static void RvExtensionVersion(StringBuilder output, int outputSize)
        {
            // Run the setup function for the mod
            Common.Setup();

            // Print the current version of the mod to the RPT file
            output.Append(VersionManager.GetModVersion());
        }

        /// <summary>
        /// The entry point for the default callExtension command.
        /// </summary>
        /// <param name="output">The string builder object that contains the result of the function</param>
        /// <param name="outputSize">The maximum size of bytes that can be returned</param>
        /// <param name="argument">The string argument that is used along with callExtension</param>
#if WIN64
        [DllExport("RVExtension", CallingConvention = CallingConvention.Winapi)]
#else
        [DllExport("_RVExtension@12", CallingConvention = CallingConvention.Winapi)]
#endif
        public static void RvExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string argument)
        {
            Logger.Info($"Received argument: '{argument}'");           

            // Process the input and output the result
            output.Append(InputHandler.ProcessInput(argument));
        }

        /// <summary>
        /// The entry point for the callExtensionArgs command.
        /// </summary>
        /// <param name="output">The string builder object that contains the result of the function</param>
        /// <param name="outputSize">The maximum size of bytes that can be returned</param>
        /// <param name="argument">The string argument that is used along with callExtension</param>
        /// <param name="parameters">The args passed to callExtension as a string array</param>
        /// <param name="parametersCount">The size of the string array args</param>
        /// <returns>The result code</returns>
#if WIN64
        [DllExport("RVExtensionArgs", CallingConvention = CallingConvention.Winapi)]
#else
        [DllExport("_RVExtensionArgs@20", CallingConvention = CallingConvention.Winapi)]
#endif
        public static int RvExtensionArgs(StringBuilder output, uint outputSize,
            [MarshalAs(UnmanagedType.LPStr)] string argument,
            [MarshalAs(UnmanagedType.LPArray, ArraySubType = UnmanagedType.LPStr, SizeParamIndex = 4)] string[] parameters, uint parametersCount)
        {
            // Reduce output by 1 to avoid accidental overflow
            outputSize--;

            Logger.Info($"Received array argument: '{argument}', parameters: [{string.Join(", ", parameters)}]");

            // Process the input and output the result
            (int result, string message) = InputHandler.ProcessArrayInput(argument, parameters);
            output.Append(message ?? string.Empty);

            return result;
        }
    }
}