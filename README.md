# Integrated AI Voice Control System

The **Integrated AI Voice Control System** enables players to issue voice commands to AI units in their group using Windows' built-in voice recognition. No third-party software is required.

- [List of All Commands](https://docs.google.com/spreadsheets/d/1Pbwz66e1Rkt8UKqnUL8lydbUG9HuOVFM_D1lKtuwusQ/edit?usp=sharing)

### Features
- **Voice Commands**: Issue commands to AI units in your group.
- **Test Voice Recognition**: Use the "Test Microphone" button in the main menu to test your microphone and Windows Voice Recognition.

---

## Installation

### Install the Mod
1. Go to the Steam Workshop page for the [Integrated AI Voice Control System](https://steamcommunity.com/sharedfiles/filedetails/?id=2535464017).
2. Click the green "Subscribe" button to download the mod.
3. Launch Arma 3 and enable the mod in the launcher.

### Related Microsoft Support Articles
- [Use voice recognition in Windows](https://support.microsoft.com/en-us/windows/use-voice-recognition-in-windows-83ff75bd-63eb-0b6c-18d4-6fae94050571)
- [Language packs for Windows](https://support.microsoft.com/en-us/windows/language-packs-for-windows-a5094319-a92d-18de-5b53-1cfc697cfca8)

---

## Development

### Requirements
- **Arma 3**
- **Visual Studio**
- **Arma 3 Tools**

### Setting Up the Development Environment
1. Clone the repository to your local machine.
2. Install [HEMTT](https://hemtt.dev/) for building the mod.

### Building the C# Extension
1. Open the `extension/IntegratedVoiceControlSystem.sln` solution in Visual Studio.
2. Install the required NuGet package dependencies.
3. Build the solution.
    * 64-bit: Will create an `ivcs_x64.dll` file.
    * 32-bit: Will create an `ivcs.dll` file.
4. Files other then the two `.dll` files above can be ignored.

### Building the Arma 3 Mod
The C# extension must be built first to be automatically included in the mod.
1. Open command prompt in the root directory of the repository.
2. Run the following command to build the mod:
    ```bash
    hemtt build
    ```
3. The mod will be built into the `.hemttout\build` directory.
4. Copy or symlink the contents of the build directory to your Arma 3 mod directory for testing.

### Testing the Mod
1. Enable debug mode in the Arma 3 launcher.
2. Launch Arma 3 with the mod enabled.
3. A console window will appear logging all debug information from the mod.
4. Use the mod as you would normally to test changes.

### Adding New Commands
Use the already existing commands and how they are implemented as a reference when adding new commands.

1. Add the new command to the grammar XML template files in the `grammar` directory for your desired language.
2. Add the phonetic pronunciation for the new command to the PLS file in the `grammar` directory.
3. Add the localized group chat output for the new command to the first switch block in the `fn_handleSpeechRecognitionResult.sqf` file in the `\addons\functions_f_ivcs\functions\callback` directory.
4. Add the functionality for the new command in the second switch block in the `fn_handleSpeechRecognitionResult.sqf` file.
5. Build the Arma 3 mod and test that the new command is recognized and functions as expected.

*Note: The grammar files are setup as templates based on each language. When built, HEMTT will automatically generate the necessary grammar files for each language supported by Windows Speech Recognition.*

---

## License
Integrated AI Voice Control System is licensed under the APL-ND License. See the [LICENSE](LICENSE) file for more information.

