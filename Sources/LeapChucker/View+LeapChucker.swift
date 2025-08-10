//
//  View+LeapChucker.swift
//  LeapChucker
//
//  Created by Anush on 08/08/25.
//

import SwiftUI

// MARK: - SwiftUI View Extension
extension View {
    /// Adds LeapChucker network logger to any SwiftUI view
    /// - Parameter isPresented: Binding to control when the logger is shown
    /// - Returns: View with attached network logger sheet
    public func leapChuckerLogger(isPresented: Binding<Bool>) -> some View {
        self.sheet(isPresented: isPresented) {
            NetworkLoggerView()
        }
    }
    
    /// Adds LeapChucker with shake-to-show functionality
    /// - Returns: View that shows network logger when device is shaken
    public func leapChuckerShakeToShow() -> some View {
        self.modifier(ShakeToShowLeapChucker())
    }
    
    public func leapChuckerProgrammatic() -> some View {
            self.modifier(ProgrammaticLeapChucker())
        }

    
    
}

@MainActor
public class LeapChuckerPresenter: ObservableObject, Sendable {
    public static let shared = LeapChuckerPresenter()
    @Published public var isPresented = false
    
    private init() {}
    
    /// Show the LeapChucker network logger
    public func show() {
        isPresented = true
    }
    
    /// Hide the LeapChucker network logger
    public func hide() {
        isPresented = false
    }
    
    /// Toggle the LeapChucker network logger visibility
    public func toggle() {
        isPresented.toggle()
    }
}


// MARK: - Programmatic Modifier
private struct ProgrammaticLeapChucker: ViewModifier {
    @StateObject private var presenter = LeapChuckerPresenter.shared
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $presenter.isPresented) {
                NetworkLoggerView()
            }
    }
}

// MARK: - Shake Detection Modifier
private struct ShakeToShowLeapChucker: ViewModifier {
    @State private var showingLogger = false
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                showingLogger = true
            }
            .sheet(isPresented: $showingLogger) {
                NetworkLoggerView()
            }
    }
}

// MARK: - UIDevice Shake Extension
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

// MARK: - UIWindow Shake Detection
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

// MARK: - Debug Menu View
/// A floating debug button that can be added to any view for easy access
public struct LeapChuckerDebugButton: View {
    @State private var showingLogger = false
    @State private var position = CGPoint(x: 50, y: 100)
    
    public init() {}
    
    public var body: some View {
        Button(action: {
            showingLogger = true
        }) {
            Image(systemName: "network")
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .position(position)
        .gesture(
            DragGesture()
                .onChanged { value in
                    position = value.location
                }
        )
        .sheet(isPresented: $showingLogger) {
            NetworkLoggerView()
        }
    }
}

// MARK: - App Integration Helper
@MainActor
public struct LeapChuckerApp: Sendable {
    /// Quick setup method to enable logging and provide UI access
    /// Call this in your App's init() or main view's onAppear
    public static func setup() {
        LeapChuckerLogger.shared.enable()
    }
    
    /// Setup with custom configuration
    public static func setup(configuration: LeapChuckerLogger.Configuration) {
        LeapChuckerLogger.shared.configure(configuration)
        LeapChuckerLogger.shared.enable()
    }
}
