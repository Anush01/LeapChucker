# LeapChucker 🚀

A lightweight, powerful network debugging library for iOS that intercepts and logs all network requests in your app. Perfect for debugging API calls, monitoring network performance, and troubleshooting connectivity issues during development.

## Features ✨

- **Zero Configuration**: Works out of the box with URLSession and most networking libraries
- **SwiftUI Integration**: Native SwiftUI views with search and filtering
- **Shake to Show**: Convenient shake gesture to open the network logger
- **Programmatic Control**: Show/hide the logger programmatically
- **Request/Response Details**: View headers, body, status codes, and timing
- **Persistent Storage**: Requests are saved locally and persist between app launches
- **Search & Filter**: Easily find specific requests with built-in search
- **Lightweight**: No external dependencies, minimal performance impact

## Installation 📦

### Swift Package Manager

Add LeapChucker to your project using Xcode:

1. Open your project in Xcode
2. Go to `File` → `Add Package Dependencies...`
3. Enter the repository URL: `https://github.com/Anush01/LeapChucker.git`
4. Click `Add Package`

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Anush01/LeapChucker.git", from: "1.0.0")
]
```

## Quick Start 🏃‍♂️

### 1. Enable Network Logging

In your App's `init()` or main view's `onAppear`:

```swift
import LeapChucker

@main
struct MyApp: App {
    init() {
        // Enable LeapChucker logging
        LeapChuckerApp.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 2. Add UI Integration

Choose one of these integration methods:

#### Option A: Shake to Show (Recommended)
```swift
import SwiftUI
import LeapChucker

struct ContentView: View {
    var body: some View {
        YourMainView()
            .leapChuckerShakeToShow() // Shake device to show logger
    }
}
```

#### Option B: Manual Control
```swift
import SwiftUI
import LeapChucker

struct ContentView: View {
    @State private var showLogger = false
    
    var body: some View {
        YourMainView()
            .leapChuckerLogger(isPresented: $showLogger)
            .toolbar {
                Button("Network Logs") {
                    showLogger = true
                }
            }
    }
}
```

#### Option C: Programmatic Control
```swift
import SwiftUI
import LeapChucker

struct ContentView: View {
    var body: some View {
        YourMainView()
            .leapChuckerProgrammatic()
            .onAppear {
                // Show logger programmatically
                LeapChuckerPresenter.shared.show()
            }
    }
}
```

## Advanced Usage 🔧

### Custom Configuration

```swift
import LeapChucker

let config = LeapChuckerLogger.Configuration(
    maxRequestCount: 200,    // Keep up to 200 requests
    maxBodySize: 2 * 1024 * 1024  // 2MB max body size
)

LeapChuckerApp.setup(configuration: config)
```

### Custom URLSession Integration

For custom URLSession or third-party networking libraries:

```swift
import LeapChucker

// Configure your URLSession
let configuration = URLSessionConfiguration.default
let configuredSession = LeapChuckerLogger.shared.configureURLSessionConfiguration(configuration)
let customSession = URLSession(configuration: configuredSession)
```

### Manual Control

```swift
import LeapChucker

// Enable/disable logging
LeapChuckerLogger.shared.enable()
LeapChuckerLogger.shared.disable()

// Show/hide logger UI
LeapChuckerPresenter.shared.show()
LeapChuckerPresenter.shared.hide()
LeapChuckerPresenter.shared.toggle()
```

## API Reference 📚

### LeapChuckerApp
- `setup()` - Quick setup with default configuration
- `setup(configuration:)` - Setup with custom configuration

### LeapChuckerLogger
- `enable()` - Enable network request interception
- `disable()` - Disable network request interception
- `configureURLSessionConfiguration(_:)` - Configure custom URLSession

### LeapChuckerPresenter
- `show()` - Show the network logger
- `hide()` - Hide the network logger
- `toggle()` - Toggle logger visibility

### SwiftUI View Extensions
- `.leapChuckerShakeToShow()` - Add shake-to-show functionality
- `.leapChuckerLogger(isPresented:)` - Manual logger control
- `.leapChuckerProgrammatic()` - Programmatic logger control

## Requirements 📋

- iOS 14.0+
- Swift 5.5+
- Xcode 13.0+

## How It Works 🔍

LeapChucker uses URLProtocol to intercept network requests made through URLSession. It captures:

- Request URL, method, headers, and body
- Response status code, headers, and body
- Request duration and timestamps
- Network errors

All data is stored locally on the device and never transmitted externally.

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## License 📄

LeapChucker is available under the MIT license. See the LICENSE file for more info.

## Support 💬

If you have any questions or issues, please open an issue on GitHub.

---

Made with ❤️ for iOS developers who love debugging their network calls!
