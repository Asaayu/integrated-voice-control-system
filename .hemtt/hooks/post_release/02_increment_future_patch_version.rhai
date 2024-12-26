/*
    Integrated AI Voice Control System
    File: 02_increment_future_patch_version.rhai
    Author: Asaayu
    Date: 2024-12-26

    Position:
    POST-RELEASE

    Description:
    Increments the future patch version by one after a successful release process is completed.
*/

// Read the project.toml file from the real file system
let projectData = HEMTT_RFS.join(".hemtt").join("project.toml").open_file().read();

// Get the current and next build version
let prefix = "patch = ";
let current = HEMTT.project().version().patch();
let next = current + 1;

// Replace the current patch version with the incremented patch version
projectData.replace(prefix + current.to_string(), prefix + next.to_string());

// Write the modified contents to the real file system
HEMTT_RFS.join(".hemtt").join("project.toml").create_file().write(projectData);
print("Incremented future patch version from " + current.to_string() + " to " + next.to_string());
