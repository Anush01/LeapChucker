//
//  LeapChuckerInterceptor.swift
//  LeapChucker
//
//  Created by Anush on 08/08/25.
//


import Foundation

/// URLProtocol subclass that intercepts all URLSession requests
internal class LeapChuckerInterceptor: URLProtocol {
    private var startTime: Date?
    private var requestID: UUID?
    
    // MARK: - URLProtocol Implementation
    
    override class func canInit(with request: URLRequest) -> Bool {
        // Only intercept HTTP/HTTPS requests
        guard let url = request.url,
              let scheme = url.scheme?.lowercased(),
              scheme == "http" || scheme == "https" else {
            return false
        }
        
        // Avoid infinite loops by checking if we've already processed this request
        return property(forKey: "LeapChuckerProcessed", in: request) == nil
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // Create NSMutableURLRequest from URLRequest
        let mutableRequest = NSMutableURLRequest(url: request.url!,
                                               cachePolicy: request.cachePolicy,
                                               timeoutInterval: request.timeoutInterval)

        // Copy over the original request properties with proper optional handling
        mutableRequest.httpMethod = request.httpMethod ?? "GET"
        mutableRequest.allHTTPHeaderFields = request.allHTTPHeaderFields
        mutableRequest.httpBody = request.httpBody
        mutableRequest.httpBodyStream = request.httpBodyStream

        // Mark request as processed to avoid loops
        URLProtocol.setProperty(true, forKey: "LeapChuckerProcessed", in: mutableRequest)

        // Record start time and generate ID
        startTime = Date()
        requestID = UUID()

        // Log the request BEFORE creating the task (to capture the original request)
        logRequest(request)

        // Create a new session task to perform the actual request
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: mutableRequest as URLRequest) { [weak self] data, response, error in
            guard let self = self else { return }

            // Log the response
            self.logResponse(data: data, response: response, error: error)

            // Forward the response to the client
            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            } else {
                if let response = response {
                    self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                if let data = data {
                    self.client?.urlProtocol(self, didLoad: data)
                }
                self.client?.urlProtocolDidFinishLoading(self)
            }
        }

        task.resume()
    }
    
    override func stopLoading() {
        // Nothing to do here for our simple implementation
    }
    
    private func logRequest(_ request: URLRequest) {
        guard let requestID = requestID,
              let url = request.url?.absoluteString else { return }

        let method = request.httpMethod ?? "GET"
        let headers = request.allHTTPHeaderFields ?? [:]
        let body = extractRequestBody(from: request)

        let networkRequest = NetworkRequest(
            id: requestID,
            url: url,
            method: method,
            requestHeaders: headers,
            requestBody: body
        )

        // Use Task to call main actor method asynchronously
        Task { @MainActor in
            LeapChuckerLogger.shared.logRequest(networkRequest)
        }
    }

    /// Extract request body from either httpBody or httpBodyStream
    private func extractRequestBody(from request: URLRequest) -> Data? {
        // First try httpBody (most common case)
        if let httpBody = request.httpBody {
            return limitBodySize(httpBody)
        }

        // If httpBody is nil, try to read from httpBodyStream
        guard let bodyStream = request.httpBodyStream else {
            return nil
        }

        // Read data from the stream
        bodyStream.open()
        defer { bodyStream.close() }

        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }

        var data = Data()
        let maxBodySize = 1024 * 1024 // 1MB limit to prevent memory issues

        while bodyStream.hasBytesAvailable && data.count < maxBodySize {
            let remainingBytes = min(bufferSize, maxBodySize - data.count)
            let bytesRead = bodyStream.read(buffer, maxLength: remainingBytes)

            if bytesRead > 0 {
                data.append(buffer, count: bytesRead)
            } else if bytesRead < 0 {
                // Error occurred
                print("LeapChucker: Error reading from httpBodyStream: \(bodyStream.streamError?.localizedDescription ?? "Unknown error")")
                break
            } else {
                // End of stream
                break
            }
        }

        return data.isEmpty ? nil : data
    }

    /// Limit body size to prevent memory issues
    private func limitBodySize(_ data: Data) -> Data {
        let maxBodySize = 1024 * 1024 // 1MB limit
        if data.count > maxBodySize {
            print("LeapChucker: Request body truncated from \(data.count) bytes to \(maxBodySize) bytes")
            return data.prefix(maxBodySize)
        }
        return data
    }

    private func logResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard let requestID = requestID else { return }
        
        let duration = startTime.map { Date().timeIntervalSince($0) }
        let responseCode = (response as? HTTPURLResponse)?.statusCode
        let responseHeaders = (response as? HTTPURLResponse)?.allHeaderFields as? [String: String]
        let errorString = error?.localizedDescription
        
        // Use Task to call main actor method asynchronously
        Task { @MainActor in
            LeapChuckerLogger.shared.updateRequestWithResponse(
                id: requestID,
                responseCode: responseCode,
                responseHeaders: responseHeaders ?? [:],
                responseBody: data,
                duration: duration,
                error: errorString
            )
        }
    }
}

// MARK: - Registration Helper
extension LeapChuckerInterceptor {
    static func register() {
        URLProtocol.registerClass(LeapChuckerInterceptor.self)
    }
    
    static func unregister() {
        URLProtocol.unregisterClass(LeapChuckerInterceptor.self)
    }
}
