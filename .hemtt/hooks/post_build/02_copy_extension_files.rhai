/*
    Integrated AI Voice Control System
    File: 02_copy_extension_files.rhai
    Author: Asaayu
    Date: 2024-12-27

    Position:
    POST-BUILD

    Description:
    Copies the extension files from their build directory to the root mod directory.
*/

const x64BuildDir = HEMTT_VFS.join("extension").join("obj").join("x64").join("Release");
const x86BuildDir = HEMTT_VFS.join("extension").join("obj").join("x86").join("Release");
const outputDir = HEMTT_VFS;

const fileList = x64BuildDir.list() + x86BuildDir.list();
for file in fileList {
    const fileName = file.file_name();
    if (!file.is_file() || !fileName.ends_with(".dll")) {
        continue;
    }

    // If the file already exists, remove the old file
    const outputFile = outputDir.join(fileName);
    if (outputFile.exists()) {
        outputFile.remove_file();
    }

    file.copy(outputFile);
}

print("Copied " + fileList.len() + " extension files to the root mod directory");
