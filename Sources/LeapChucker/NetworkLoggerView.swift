//
//  NetworkLoggerView.swift
//  LeapChucker
//
//  Created by Anush on 08/08/25.
//

import SwiftUI

/// Main SwiftUI view displaying all captured network requests
public struct NetworkLoggerView: View {
    @StateObject private var store = SimpleNetworkStore.shared
    @State private var searchText = ""
    @State private var selectedRequest: NetworkRequest?
    @State private var showingClearAlert = false
    
    private var filteredRequests: [NetworkRequest] {
        store.filterRequests(searchText: searchText)
    }
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                searchBar
                
                // Request list
                requestList
            }
            .navigationTitle("Network Logger")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All Logs") {
                        store.clearAllRequests()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search requests...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    // MARK: - Request List
    private var requestList: some View {
        Group {
            if filteredRequests.isEmpty {
                emptyState
            } else {
                List(filteredRequests) { request in
                    NavigationLink(
                        destination: RequestDetailView(request: request),
                        tag: request,
                        selection: $selectedRequest
                    ) {
                        NetworkLogRow(request: request)
                    }
                }
                .listStyle(PlainListStyle())
                
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "network")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                Text("No Network Requests")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Make some network requests in your app and they'll appear here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            VStack(spacing: 4) {
                Text("Status: \(LeapChuckerLogger.shared.isLoggingEnabled ? "Enabled" : "Disabled")")
                    .font(.caption)
                    .foregroundColor(LeapChuckerLogger.shared.isLoggingEnabled ? .green : .red)
                
                if !LeapChuckerLogger.shared.isLoggingEnabled {
                    Text("Call LeapChuckerLogger.shared.enable() to start logging")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
    }
}
