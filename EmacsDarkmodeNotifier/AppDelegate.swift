import Cocoa
import ScriptingBridge

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var observation: NSKeyValueObservation?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("Application did finish launching.")
        
        observation = NSApp.observe(\.effectiveAppearance) { (app, _) in
            app.effectiveAppearance.performAsCurrentDrawingAppearance {
                print("Notification received.")

                // Invoke your non-view code that needs to be aware of the
                // change in appearance.
                print("Dark mode detected, setting dark mode in emacs.")

                let task = Process()
                task.executableURL = URL(fileURLWithPath: "/Users/ashton/.nix-profile/bin/emacsclient")
                
                let appearanceDescription = app.effectiveAppearance.debugDescription.lowercased()

                if appearanceDescription.contains("darkaqua") {
                    print("Dark mode detected, setting dark mode in emacs.")
                    task.arguments = ["-e", "(set-ui-mode 'dark)"]
                } else {
                    print("Light mode detected, setting light mode in emacs.")
                    task.arguments = ["-e", "(set-ui-mode 'light)"]
                }

                do {
                    try task.run()
                    task.waitUntilExit()  // This is synchronous; replace it with appropriate code for async
                    if task.terminationStatus == 0 {
                        print("Successfully changed emacs mode to dark.")
                    } else {
                        print("Failed to change emacs mode.")
                    }
                } catch {
                    print("An error occurred: \(error)")
                }
            }
        }
    }
}
