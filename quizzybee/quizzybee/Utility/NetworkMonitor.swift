//
//  NetworkMonitor.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/26/24.
//

import SwiftUI
import Network

/// A class that monitors network connectivity status.
/// - This class uses `NWPathMonitor` to observe changes in network connectivity and updates the `isConnected` property accordingly.
/// - It is an `ObservableObject` to allow SwiftUI views to react to changes in the network status.
class NetworkMonitor: ObservableObject {
    /// The NWPathMonitor instance used to monitor network connectivity.
    private let monitor = NWPathMonitor()
    
    /// The DispatchQueue on which the network monitoring takes place.
    private let queue = DispatchQueue.global(qos: .background)
    
    /// A published property that indicates whether the device is connected to a network.
    /// - `true`: The device has a network connection.
    /// - `false`: The device is not connected to a network.
    @Published var isConnected: Bool = true
    
    /// Initializes a new instance of `NetworkMonitor` and starts monitoring the network.
    /// - The `isConnected` property is updated whenever the network status changes.
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    /// Cancels the network monitoring when the instance is deinitialized.
    /// - This ensures that the resources used by `NWPathMonitor` are properly released.
    deinit {
        monitor.cancel()
    }
}
