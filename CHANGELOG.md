# Changelog

All notable changes to LeapChucker will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-08-10

### Added
- Initial release of LeapChucker network debugging library
- URLProtocol-based network request interception
- SwiftUI-based network logger interface with search and filtering
- Shake-to-show functionality for easy access during development
- Programmatic control for showing/hiding the network logger
- Persistent local storage of network requests
- Support for custom URLSession configuration
- Request/response detail view with headers, body, and timing information
- Configurable maximum request count and body size limits
- Zero external dependencies
- iOS 14.0+ support
- Swift Package Manager support

### Features
- **Network Interception**: Automatically captures all URLSession requests
- **SwiftUI Integration**: Native SwiftUI views with `.leapChuckerShakeToShow()`, `.leapChuckerLogger()`, and `.leapChuckerProgrammatic()` modifiers
- **Search & Filter**: Built-in search functionality to find specific requests
- **Request Details**: View complete request/response information including:
  - URL, HTTP method, and status code
  - Request and response headers
  - Request and response body (with size limits)
  - Request duration and timestamps
  - Error information
- **Persistent Storage**: Requests are saved locally and persist between app launches
- **Memory Management**: Configurable limits to prevent excessive memory usage
- **Developer Experience**: Shake gesture support for quick access during development

### Technical Details
- Minimum iOS version: 14.0
- Swift version: 5.9+
- No external dependencies
- Thread-safe implementation with proper MainActor usage
- Efficient JSON-based local storage
- URLProtocol-based interception for broad compatibility

---

## Release Notes

### Version 1.0.0

This is the initial public release of LeapChucker, a lightweight network debugging library for iOS developers. LeapChucker provides an easy way to inspect network requests and responses during development without requiring external tools like Charles Proxy or Wireshark.

**Key Features:**
- Zero-configuration setup - works out of the box with URLSession
- Native SwiftUI interface with search and filtering
- Shake-to-show functionality for quick access
- Persistent storage of network requests
- Support for custom URLSession configurations
- Lightweight with no external dependencies

**Getting Started:**
1. Add LeapChucker to your project via Swift Package Manager
2. Call `LeapChuckerApp.setup()` in your app's initialization
3. Add `.leapChuckerShakeToShow()` to your main view
4. Shake your device to view captured network requests

**Perfect for:**
- API debugging during development
- Network performance monitoring
- Troubleshooting connectivity issues
- Understanding third-party SDK network behavior
- Learning and educational purposes

LeapChucker is designed to be developer-friendly with minimal setup required. It's perfect for debug builds and should not be included in production releases.

---

## Future Roadmap

Potential features for future releases:
- Export functionality for sharing network logs
- Advanced filtering options (by status code, method, etc.)
- Network performance metrics and analytics
- Integration with popular networking libraries
- macOS support for Mac Catalyst apps
- Custom UI themes and appearance options

---

## Contributing

We welcome contributions! Please see our contributing guidelines and feel free to submit issues and pull requests.

## License

LeapChucker is available under the MIT license. See the LICENSE file for more info.
