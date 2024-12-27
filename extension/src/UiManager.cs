using System;
using static IntegratedVoiceControlSystem.Types;

namespace IntegratedVoiceControlSystem
{
    class UiManager
    {
        internal static void SetPttBackgroundDisplay(bool display)
        {
            Console.WriteLine($"Setting PTT background display to {display}");
            Main.callback.Invoke("IVCS", "set_ptt_background_display", display ? "show" : "hide");
        }

        internal static void SetPttBackgroundColor(PttBackgroundColorState pttBackgroundColorState)
        {
            Console.WriteLine($"Setting PTT background color to {pttBackgroundColorState}");
            Main.callback.Invoke("IVCS", "set_ptt_background_color", pttBackgroundColorState.ToString());
        }

        internal static void SetPttText(string recognizedText, double confidence)
        {
            Console.WriteLine($"Setting PTT text to '{recognizedText}' with confidence value of {confidence}%");
            Main.callback.Invoke("IVCS", "set_ptt_text", recognizedText);
            Main.callback.Invoke("IVCS", "set_ptt_confidence_text", confidence.ToString());
        }

        internal static void SetTestText(string recognizedText, double confidence)
        {
            Console.WriteLine($"Setting test text to '{recognizedText}' with confidence value of {confidence}%");
            Main.callback.Invoke("IVCS", "set_test_text", $"{recognizedText}:{confidence}");
        }

        internal static void SetTestTextEmpty()
        {
            Console.WriteLine($"Setting test text to 'EMPTY'");
            Main.callback.Invoke("IVCS", "set_test_text", string.Empty);
        }

        internal static void SetTestTextColor(int index)
        {
            Console.WriteLine($"Setting test text color for index {index}");
            Main.callback.Invoke("IVCS", "set_test_text_color", index.ToString());
        }
    }
}

    