//
//  FridaManager.swift
//  XPCInterpose
//
//  Created by Spotlight Deveaux on 2023-05-15.
//

import Foundation
import Frida

public struct FridaManager {
    let manager = Frida.shared.deviceManager
    
    func testing() async throws {
        let devices = try await manager.enumerateDevices()
        for device in devices {
            print("Device name: \(device.name)")
        }
//        manager.enumerateDevices { result in
//            let devices = try! result()
//            // TODO: Error handling, whatnot
//            let localDevice = devices.filter { $0.kind == .local }.first!
//            localDevice.enumerateProcesses { result in
//                let processes = try! result()
//                print(processes)
//            }
//        }
    }
}
