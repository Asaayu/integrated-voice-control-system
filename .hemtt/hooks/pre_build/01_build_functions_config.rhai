/*
    Integrated AI Voice Control System
    File: 01_build_functions_config.rhai
    Author: Asaayu
    Date: 2024-12-26

    Position:
    PRE-BUILD

    Description:
    Builds the CfgFunctions file for the IVCS functions using the file structure in the "functions_f_ivcs/functions" directory.
*/

// Define constants for paths
const BASE_PATH = "\\z\\ivcs\\addons\\functions_f_ivcs\\functions\\";
const CFG_FUNCTIONS_FILE_PATH = HEMTT_VFS.join("addons").join("functions_f_ivcs").join("cfgfunctions.hpp");

// Get all the folders in the "functions_f_ivcs/functions" directory
let functionFolders = HEMTT_VFS.join("addons").join("functions_f_ivcs").join("functions").list().filter(|x| x.is_dir());

// Create a list of functions in each of the folders
let functionData = #{};
for functionFolder in functionFolders {
    const folderName = functionFolder.file_name();

    functionData[folderName] = [];
    let functions = functionFolder.list().filter(|x| x.is_file() && x.file_name().contains(".sqf"));
    for function in functions {
        functionData[folderName].push(function.file_name());
    }
}

// Convert the map of folders and containing functions into an Arma 3 compatible CfgFunctions file format
let folderIndex = 0;
let formattedFunctionData = "";
for folderName in functionData.keys() {
    formattedFunctionData += "class " + folderName + "\n\t\t{\n";

    let fileIndex = 0;
    for fileName in functionData[folderName] {
        let functionName = fileName;
        functionName.crop(3);
        functionName.replace(".sqf", "");

        if (fileIndex != 0) { formattedFunctionData += "\n" }
        formattedFunctionData += "\t\t\tclass " + functionName + " { file = \"" + BASE_PATH + folderName + "\\" + fileName + "\"; };";
        fileIndex += 1;
    }

    formattedFunctionData += "\n\t\t};";
    if (folderIndex != functionData.len() - 1) {
        formattedFunctionData += "\n\t\t";
    }

    folderIndex += 1;
}

// Insert the formatted function data into the CfgFunctions file template using the __HEMTT_INSERT_FUNCTIONS__ placeholder
let finalFunctionString = CFG_FUNCTIONS_FILE_PATH.open_file().read();
finalFunctionString.replace("__HEMTT_INSERT_FUNCTIONS__", formattedFunctionData);

// Overwrite the CfgFunctions template file with the new data
let functionsOutFile = CFG_FUNCTIONS_FILE_PATH.create_file();
functionsOutFile.write(finalFunctionString);

print("File \"" + CFG_FUNCTIONS_FILE_PATH + "\" has been built successfully");
