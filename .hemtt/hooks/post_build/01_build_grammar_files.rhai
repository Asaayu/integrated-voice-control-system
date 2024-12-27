/*
    Integrated AI Voice Control System
    File: 01_build_grammar_files.rhai
    Author: Asaayu
    Date: 2024-12-26

    Position:
    POST-BUILD

    Description:
    Builds the grammar files for each supported language code from the template base grammar files.
*/

// All the language codes that have 'Speech Recognition' support in Windows Language installation
const languageCodes = [
    "da-DK",  // Danish (Denmark)
    "de-DE",  // German (Germany)
    "en-AU",  // English (Australia)
    "en-CA",  // English (Canada)
    "en-GB",  // English (United Kingdom)
    "en-IN",  // English (India)
    "en-US",  // English (United States)
    "es-ES",  // Spanish (Spain)
    "es-MX",  // Spanish (Mexico)
    "fr-CA",  // French (Canada)
    "fr-FR",  // French (France)
    "it-IT",  // Italian (Italy)
    "ja-JP",  // Japanese (Japan)
    "pt-BR",  // Portuguese (Brazil)
    "zh-CN",  // Chinese Simplified (China)
    "zh-HK",  // Chinese Traditional (Hong Kong)
    "zh-TW",  // Chinese Traditional (Taiwan)
];

// Get all the template grammar files
const grammarTemplateDir = HEMTT_VFS.join("grammar");
const currentGrammarFiles = grammarTemplateDir.list().filter(|x| x.file_name().contains(".template"));

print("Found " + currentGrammarFiles.len() + " template grammar files");

// Go through each template file and create a copy for each language code that matches the template's language
for currentGrammarFile in currentGrammarFiles {
    const isTestingGrammar = currentGrammarFile.file_name().contains("_test");
    const validLanguageCodes = languageCodes.filter(|x| currentGrammarFile.file_name().starts_with(x.split("-")[0]));

    let currentGrammarFileNameNoExt = currentGrammarFile.file_name();
    currentGrammarFileNameNoExt.replace(".template", "");
    print(currentGrammarFileNameNoExt + " -> " + validLanguageCodes.len() + " compatible language code" + if (validLanguageCodes.len() > 1) { "s" } else { "" });
    print(validLanguageCodes);

    for languageCode in validLanguageCodes {
        let grammarData = currentGrammarFile.open_file().read();
        grammarData.replace("__HEMTT_INSERT_LANGUAGE__", languageCode);

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