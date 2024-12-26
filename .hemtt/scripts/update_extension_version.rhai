/*
    Integrated AI Voice Control System
    File: update_extension_version.rhai
    Author: Asaayu
    Date: 2024-12-26

    Description:
    Updates the extension version in the AssemblyInfo.cs file, incrementing the build and patch versions if necessary.
*/

// Read the extension assembly information from the real file system
let assemblyInfoTemplate = HEMTT_RFS
    .join("extension")
    .join("Properties")
    .join("AssemblyInfo.template")
    .open_file()
    .read();

// Get the current version data
const currentVersionMajor = HEMTT.project().version().major();
const currentVersionMinor = HEMTT.project().version().minor();
let currentVersionPatch = HEMTT.project().version().patch();
let currentVersionBuild = HEMTT.project().version().build();

// Increment the build version by one if this is a build
if (HEMTT.is_build()) { currentVersionBuild += 1; }

// Increment the patch version by one if this is a release build
if (HEMTT.is_release()) { currentVersionPatch += 1; }

// Get the current year for the copyright notice
const currentYear = date("[year]");
const currentVersion = currentVersionMajor + "." + currentVersionMinor + "." + currentVersionPatch + "." + currentVersionBuild;

assemblyInfoTemplate.replace("__HEMTT_INSERT_YEAR__", currentYear);
assemblyInfoTemplate.replace("__HEMTT_INSERT_VERSION__", currentVersion);

// Write the modified contents to the real file system
HEMTT_RFS
    .join("extension")
    .join("Properties")
    .join("AssemblyInfo.cs")
    .create_file()
    .write(assemblyInfoTemplate);

print("Updated future extension version to \"" + currentVersion + "\" with copyright year \"" + currentYear + "\"");