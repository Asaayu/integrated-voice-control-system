namespace IntegratedVoiceControlSystem
{
    class Types
    {
        public enum ExternalProgram
        {
            SpeechTraining,
            SpeechRecognizer,
            SoundControlPanel
        }

        public enum PttBackgroundColorState
        {
            Listening,
            Rejected,
            Recognized,
            BelowThreshold
        }

        public enum MessageBoxHelpLink
        {
            None,
            InstallLanguagePack,
        }
    }
}

    