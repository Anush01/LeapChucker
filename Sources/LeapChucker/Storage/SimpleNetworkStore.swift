//
//  SimpleNetworkStore.swift
//  LeapChucker
//
//  Created by Anush on 08/08/25.
//


import Foundation
import Combine

/// Simple file-based storage for network requests - no Core Data needed!
@MainActor
internal class SimpleNetworkStore: ObservableObject, Sendable {
    static let shared = SimpleNetworkStore()
    
    @Published private(set) var requests: [NetworkRequest] = []
    private let maxRequestCount = 100
    
    // File URL for persistent storage
    private let fileURL: URL
    
    private init() {
        // Store in app's documents directory
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsPath.appendingPathComponent("LeapChuckerRequests.json")
        
        // Load existing requests on init
        loadRequests()
    }
    
    // MARK: - Public Interface
    
    /// Save a new network request
    func saveRequest(_ request: NetworkRequest) {
        DispatchQueue.main.async {
            // Add new request at the beginning (newest first)
            self.requests.insert(request, at: 0)
            
            // Cleanup old requests if we exceed max count
            if self.requests.count > self.maxRequestCount {
                self.requests = Array(self.requests.prefix(self.maxRequestCount))
            }
            
            self.persistRequests()
        }
    }
    
    /// Update existing request with response data
    func updateRequest(id: UUID, responseCode: Int?, responseHeaders: [String: String], responseBody: Data?, duration: TimeInterval?, error: String?) {
        DispatchQueue.main.async {
            guard let index = self.requests.firstIndex(where: { $0.id == id }) else { return }
            
            let existingRequest = self.requests[index]
            let updatedRequest = NetworkRequest(
                id: existingRequest.id,
                url: existingRequest.url,
                method: existingRequest.method,
                timestamp: existingRequest.timestamp,
                requestHeaders: existingRequest.requestHeaders,
                requestBody: existingRequest.requestBody,
                responseCode: responseCode,
                responseHeaders: responseHeaders,
                responseBody: responseBody,
                duration: duration,
                error: error
            )
            
            self.requests[index] = updatedRequest
            self.persistRequests()
        }
    }
    
    /// Get all requests (already sorted by timestamp, newest first)
    func getAllRequests() -> [NetworkRequest] {
        return requests
    }
    
    /// Clear all stored requests
    func clearAllRequests() {
        DispatchQueue.main.async {
            self.requests.removeAll()
            self.persistRequests()
        }
    }
    
    /// Filter requests by search term
    func filterRequests(searchText: String) -> [NetworkRequest] {
        guard !searchText.isEmpty else { return requests }
        
        return requests.filter { request in
            request.url.localizedCaseInsensitiveContains(searchText) ||
            request.method.localizedCaseInsensitiveContains(searchText) ||
            (request.responseCode?.description.contains(searchText) ?? false)
        }
    }
    
    // MARK: - Private Methods
    
    private func loadRequests() {
        do {
            let data = try Data(contentsOf: fileURL)
            let decodedRequests = try JSONDecoder().decode([NetworkRequest].self, from: data)
            
            DispatchQueue.main.async {
                // Sort by timestamp, newest first
                self.requests = decodedRequests.sorted { $0.timestamp > $1.timestamp }
                
                // Ensure we don't exceed max count
                if self.requests.count > self.maxRequestCount {
                    self.requests = Array(self.requests.prefix(self.maxRequestCount))
                    self.persistRequests() // Save the trimmed list
                }
            }
        } catch {
            // File doesn't exist or couldn't be decoded - start fresh
            print("LeapChucker: No existing requests found or failed to load: \(error)")
        }
    }
    
    private func persistRequests() {
        do {
            let data = try JSONEncoder().encode(requests)
            try data.write(to: fileURL)
        } catch {
            print("LeapChucker: Failed to save requests: \(error)")
        }
    }
}

// MARK: - Background Queue Operations
extension SimpleNetworkStore {
    /// Save request from background thread (used by interceptor)
    func saveRequestAsync(_ request: NetworkRequest) {
        // This will automatically dispatch to main queue in saveRequest
        saveRequest(request)
    }
    
    /// Update request from background thread (used by interceptor)
    func updateRequestAsync(id: UUID, responseCode: Int?, responseHeaders: [String: String], responseBody: Data?, duration: TimeInterval?, error: String?) {
        // This will automatically dispatch to main queue in updateRequest
        updateRequest(id: id, responseCode: responseCode, responseHeaders: responseHeaders, responseBody: responseBody, duration: duration, error: error)
    }
}
