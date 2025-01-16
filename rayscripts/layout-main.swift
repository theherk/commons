#!/usr/bin/swift

import Cocoa

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Layout Main
// @raycast.mode compact

// Optional parameters:
// @raycast.icon 📐

// Documentation:
// @raycast.description Opens applications and position them.
// @raycast.author theherk
// @raycast.authorURL https://raycast.com/theherk

// Dimensions values are from 0 to 1 as a function of all available space.
struct Dimensions {
    let xoff: Float // x offset; negative is from right
    let yoff: Float // y offset; negative is from bottom
    let width: Float
    let height: Float
}

struct App {
    let id: String
    let windowTitle: String?  // Optional window title to match specific windows
    let main: Dimensions
    let wide: Dimensions
}

struct Configuration {
    let apps: [App]
}

func launchApp(_ bundleId: String) {
    guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId) else {
        return
    }

    let config = NSWorkspace.OpenConfiguration()
    NSWorkspace.shared.openApplication(at: appURL, configuration: config) { app, error in
        if let error = error {
            print("Error launching \(bundleId): \(error)")
        }
    }
}

func setWindowFrame(for bundleId: String, windowTitle: String?, frame: CGRect) {
    guard let app = NSRunningApplication.runningApplications(withBundleIdentifier: bundleId).first else {
        print("Failed to find application for \(bundleId)")
        return
    }

    let pid = app.processIdentifier

    // Get the AXUIElement for the application
    let appRef = AXUIElementCreateApplication(pid)

    // Get all windows
    var value: CFTypeRef?
    AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute as CFString, &value)
    guard let windowsArray = value as? [AXUIElement] else { return }

    // Find the matching window
    for window in windowsArray {
        var titleValue: CFTypeRef?
        AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &titleValue)

        if let windowTitle = windowTitle {
            // If windowTitle is specified, only match windows with that title
            if let currentTitle = titleValue as? String,
               currentTitle.contains(windowTitle) {
                // Set position
                var point = CGPoint(x: frame.origin.x, y: frame.origin.y)
                AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, AXValueCreate(.cgPoint, &point)!)

                // Set size
                var size = CGSize(width: frame.size.width, height: frame.size.height)
                AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, AXValueCreate(.cgSize, &size)!)

                break
            }
        } else {
            // If no windowTitle specified, affect first window (original behavior)
            // Set position
            var point = CGPoint(x: frame.origin.x, y: frame.origin.y)
            AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, AXValueCreate(.cgPoint, &point)!)

            // Set size
            var size = CGSize(width: frame.size.width, height: frame.size.height)
            AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, AXValueCreate(.cgSize, &size)!)

            break
        }
    }
}

let apps = [
    App(
        id: "com.microsoft.teams2",
        windowTitle: nil,
        main: Dimensions(xoff: 0, yoff: 0, width: 1, height: 1),
        wide: Dimensions(xoff: 0.1, yoff: 0, width: 0.3, height: 1)
    ),
    App(
        id: "com.tinyspeck.slackmacgap",
        windowTitle: nil,
        main: Dimensions(xoff: 0, yoff: 0, width: 1, height: 1),
        wide: Dimensions(xoff: -0.1, yoff: 0, width: 0.5, height: 1)
    ),
    App(
        id: "md.obsidian",
        windowTitle: "brain",
        main: Dimensions(xoff: 0, yoff: 0, width: 1, height: 1),
        wide: Dimensions(xoff: 0.1, yoff: 0, width: 0.4, height: 1)
    ),
    App(
        id: "md.obsidian",
        windowTitle: "dnbrain",
        main: Dimensions(xoff: 0, yoff: 0, width: 1, height: 1),
        wide: Dimensions(xoff: -0.1, yoff: 0, width: 0.4, height: 1)
    )
]

let config = Configuration(apps: apps)

// Get screen dimensions
let screenFrame = NSScreen.main?.frame ?? CGRect(x: 0, y: 0, width: 1920, height: 1080)
let isUltrawide = screenFrame.width == 2560 && screenFrame.height == 1080

// Check and launch apps if needed
var appsToWaitFor: [String] = []
for app in config.apps {
    let isRunning = NSRunningApplication.runningApplications(withBundleIdentifier: app.id).first != nil
    if !isRunning {
        launchApp(app.id)
        appsToWaitFor.append(app.id)
    }
}

// Wait for apps to launch if needed
if !appsToWaitFor.isEmpty {
    Thread.sleep(forTimeInterval: 1.0)
}

// Set window positions based on screen resolution
for app in config.apps {
    let dimensions = isUltrawide ? app.wide : app.main

    // Calculate actual pixel values from relative dimensions
    let x = dimensions.xoff >= 0
        ? CGFloat(dimensions.xoff) * screenFrame.width
        : screenFrame.width - (CGFloat(abs(dimensions.xoff)) * screenFrame.width)
    let y = dimensions.yoff >= 0
        ? CGFloat(dimensions.yoff) * screenFrame.height
        : screenFrame.height - (CGFloat(abs(dimensions.yoff)) * screenFrame.height)
    let width = CGFloat(dimensions.width) * screenFrame.width
    let height = CGFloat(dimensions.height) * screenFrame.height

    let frame = CGRect(x: x, y: y, width: width, height: height)
    setWindowFrame(for: app.id, windowTitle: app.windowTitle, frame: frame)
}

// Focus the last app in the config
if let lastApp = config.apps.last,
   let app = NSRunningApplication.runningApplications(withBundleIdentifier: lastApp.id).first {
    app.activate(options: [])
}
