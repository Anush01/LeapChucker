import Foundation

/// Main logger class that coordinates network interception and storage
@MainActor
public class LeapChuckerLogger: ObservableObject, Sendable {
    public static let shared = LeapChuckerLogger()
    
    private let store = SimpleNetworkStore.shared
    private var isEnabled = false
    
    private init() {}
    
    // MARK: - Public Interface
    
    /// Enable network request logging
    public func enable() {
        guard !isEnabled else { return }
        
        LeapChuckerInterceptor.register()
        isEnabled = true
        
        print("LeapChucker: Network logging enabled")
    }
    
    /// Get URLSessionConfiguration with LeapChucker enabled
        /// Use this for custom URLSession or third-party networking libraries
     nonisolated public func configureURLSessionConfiguration(_ configuration: URLSessionConfiguration = .default) -> URLSessionConfiguration {
            if var protocolClasses = configuration.protocolClasses {
                // Insert LeapChucker at the beginning to ensure it intercepts first
                protocolClasses.insert(LeapChuckerInterceptor.self, at: 0)
                configuration.protocolClasses = protocolClasses
            } else {
                configuration.protocolClasses = [LeapChuckerInterceptor.self]
            }
            return configuration
        }
    
    /// Disable network request logging
    public func disable() {
        guard isEnabled else { return }
        
        LeapChuckerInterceptor.unregister()
        isEnabled = false
        
        print("LeapChucker: Network logging disabled")
    }
    
    /// Check if logging is currently enabled
    public var isLoggingEnabled: Bool {
        return isEnabled
    }
    
    /// Get all logged requests
    public func getAllRequests() -> [NetworkRequest] {
        return store.getAllRequests()
    }
    
    /// Clear all logged requests
    public func clearAllRequests() {
        store.clearAllRequests()
    }
    
    /// Export all requests as JSON data
    public func exportRequestsAsJSON() -> Data? {
        let requests = getAllRequests()
        return try? JSONEncoder().encode(requests)
    }
    
    /// Set maximum number of requests to keep (older requests will be automatically deleted)
    public func setMaxRequestCount(_ maxCount: Int) {
        // Note: Current implementation uses a fixed max of 100
        // This could be made configurable in the future
        print("LeapChucker: Max request count is currently fixed at 100")
    }
    
    // MARK: - Internal Interface (used by interceptor)
    
    internal func logRequest(_ request: NetworkRequest) {
        store.saveRequestAsync(request)
    }
    
    internal func updateRequestWithResponse(
        id: UUID,
        responseCode: Int?,
        responseHeaders: [String: String],
        responseBody: Data?,
        duration: TimeInterval?,
        error: String?
    ) {
        store.updateRequestAsync(
            id: id,
            responseCode: responseCode,
            responseHeaders: responseHeaders,
            responseBody: responseBody,
            duration: duration,
            error: error
        )
    }
}


extension LeapChuckerLogger {
    /// Configuration options for LeapChucker
    public struct Configuration: Sendable {
        public let maxRequestCount: Int
        public let maxBodySize: Int // Maximum size of request/response body to store (in bytes)
        
        public static let `default` = Configuration(
            maxRequestCount: 100,
            maxBodySize: 1024 * 1024 // 1MB
        )
        
        public init(maxRequestCount: Int = 100, maxBodySize: Int = 1024 * 1024) {
            self.maxRequestCount = maxRequestCount
            self.maxBodySize = maxBodySize
        }
    }
    
    /// Apply configuration settings
    public func configure(_ configuration: Configuration) {
        setMaxRequestCount(configuration.maxRequestCount)
        // Additional configuration can be added here in the future
    }
}
