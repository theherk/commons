// alert.swift - Display text in a minimal borderless window.
// Usage: alert <message>
// Follows system theme. Just text and an OK button.

import AppKit

guard CommandLine.arguments.count >= 2 else {
    fputs("Usage: alert <message>\n", stderr)
    exit(1)
}

let message = CommandLine.arguments.dropFirst().joined(separator: " ")

let app = NSApplication.shared
app.setActivationPolicy(.regular)

let windowWidth: CGFloat = 520
let padding: CGFloat = 24

// Message label
let messageField = NSTextField(wrappingLabelWithString: message)
messageField.font = NSFont.systemFont(ofSize: 18)
messageField.textColor = .labelColor
messageField.translatesAutoresizingMaskIntoConstraints = false
messageField.preferredMaxLayoutWidth = windowWidth - (padding * 2)

// OK button
let button = NSButton(title: "OK", target: nil, action: #selector(NSApplication.terminate(_:)))
button.bezelStyle = .rounded
button.keyEquivalent = "\r"
button.translatesAutoresizingMaskIntoConstraints = false

// Container
let contentView = NSView()
contentView.addSubview(messageField)
contentView.addSubview(button)

NSLayoutConstraint.activate([
    messageField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
    messageField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
    messageField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

    button.topAnchor.constraint(equalTo: messageField.bottomAnchor, constant: 20),
    button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
    button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
])

// Size the content
messageField.sizeToFit()
let contentHeight = padding + messageField.fittingSize.height + 20
    + button.intrinsicContentSize.height + padding

let frame = NSRect(x: 0, y: 0, width: windowWidth, height: contentHeight)
let window = NSWindow(contentRect: frame, styleMask: [.titled, .fullSizeContentView], backing: .buffered, defer: false)
window.titlebarAppearsTransparent = true
window.titleVisibility = .hidden
window.isMovableByWindowBackground = true
window.contentView = contentView
window.center()
window.makeKeyAndOrderFront(nil)

app.activate(ignoringOtherApps: true)
app.run()
