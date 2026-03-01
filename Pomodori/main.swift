import Cocoa
import AVFoundation

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timer: Timer?
    var remainingSeconds: Int = 30  // Will be set properly in applicationDidFinishLaunching
    var isFocusMode: Bool = true  // true = focus, false = break
    var isRunning: Bool = false
    
    // Timer durations - focus is variable, break is fixed
    var focusDuration = 25 * 60  // Default 25 minutes, can be changed
    let breakDuration = 5 * 60   // 5 minutes
    let focusDurations = [25, 35, 45, 60]  // Available focus duration options
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Initialize timer
        remainingSeconds = focusDuration
        
        NSApp.setActivationPolicy(.accessory)
        
        // Get the system status bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // Ensure we have a button
        guard let button = statusItem.button else {
            print("ERROR: Could not create status bar button")
            return
        }
        
        // Configure the button with tomato icon from Resources
        if let iconPath = Bundle.main.path(forResource: "tomato_menubar", ofType: "png") {
            button.image = NSImage(contentsOfFile: iconPath)
            button.image?.size = NSSize(width: 18, height: 18)
            // Keep original colors (not a template)
            button.image?.isTemplate = false
        }
        
        // Add click handler
        button.target = self
        button.action = #selector(statusBarButtonClicked(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        
        // Setup menu
        setupMenu()
        
        // Update display
        updateDisplay()
        
        print("Pomodori started - click the tomato icon to start")
    }
    
    func setupMenu() {
        let menu = NSMenu()
        
        // Start/Stop item
        let toggleTitle = isRunning ? "Stop Timer" : "Start Timer"
        let toggleItem = NSMenuItem(
            title: toggleTitle,
            action: #selector(toggleTimer),
            keyEquivalent: "s"
        )
        toggleItem.target = self
        menu.addItem(toggleItem)
        
        // Reset item
        let resetItem = NSMenuItem(
            title: "Reset",
            action: #selector(resetTimer),
            keyEquivalent: "r"
        )
        resetItem.target = self
        menu.addItem(resetItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Focus Duration submenu
        let durationMenu = NSMenu()
        for minutes in focusDurations {
            let durationItem = NSMenuItem(
                title: "\(minutes) minutes",
                action: #selector(setFocusDuration(_:)),
                keyEquivalent: ""
            )
            durationItem.target = self
            durationItem.tag = minutes
            if minutes == focusDuration / 60 {
                durationItem.state = NSControl.StateValue.on
            }
            durationMenu.addItem(durationItem)
        }
        let durationMenuItem = NSMenuItem(title: "Focus Duration", action: nil, keyEquivalent: "")
        durationMenuItem.submenu = durationMenu
        menu.addItem(durationMenuItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit item
        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(quit),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
    }
    
    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        
        if event.type == .rightMouseUp {
            // Right click - show menu
            statusItem.button?.performClick(nil)
        } else {
            // Left click - toggle timer
            toggleTimer()
        }
    }
    
    @objc func toggleTimer() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.tick()
        }
        updateIcon(active: true)
        updateDisplay()
        setupMenu()
        print("Timer started - \(isFocusMode ? "Focus" : "Break") mode")
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        updateIcon(active: false)
        updateDisplay()
        setupMenu()
        print("Timer stopped")
    }
    
    @objc func resetTimer() {
        stopTimer()
        isFocusMode = true
        remainingSeconds = focusDuration
        updateDisplay()
        print("Timer reset")
    }
    
    @objc func setFocusDuration(_ sender: NSMenuItem) {
        let minutes = sender.tag
        focusDuration = minutes * 60
        
        // If timer is not running, update remaining time immediately
        if !isRunning && isFocusMode {
            remainingSeconds = focusDuration
            updateDisplay()
        }
        
        setupMenu()
        print("Focus duration set to \(minutes) minutes")
    }
    
    func tick() {
        remainingSeconds -= 1
        
        if remainingSeconds <= 0 {
            timerFinished()
        } else {
            updateDisplay()
        }
    }
    
    func timerFinished() {
        stopTimer()
        
        if isFocusMode {
            // Focus time finished - show popup and start break
            showNotification(title: "Focus Complete!", message: "Great job! Time for a 5-minute break.")
            isFocusMode = false
            remainingSeconds = breakDuration
            
            // Auto-start break after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.startTimer()
            }
        } else {
            // Break finished - show popup and restart focus
            showNotification(title: "Break Complete!", message: "Break's over! Starting a new 25-minute focus session.")
            isFocusMode = true
            remainingSeconds = focusDuration
            
            // Auto-start next focus session after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.startTimer()
            }
        }
        
        updateDisplay()
    }
    
    func showNotification(title: String, message: String) {
        // Play a nice unobtrusive sound
        if let sound = NSSound(named: "Ping") {
            sound.play()
        }
        
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        
        // Make sure alert appears on top
        NSApp.activate(ignoringOtherApps: true)
        alert.runModal()
    }
    
    func updateDisplay() {
        if let button = statusItem.button {
            let minutes = remainingSeconds / 60
            let seconds = remainingSeconds % 60
            let timeString = String(format: "%d:%02d", minutes, seconds)
            button.title = isRunning ? " \(timeString)" : ""
        }
    }
    
    func updateIcon(active: Bool) {
        // Keep the same colored icon, just update the display
        // Color icons don't change based on active state
    }
    
    @objc func quit() {
        stopTimer()
        NSApplication.shared.terminate(nil)
    }
}

// Create and run the app
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
