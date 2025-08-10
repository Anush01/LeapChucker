//
//  RequestDetailView.swift
//  LeapChucker
//
//  Created by Anush on 08/08/25.
//


import SwiftUI

/// Detailed view showing complete request and response information
public struct RequestDetailView: View {
    let request: NetworkRequest
    
    @State private var selectedSection: DetailSection = .overview
    @State private var showingShareSheet = false
    
    public init(request: NetworkRequest) {
        self.request = request
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Section picker
            sectionPicker
            
            // Content
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    switch selectedSection {
                    case .overview:
                        overviewSection
                    case .request:
                        requestSection
                    case .response:
                        responseSection
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Request Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingShareSheet = true }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [generateShareText()])
        }
    }
    
    // MARK: - Section Picker
    private var sectionPicker: some View {
        Picker("Section", selection: $selectedSection) {
            ForEach(DetailSection.allCases, id: \.self) { section in
                Text(section.title).tag(section)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Status card
            statusCard
            
            // Basic info
            InfoCard(title: "Request Info") {
                InfoRow(label: "URL", value: request.url)
                InfoRow(label: "Method", value: request.method)
                InfoRow(label: "Timestamp", value: formatFullTimestamp(request.timestamp))
                if let duration = request.duration {
                    InfoRow(label: "Duration", value: request.formattedDuration)
                }
            }
            
            // Response info (if available)
            if request.responseCode != nil || request.error != nil {
                InfoCard(title: "Response Info") {
                    if let code = request.responseCode {
                        InfoRow(label: "Status Code", value: "\(code)")
                        InfoRow(label: "Status", value: httpStatusText(code))
                    }
                    if let error = request.error {
                        InfoRow(label: "Error", value: error)
                    }
                }
            }
        }
    }
    
    // MARK: - Request Section  
    private var requestSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            InfoCard(title: "Request Headers") {
                if request.requestHeaders.isEmpty {
                    Text("No headers")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    ForEach(Array(request.requestHeaders.sorted(by: { $0.key < $1.key })), id: \.key) { key, value in
                        InfoRow(label: key, value: value)
                    }
                }
            }
            
            InfoCard(title: "Request Body") {
                if let bodyString = request.requestBodyString {
                    CodeBlock(content: bodyString)
                } else {
                    Text("No body")
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
        }
    }
    
    // MARK: - Response Section
    private var responseSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            InfoCard(title: "Response Headers") {
                if let headers = request.responseHeaders, !headers.isEmpty {
                    ForEach(Array(headers.sorted(by: { $0.key < $1.key })), id: \.key) { key, value in
                        InfoRow(label: key, value: value)
                    }
                } else {
                    Text("No headers")
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
            
            InfoCard(title: "Response Body") {
                if let bodyString = request.responseBodyString {
                    CodeBlock(content: bodyString)
                } else {
                    Text("No body")
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
        }
    }
    
    // MARK: - Status Card
    private var statusCard: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(request.statusCategory.displayColor == "green" ? .green :
                      request.statusCategory.displayColor == "yellow" ? .yellow :
                      request.statusCategory.displayColor == "red" ? .red : .gray)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(statusTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(statusSubtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var statusTitle: String {
        if let error = request.error {
            return "Request Failed"
        } else if let code = request.responseCode {
            return "Response \(code)"
        } else {
            return "Request Pending"
        }
    }
    
    private var statusSubtitle: String {
        if let error = request.error {
            return error
        } else if let code = request.responseCode {
            return httpStatusText(code)
        } else {
            return "Waiting for response..."
        }
    }
    
    // MARK: - Helper Methods
    private func formatFullTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
    
    private func httpStatusText(_ code: Int) -> String {
        switch code {
        case 200: return "OK"
        case 201: return "Created"
        case 204: return "No Content"
        case 400: return "Bad Request"
        case 401: return "Unauthorized"
        case 403: return "Forbidden"
        case 404: return "Not Found"
        case 500: return "Internal Server Error"
        case 502: return "Bad Gateway"
        case 503: return "Service Unavailable"
        default: return "HTTP \(code)"
        }
    }
    
    private func generateShareText() -> String {
        var text = """
        LeapChucker Request Details
        
        URL: \(request.url)
        Method: \(request.method)
        Timestamp: \(formatFullTimestamp(request.timestamp))
        """
        
        if let code = request.responseCode {
            text += "\nStatus Code: \(code)"
        }
        
        if let duration = request.duration {
            text += "\nDuration: \(request.formattedDuration)"
        }
        
        if let error = request.error {
            text += "\nError: \(error)"
        }
        
        return text
    }
}

// MARK: - Detail Section Enum
private enum DetailSection: CaseIterable {
    case overview
    case request
    case response
    
    var title: String {
        switch self {
        case .overview: return "Overview"
        case .request: return "Request"
        case .response: return "Response"
        }
    }
}

// MARK: - Supporting Views
private struct InfoCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            content
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(.bottom, 4)
    }
}

private struct CodeBlock: View {
    let content: String
    
    var body: some View {
        ScrollView {
            Text(content)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color(UIColor.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .frame(maxHeight: 300)
    }
}

// MARK: - Share Sheet
private struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
