//
//  NetworkRequest.swift
//  LeapChucker
//
//  Created by Anush on 08/08/25.
//

import Foundation

/// Represents a captured network request/response pair
public struct NetworkRequest: Identifiable, Codable, Hashable {
    public let id: UUID
    public let url: String
    public let method: String
    public let timestamp: Date
    public let requestHeaders: [String: String]
    public let requestBody: Data?
    
    // Response data (optional - set when response is received)
    public let responseCode: Int?
    public let responseHeaders: [String: String]?
    public let responseBody: Data?
    public let duration: TimeInterval?
    public let error: String?
    
    public init(
        id: UUID = UUID(),
        url: String,
        method: String,
        timestamp: Date = Date(),
        requestHeaders: [String: String] = [:],
        requestBody: Data? = nil,
        responseCode: Int? = nil,
        responseHeaders: [String: String]? = nil,
        responseBody: Data? = nil,
        duration: TimeInterval? = nil,
        error: String? = nil
    ) {
        self.id = id
        self.url = url
        self.method = method
        self.timestamp = timestamp
        self.requestHeaders = requestHeaders
        self.requestBody = requestBody
        self.responseCode = responseCode
        self.responseHeaders = responseHeaders
        self.responseBody = responseBody
        self.duration = duration
        self.error = error
    }
    
    // MARK: - Hashable Conformance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: NetworkRequest, rhs: NetworkRequest) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Convenience Extensions
extension NetworkRequest {
    /// Status category for UI color coding
    public var statusCategory: StatusCategory {
        guard let code = responseCode else { return .pending }
        
        switch code {
        case 200..<300: return .success
        case 300..<400: return .redirect
        case 400..<500: return .clientError
        case 500..<600: return .serverError
        default: return .unknown
        }
    }
    
    /// Formatted request body as string (JSON formatted if possible)
    public var requestBodyString: String? {
        guard let data = requestBody else { return nil }
        return formatData(data)
    }
    
    /// Formatted response body as string (JSON formatted if possible)
    public var responseBodyString: String? {
        guard let data = responseBody else { return nil }
        return formatData(data)
    }
    
    /// Short URL for list display (removes query parameters and truncates)
    public var shortURL: String {
        guard let urlComponents = URLComponents(string: url) else { return url }
        let path = urlComponents.path.isEmpty ? "/" : urlComponents.path
        return path.count > 50 ? String(path.prefix(47)) + "..." : path
    }
    
    /// Duration formatted as string
    public var formattedDuration: String {
        guard let duration = duration else { return "-" }
        if duration < 1 {
            return String(format: "%.0fms", duration * 1000)
        } else {
            return String(format: "%.2fs", duration)
        }
    }
    
    private func formatData(_ data: Data) -> String {
        // Try to format as JSON first
        if let jsonObject = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let jsonString = String(data: prettyData, encoding: .utf8) {
            return jsonString
        }
        
        // Fallback to plain string
        return String(data: data, encoding: .utf8) ?? "<Binary Data>"
    }
}

// MARK: - Status Category
public enum StatusCategory {
    case pending
    case success
    case redirect
    case clientError
    case serverError
    case unknown
    
    public var displayColor: String {
        switch self {
        case .pending: return "gray"
        case .success: return "green"
        case .redirect: return "yellow"
        case .clientError, .serverError: return "red"
        case .unknown: return "orange"
        }
    }
}
