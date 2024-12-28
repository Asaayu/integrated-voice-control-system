/*
    Integrated AI Voice Control System
    File: 02_update_version_check_file.rhai
    Author: Asaayu
    Date: 2024-12-26

    Position:
    PRE-BUILD

    Description:
    Updates the 'version_check.txt' file in the root directory with the current version for the extension online version check.
*/

// Get the current version data from the project
const currentVersion = HEMTT.project().version().to_string().split("-")[0];

// Write the modified contents to the version check file
HEMTT_RFS.join("version_check.txt").create_file().write(currentVersion);
print("Updated 'version_check.txt' callback file with version \"" + currentVersion + "\"");
