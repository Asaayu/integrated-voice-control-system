/*
    Integrated AI Voice Control System
    File: 01_increment_future_patch_version.rhai
    Author: Asaayu
    Date: 2024-12-26

    Position:
    POST-RELEASE

    Description:
    Increments the future patch version by one after a successful release process is completed.
*/

// Read the project.toml file from the real file system
let projectData = HEMTT_RFS.join(".hemtt").join("project.toml").open_file().read();

// Increment both the future build and patch version
const buildPrefix = "build = ";
const buildCurrent = HEMTT.project().version().build();
const buildNext = buildCurrent + 1;

const patchPrefix = "patch = ";
const patchCurrent = HEMTT.project().version().patch();
const patchNext = patchCurrent + 1;

// Replace the current version with the incremented version
projectData.replace(buildPrefix + buildCurrent.to_string(), buildPrefix + buildNext.to_string());
projectData.replace(patchPrefix + patchCurrent.to_string(), patchPrefix + patchNext.to_string());

// Write the modified contents to the real file system
HEMTT_RFS.join(".hemtt").join("project.toml").create_file().write(projectData);

const finalVersion = HEMTT.project().version().to_string().split("-")[0].split(".");
print("Incremented future build version to " + finalVersion[0].to_string() + "." + finalVersion[1].to_string() + "." + patchNext.to_string() + "." + buildNext.to_string());
