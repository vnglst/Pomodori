#!/bin/bash

# Generate app icon from SF Symbol - using a tomato
ICONSET="Pomodori/Assets.xcassets/AppIcon.appiconset"
mkdir -p "$ICONSET"

# Create a temporary Swift script to render the icon
cat > /tmp/render_icon.swift << 'SWIFT'
import Cocoa

let symbolName = "apple.meditate.circle.fill"
let size = CGSize(width: 1024, height: 1024)

// Create image from SF Symbol
if let symbol = NSImage(systemSymbolName: symbolName, accessibilityDescription: nil) {
    let rect = CGRect(origin: .zero, size: size)
    
    // Create bitmap representation
    guard let rep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                      pixelsWide: Int(size.width),
                                      pixelsHigh: Int(size.height),
                                      bitsPerSample: 8,
                                      samplesPerPixel: 4,
                                      hasAlpha: true,
                                      isPlanar: false,
                                      colorSpaceName: .deviceRGB,
                                      bytesPerRow: 0,
                                      bitsPerPixel: 0) else {
        print("Failed to create bitmap")
        exit(1)
    }
    
    // Configure symbol
    let config = NSImage.SymbolConfiguration(pointSize: 600, weight: .regular)
    let configuredSymbol = symbol.withSymbolConfiguration(config)
    
    // Draw
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    
    // Fill background with red (tomato color)
    NSColor(calibratedRed: 0.95, green: 0.25, blue: 0.15, alpha: 1.0).setFill()
    rect.fill()
    
    // Draw symbol centered with white color
    let whiteSymbol = configuredSymbol?.withSymbolConfiguration(
        NSImage.SymbolConfiguration(hierarchicalColor: .white)
    )
    whiteSymbol?.draw(in: CGRect(x: 212, y: 212, width: 600, height: 600))
    
    NSGraphicsContext.restoreGraphicsState()
    
    // Save
    if let data = rep.representation(using: .png, properties: [:]) {
        try? data.write(to: URL(fileURLWithPath: "/tmp/icon_1024.png"))
        print("Icon saved")
    }
}
SWIFT

# Run the script
swift /tmp/render_icon.swift

# Generate all required sizes from the 1024px version
sips -z 16 16 /tmp/icon_1024.png --out "$ICONSET/icon_16x16.png"
sips -z 32 32 /tmp/icon_1024.png --out "$ICONSET/icon_16x16@2x.png"
sips -z 32 32 /tmp/icon_1024.png --out "$ICONSET/icon_32x32.png"
sips -z 64 64 /tmp/icon_1024.png --out "$ICONSET/icon_32x32@2x.png"
sips -z 128 128 /tmp/icon_1024.png --out "$ICONSET/icon_128x128.png"
sips -z 256 256 /tmp/icon_1024.png --out "$ICONSET/icon_128x128@2x.png"
sips -z 256 256 /tmp/icon_1024.png --out "$ICONSET/icon_256x256.png"
sips -z 512 512 /tmp/icon_1024.png --out "$ICONSET/icon_256x256@2x.png"
sips -z 512 512 /tmp/icon_1024.png --out "$ICONSET/icon_512x512.png"
cp /tmp/icon_1024.png "$ICONSET/icon_512x512@2x.png"

# Create Contents.json
cat > "$ICONSET/Contents.json" << 'EOF'
{
  "images" : [
    {
      "filename" : "icon_16x16.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_16x16@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_32x32.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_32x32@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_128x128.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_128x128@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_256x256.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_256x256@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_512x512.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "512x512"
    },
    {
      "filename" : "icon_512x512@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "512x512"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "App icon generated!"
