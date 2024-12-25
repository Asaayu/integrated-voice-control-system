let languageCodes = [
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

// Path to the grammar folder
let grammarFolderDir = HEMTT_VFS.join("grammar");
let currentGrammarFiles = grammarFolderDir.list().filter(|x| x.file_name().contains(".xml"));

print();
print();
print("Building grammar files...");

let fileCount = 0;
for currentGrammarFile in currentGrammarFiles {
    print();
    print("Processing: " + currentGrammarFile.file_name());

    for langCode in languageCodes {
        if !currentGrammarFile.file_name().starts_with(langCode.split("-")[0]) {
            continue;
        }

        let grammarData = currentGrammarFile.open_file().read();
        grammarData.replace("xml:lang=\"xx-XX\"", "xml:lang=\"" + langCode + "\"");

        let isTestingGrammar = currentGrammarFile.file_name().contains("_test");
        let outGrammarFilePath = grammarFolderDir.join(langCode + if (isTestingGrammar) { "_test" } + ".xml");
        let outGrammarFile = outGrammarFilePath.create_file();

        print("Writing to: " + outGrammarFilePath.file_name());
        outGrammarFile.write(grammarData);
        fileCount += 1;
    }

    print("Processing Finished");
    print()
}

// Delete the original grammar files
for currentGrammarFile in currentGrammarFiles {
    currentGrammarFile.remove_file();
}

print("Built " + fileCount + " grammar files successfully!");
print();
print();