/*
    Integrated AI Voice Control System
	File: 02_convert_grammars.rhai
    Author: Asaayu
    Date: 2024-12-26

    Position:
    PRE-BUILD

    Description:
    Converts the base language grammar files into the required language-specific for Windows Speech Recognition.
*/

// All the language codes that are supported by Windows Speech Recognition
const languageCodes = [
    "en-US",  //# English (United States)
    "en-GB",  //# English (United Kingdom)
    "en-CA",  //# English (Canada)
    "en-IN",  //# English (India)
    "en-AU",  //# English (Australia)
    "fr-FR",  //# French (France)
    "de-DE",  //# German (Germany)
    "ja-JP",  //# Japanese (Japan)
    "zh-CN",  //# Chinese Simplified (China)
    "zh-TW",  //# Chinese Traditional (Taiwan)
    "es-ES",  //# Spanish (Spain)
];

// Get all the template grammar files
const grammarTemplateDir = HEMTT_VFS.join("grammar");
const currentGrammarFiles = grammarTemplateDir.list().filter(|x| x.file_name().contains(".xml"));

print("Found " + currentGrammarFiles.len() + " template grammar files");

// Go through each template file and create a copy for each language code that matches the template's language
for currentGrammarFile in currentGrammarFiles {
    const isTestingGrammar = currentGrammarFile.file_name().contains("_test");
    const validLanguageCodes = languageCodes.filter(|x| currentGrammarFile.file_name().starts_with(x.split("-")[0]));

    print(currentGrammarFile.file_name() + " -> " + validLanguageCodes.len() + " language files");
    print(validLanguageCodes);

    for languageCode in validLanguageCodes {
        let grammarData = currentGrammarFile.open_file().read();
        grammarData.replace("xml:lang=\"xx-XX\"", "xml:lang=\"" + languageCode + "\"");

        const outGrammarFileName = languageCode + if (isTestingGrammar) { "_test" } + ".xml";
        const outGrammarPath = grammarTemplateDir.join(outGrammarFileName);

        let outGrammarFile = outGrammarPath.create_file();
        outGrammarFile.write(grammarData);
    }
}

// Delete the template grammar files
for currentGrammarFile in currentGrammarFiles {
    currentGrammarFile.remove_file();
}