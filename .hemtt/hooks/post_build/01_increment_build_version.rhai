/*
    Integrated AI Voice Control System
	File: 01_increment_build_version.rhai
    Author: Asaayu
    Date: 2024-12-26

    Position:
    POST-BUILD

    Description:
    Increments the project build version by one
*/

// Read the project.toml file from the real file system
let projectData = HEMTT_RFS
    .join(".hemtt")
    .join("project.toml")
    .open_file()
    .read();

// Get the current and next build version
let prefix = "build = ";
let current = HEMTT.project().version().build();
let next = current + 1;

// Replace the current build version with the incremented build version
projectData.replace(prefix + current.to_string(), prefix + next.to_string());

// Write the modified contents to the real file system
HEMTT_RFS
    .join(".hemtt")
    .join("project.toml")
    .create_file()
    .write(projectData);

print("Incremented future build version from " + current.to_string() + " to " + next.to_string());

// If this is not a release build, also update the extension version, as the release build will do this too
if (!HEMTT.is_release()) { HEMTT.script("update_extension_version"); }