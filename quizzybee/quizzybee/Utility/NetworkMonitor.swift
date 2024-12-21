//
//  NetworkMonitor.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/26/24.
//

import SwiftUI
import Network

/// A class that monitors network connectivity status.
///
/// - Purpose:
///   - Uses `NWPathMonitor` to observe changes in network connectivity.
///   - Updates the `isConnected` property to reflect the current network status.
///   - Designed to be used with SwiftUI for real-time network status updates.
///
/// - Features:
///   - Monitors network connectivity in the background.
///   - Publishes changes to `isConnected` for reactive UI updates.
class NetworkMonitor: ObservableObject {
    /// The `NWPathMonitor` instance used to monitor network connectivity.
    private let monitor = NWPathMonitor()
    
    /// The `DispatchQueue` on which the network monitoring occurs.
    private let queue = DispatchQueue.global(qos: .background)
    
    /// A published property indicating whether the device is connected to a network.
    ///
    /// - `true`: The device has a network connection.
    /// - `false`: The device is not connected to a network.
    @Published var isConnected: Bool = true
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `NetworkMonitor` and starts monitoring the network.
    ///
    /// - The `isConnected` property is updated whenever the network status changes.
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    // MARK: - Deinitialization
    
    /// Cancels the network monitoring when the instance is deinitialized.
    ///
    /// - This ensures that the resources used by `NWPathMonitor` are properly released.
    deinit {
        monitor.cancel()
    }
}
