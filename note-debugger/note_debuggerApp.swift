//
//  note_debuggerApp.swift
//  note-debugger
//
//  Created by Jonathan Duran on 06/08/2025.
//

import SwiftUI
import Pulse
import PulseUI

#if DEBUG
import PulseProxy
#endif

@main
struct note_debuggerApp: App {
    
    init() {
        #if DEBUG
            print("DEBUG")
            NetworkLogger.enableProxy()
//            let session: URLSessionProtocol = URLSessionProxy(configuration: .default)
            RemoteLogger.shared.isAutomaticConnectionEnabled = true
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
