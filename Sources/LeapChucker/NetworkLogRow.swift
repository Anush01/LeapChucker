//
//  NetworkLogRow.swift
//  LeapChucker
//
//  Created by Anush on 08/08/25.
//


import SwiftUI

/// Individual row component for displaying network request summary
internal struct NetworkLogRow: View {
    let request: NetworkRequest
    
    var body: some View {
        HStack(spacing: 12) {
            // Method badge
            methodBadge
            
            // Request details
            VStack(alignment: .leading, spacing: 4) {
                // URL
                Text(request.shortURL)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                // Status and timing info
                HStack(spacing: 8) {
                    statusIndicator
                    
                    Text(formatTimestamp(request.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if let duration = request.duration {
                        Text(request.formattedDuration)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.white)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Method Badge
    private var methodBadge: some View {
        Text(request.method)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(methodColor.opacity(0.2))
            .foregroundColor(methodColor)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    private var methodColor: Color {
        switch request.method.uppercased() {
        case "GET": return .blue
        case "POST": return .green
        case "PUT": return .orange
        case "DELETE": return .red
        case "PATCH": return .purple
        default: return .gray
        }
    }
    
    // MARK: - Status Indicator
    private var statusIndicator: some View {
        HStack(spacing: 4) {
            // Status dot
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            // Status code
            if let code = request.responseCode {
                Text("\(code)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(statusColor)
            } else if request.error != nil {
                Text("ERROR")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.red)
            } else {
                Text("PENDING")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var statusColor: Color {
        if request.error != nil {
            return .red
        }
        
        guard let code = request.responseCode else {
            return .gray
        }
        
        switch code {
        case 200..<300: return .green
        case 300..<400: return .yellow
        case 400..<500: return .orange
        case 500..<600: return .red
        default: return .gray
        }
    }
    
    // MARK: - Helper Methods
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            formatter.timeStyle = .medium
            formatter.dateStyle = .none
        } else {
            formatter.dateStyle = .short
            formatter.timeStyle = .short
        }
        
        return formatter.string(from: date)
    }
}

// MARK: - Preview
#if DEBUG
struct NetworkLogRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Success request
            NetworkLogRow(request: NetworkRequest(
                url: "https://api.example.com/users/123",
                method: "GET",
                responseCode: 200,
                responseHeaders: [:],
                responseBody: nil,
                duration: 0.245
            ))
            
            // Error request
            NetworkLogRow(request: NetworkRequest(
                url: "https://api.example.com/posts",
                method: "POST",
                responseCode: 404,
                responseHeaders: [:],
                responseBody: nil,
                duration: 1.2,
                error: "Not found"
            ))
            
            // Pending request
            NetworkLogRow(request: NetworkRequest(
                url: "https://api.example.com/upload/file",
                method: "POST"
            ))
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
