using System.Reflection;
using System.Resources;
using System.Runtime.InteropServices;

[assembly: AssemblyTitle("Integrated Voice Control System Extension")]
[assembly: AssemblyDescription("A handler for Arma 3 to allow voice control of the game using Windows Speech Recognition.")]

#if WIN64 && DEBUG
[assembly: AssemblyConfiguration("x64 (64-bit) Debug")]
#elif WIN64
[assembly: AssemblyConfiguration("x64 (64-bit) Release")]
#elif DEBUG
[assembly: AssemblyConfiguration("x86 (32-bit) Debug")]
#else
[assembly: AssemblyConfiguration("x86 (32-bit) Release")]
#endif

[assembly: AssemblyCompany("Asaayu")]
[assembly: AssemblyProduct("Integrated AI Voice Control System")]
[assembly: AssemblyCopyright("Copyright © 2021 - 2024 Asaayu")]
[assembly: AssemblyTrademark("")]
[assembly: AssemblyCulture("")]

[assembly: ComVisible(false)]
[assembly: Guid("d0a23689-f3bd-434b-b341-3e99eefd46cd")]

[assembly: AssemblyVersion("2.0.0.3")]
[assembly: AssemblyFileVersion("2.0.0.3")]
[assembly: NeutralResourcesLanguage("en")]
