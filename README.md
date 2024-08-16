# Integrated AI Voice Control System
Integrated AI Voice Control System allows players to give commands to AI units within their group using their voice and Windows built-in voice recognition engine, all without having to install any third-party programs.

### [List of all Commands](https://docs.google.com/spreadsheets/d/1Pbwz66e1Rkt8UKqnUL8lydbUG9HuOVFM_D1lKtuwusQ/edit?usp=sharing)

In the options menu of the main menu there are two new buttons, one to open the testing dialog to test your microphone and Voice Recognition Engine, and another to open the Windows Voice Recognition training program.

The source code for the mod is available on GitHub @ https://github.com/Asaayu/integrated-voice-control-system

# Building the mod
This mod is split into two separate modules, the internal Arma 3 mod, and the external C# extension.

### Arma 3
To build the Arma 3 module, follow the instructions for installing and setting up [pboProject](https://mikero.bytex.digital/Downloads) by Mikero.
Then add the root folder for this repository to your P: drive and use pboProject to build it into a PBO file.

### C# Module
The C# module is located in the `_extension/ivcs` folder of the root directory of the repository.
First, read through and understand the instructions on the [Arma 3 Wiki](https://community.bistudio.com/wiki/Extensions) regarding the development of extensions, then open the `_extension/ivcs` folder in Visual Studio and build the project. (It has been a several years since I made this mod, and I no longer have the tools or time to continue to update this mod, so unfortunately I can't provide any more specific instructions on how to build the module)

_**IMPORTANT NOTE:** If you edit the extension and build your own .dll file, it will not be whitelisted by BattleEye, and will therefore not work if BattleEye is enabled in the launcher when starting the game with the mod loaded. For most common changes you shouldn't need to make any changes to the .dll file._


# Editing/Adding new words and phrases
Most of the setup for words and phrases exists in either the grammar XML files in the `_grammar` folder, or in the `functions_f_ivcs/functions/callback/fn_callback_input.sqf` file.

### Existing functionality
If you wish to alter or add new words or phrases to the mod for functions it already has, all you need to do is add your new words or phrases to the grammar XML files in the `_grammar` folder.
As an example:
```xml
<item>
    <ruleref uri="#selection"/>
    <one-of>
        <item>
            assign
            <tag>out="assign[assign_color]:{color}";</tag>
        </item>
        <item>
            join
            <tag>out="join[assign_color]:{color}";</tag>
        </item>
    </one-of>
    <ruleref uri="#team_colors"/>
</item>
```
This is the grammar item for assigning units to a color, as you can see it is made up of three parts.
1. `<ruleref uri="#selection"/>`
    - This means that the first part of the phrase must have a reference in the `selection` rule, these rules are defined at the bottom of the grammar file.
2. `<one-of>`
    - This means that the second part of this phrase must match one-of the items we have defined in the XML object, in this example we have 'assign' and 'join'
    - If you were wanting to add 'link up with' as an acceptable phrase, e.g. "[five] link up with [red]", then you would copy one of the existing items and replace the words (Not the tag) with your new phrase.
3. `<ruleref uri="#team_colors"/>`
    - This is the same as the first part of the phrase, but the third part of the phrase must have a reference in the `team_colors` rule, also defined at the bottom of the grammar file.

Once you have added your new phrase to the grammar XML file, when you rebuild the Arma 3 module and start the game, the new phrase should now work in-game.
