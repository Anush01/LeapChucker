# LeapChucker Usage Examples

This document provides detailed examples of how to integrate and use LeapChucker in your iOS app.

## Basic Integration

### 1. Simple Setup with Shake-to-Show

```swift
import SwiftUI
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
                .leapChuckerShakeToShow() // Shake device to show logger
        }
    }
}
```

### 2. Manual Control with Button

```swift
import SwiftUI
import LeapChucker

struct ContentView: View {
    @State private var showNetworkLogger = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Your app content here
                Text("My App Content")
                
                Button("Show Network Logs") {
                    showNetworkLogger = true
                }
                .padding()
            }
            .navigationTitle("My App")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Debug") {
                        showNetworkLogger = true
                    }
                }
            }
        }
        .leapChuckerLogger(isPresented: $showNetworkLogger)
    }
}
```

### 3. Programmatic Control

```swift
import SwiftUI
import LeapChucker

struct ContentView: View {
    var body: some View {
        VStack {
            // Your app content
            Text("My App")
            
            Button("Show Network Logger") {
                LeapChuckerPresenter.shared.show()
            }
            
            Button("Hide Network Logger") {
                LeapChuckerPresenter.shared.hide()
            }
        }
        .leapChuckerProgrammatic() // Enable programmatic control
    }
}
```

## Advanced Configuration

### Custom Configuration

```swift
import LeapChucker

@main
struct MyApp: App {
    init() {
        // Custom configuration
        let config = LeapChuckerLogger.Configuration(
            maxRequestCount: 500,           // Keep up to 500 requests
            maxBodySize: 5 * 1024 * 1024   // 5MB max body size
        )
        
        LeapChuckerApp.setup(configuration: config)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .leapChuckerShakeToShow()
        }
    }
}
```

### Custom URLSession Integration

For apps using custom URLSession or third-party networking libraries:

```swift
import Foundation
import LeapChucker

class NetworkManager {
    private let session: URLSession
    
    init() {
        // Configure URLSession with LeapChucker
        let configuration = URLSessionConfiguration.default
        let configuredSession = LeapChuckerLogger.shared.configureURLSessionConfiguration(configuration)
        self.session = URLSession(configuration: configuredSession)
    }
    
    func makeRequest(url: URL) async throws -> Data {
        let (data, _) = try await session.data(from: url)
        return data
    }
}
```

### Alamofire Integration

```swift
import Alamofire
import LeapChucker

class NetworkService {
    private let session: Session
    
    init() {
        // Configure Alamofire with LeapChucker
        let configuration = URLSessionConfiguration.default
        let configuredSession = LeapChuckerLogger.shared.configureURLSessionConfiguration(configuration)
        
        self.session = Session(configuration: configuredSession)
    }
    
    func fetchData() {
        session.request("https://api.example.com/data")
            .responseJSON { response in
                // Handle response
            }
    }
}
```

## Debug-Only Integration

### Conditional Compilation

```swift
import SwiftUI
#if DEBUG
import LeapChucker
#endif

@main
struct MyApp: App {
    init() {
        #if DEBUG
        LeapChuckerApp.setup()
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                #if DEBUG
                .leapChuckerShakeToShow()
                #endif
        }
    }
}
```

### Debug Menu Integration

```swift
import SwiftUI
#if DEBUG
import LeapChucker
#endif

struct DebugMenuView: View {
    @State private var showNetworkLogger = false
    
    var body: some View {
        List {
            Section("Network Debugging") {
                Button("Show Network Logger") {
                    #if DEBUG
                    showNetworkLogger = true
                    #endif
                }
                
                Button("Clear Network Logs") {
                    #if DEBUG
                    // Clear logs if needed
                    #endif
                }
            }
        }
        .navigationTitle("Debug Menu")
        #if DEBUG
        .leapChuckerLogger(isPresented: $showNetworkLogger)
        #endif
    }
}
```

## Runtime Control

### Enable/Disable Logging

```swift
import LeapChucker

class SettingsManager {
    func toggleNetworkLogging(_ enabled: Bool) {
        if enabled {
            LeapChuckerLogger.shared.enable()
        } else {
            LeapChuckerLogger.shared.disable()
        }
    }
}
```

### Check Logging Status

```swift
import LeapChucker

func checkLoggingStatus() {
    let isEnabled = LeapChuckerLogger.shared.isLoggingEnabled
    print("Network logging is \(isEnabled ? "enabled" : "disabled")")
}
```

## Best Practices

1. **Debug Builds Only**: Consider enabling LeapChucker only in debug builds
2. **Memory Management**: Use reasonable `maxRequestCount` and `maxBodySize` values
3. **User Privacy**: Never ship with LeapChucker enabled in production builds
4. **Performance**: LeapChucker has minimal impact, but disable when not needed
5. **Integration**: Use shake-to-show for the best developer experience

## Troubleshooting

### Common Issues

1. **Requests not appearing**: Make sure `LeapChuckerApp.setup()` is called before making network requests
2. **Custom URLSession**: Use `configureURLSessionConfiguration()` for custom sessions
3. **Third-party libraries**: Configure the underlying URLSession used by the library
4. **Memory usage**: Adjust `maxRequestCount` and `maxBodySize` if needed

### Verification

```swift
// Verify LeapChucker is working
func testNetworkLogging() {
    // Make a test request
    URLSession.shared.dataTask(with: URL(string: "https://httpbin.org/get")!) { _, _, _ in
        // Check if request appears in LeapChucker
    }.resume()
}
```
