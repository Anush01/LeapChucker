//
//  MyApp.swift
//  LeapChucker
//
//  Created by Anush on 08/08/25.
//


import SwiftUI

// MARK: - Public Exports
// This file provides the main public interface for LeapChucker

/// Main logger instance - use this to enable/disable logging
@MainActor
public let LeapChucker = LeapChuckerLogger.shared

// MARK: - Quick Start Examples

/*
 
 // EXAMPLE 1: Basic Integration
 import LeapChucker
 
 @main
 struct MyApp: App {
     init() {
         LeapChuckerApp.setup() // Enable logging
     }
     
     var body: some Scene {
         WindowGroup {
             ContentView()
                 .leapChuckerShakeToShow() // Show logger on shake
         }
     }
 }
 
 // EXAMPLE 2: Manual Control
 struct ContentView: View {
     @State private var showLogger = false
     
     var body: some View {
         VStack {
             // Your app content
             
             Button("Show Network Logger") {
                 showLogger = true
             }
         }
         .leapChuckerLogger(isPresented: $showLogger)
         .onAppear {
             LeapChuckerLogger.shared.enable()
         }
     }
 }
 
 // EXAMPLE 3: Floating Debug Button
 struct DebugContentView: View {
     var body: some View {
         ZStack {
             // Your main content
             ContentView()
             
             // Floating debug button (only in debug builds)
             #if DEBUG
             LeapChuckerDebugButton()
             #endif
         }
     }
 }
 
 // EXAMPLE 4: Programmatic Access
 func inspectNetworkRequests() {
     let allRequests = LeapChuckerLogger.shared.getAllRequests()
     print("Captured \(allRequests.count) requests")
     
     // Export for sharing
     if let jsonData = LeapChuckerLogger.shared.exportRequestsAsJSON() {
         // Share or save the data
     }
     
     // Clear old requests
     LeapChuckerLogger.shared.clearAllRequests()
 }
 
 */
