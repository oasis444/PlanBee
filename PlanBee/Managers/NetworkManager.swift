//
//  NetworkManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import Network

final class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    private var isConnected: Bool = false
    private var connectionType: ConnectionType = .unknown

    // 연결타입
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() { }

    // Network Monitoring 시작
    func startMonitoring() {
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = path.status == .satisfied
            self.getConnectionType(path)
            
            if self.isConnected == true {
                print("인터넷 연결!")
                // 연결됬을 때 & 서버에 업데이트 실패한것이 있을 때 동기화
            } else {
                print("인터넷 연결 끊김!")
            }
        }
    }
    
    // Network Monitoring 종료
    func stopMonitoring() {
        monitor.cancel()
    }
    
    // Network 연결 타입
    func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
