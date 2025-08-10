//
//  LeapChuckerExports.swift
//  LeapChucker
//
//  Created by Anush on 08/08/25.
//

import SwiftUI

// MARK: - Public Exports
// This file provides convenient public exports for LeapChucker

/// Main logger instance - convenient shorthand for LeapChuckerLogger.shared
@MainActor
public let LeapChucker = LeapChuckerLogger.shared
