namespace IntegratedVoiceControlSystem
{
    class Types
    {
        public enum ExternalProgram
        {
            SpeechTraining,
            SpeechSettings,
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

    