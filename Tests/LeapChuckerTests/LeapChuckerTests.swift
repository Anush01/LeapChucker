import XCTest
@testable import LeapChucker

final class LeapChuckerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Reset state before each test
    }
    
    override func tearDown() {
        super.tearDown()
        // Clean up after each test
    }
    
    func testLeapChuckerLoggerInitialization() {
        // Test that the shared logger instance can be created
        let logger = LeapChuckerLogger.shared
        XCTAssertNotNil(logger)
    }
    
    func testNetworkRequestModel() {
        // Test NetworkRequest model creation
        let requestId = UUID()
        let url = "https://api.example.com/test"
        let method = "GET"
        let headers = ["Content-Type": "application/json"]
        
        let networkRequest = NetworkRequest(
            id: requestId,
            url: url,
            method: method,
            requestHeaders: headers,
            requestBody: nil
        )
        
        XCTAssertEqual(networkRequest.id, requestId)
        XCTAssertEqual(networkRequest.url, url)
        XCTAssertEqual(networkRequest.method, method)
        XCTAssertEqual(networkRequest.requestHeaders, headers)
        XCTAssertNil(networkRequest.requestBody)
        XCTAssertNil(networkRequest.responseCode)
    }
    
    func testConfigurationDefaults() {
        // Test default configuration values
        let config = LeapChuckerLogger.Configuration.default
        
        XCTAssertEqual(config.maxRequestCount, 100)
        XCTAssertEqual(config.maxBodySize, 1024 * 1024) // 1MB
    }
    
    func testCustomConfiguration() {
        // Test custom configuration creation
        let customConfig = LeapChuckerLogger.Configuration(
            maxRequestCount: 200,
            maxBodySize: 2 * 1024 * 1024
        )
        
        XCTAssertEqual(customConfig.maxRequestCount, 200)
        XCTAssertEqual(customConfig.maxBodySize, 2 * 1024 * 1024)
    }
    
    func testURLSessionConfigurationSetup() {
        // Test that URLSession configuration can be modified
        let logger = LeapChuckerLogger.shared
        let originalConfig = URLSessionConfiguration.default
        
        let modifiedConfig = logger.configureURLSessionConfiguration(originalConfig)
        
        XCTAssertNotNil(modifiedConfig.protocolClasses)
        XCTAssertTrue(modifiedConfig.protocolClasses?.contains { $0 == LeapChuckerInterceptor.self } ?? false)
    }
    
    func testLeapChuckerPresenterInitialization() {
        // Test that the presenter can be initialized
        let presenter = LeapChuckerPresenter.shared
        XCTAssertNotNil(presenter)
        XCTAssertFalse(presenter.isPresented)
    }
    
    // Note: More comprehensive tests would require a test app environment
    // These basic tests verify the core components can be instantiated
}
