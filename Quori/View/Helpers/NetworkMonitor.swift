//
//  NetworkMonitor.swift
//  Quori
//
//  Created by Bryan Danquah on 27/05/2023.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
                    DispatchQueue.main.async { // Ensure UI updates on the main queue
                        self?.isConnected = path.status == .satisfied
                    }
                }
                monitor.start(queue: queue)
    }
}
