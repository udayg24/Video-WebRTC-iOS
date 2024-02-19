

import SwiftUI

@main
struct VideoWebRTCApp: App {
    
    
    var body: some Scene {
        
        let config = Config.default
        let signalClient = self.buildSignalingClient()
        let webRTCClient = WebRTCClient(iceServers: config.webRTCIceServers)

        WindowGroup {
            MainView(webRTCClient: webRTCClient, signalClient: signalClient)
                .environmentObject(MainViewController(signalClient: signalClient, webRTCClient: webRTCClient))

        }

        
    }
    
    private let config = Config.default
    
     func buildSignalingClient() -> SignalingClient {
        
         debugPrint("this is the first class")
         debugPrint("Building Signaling Client with URL: \(self.config.signalingServerUrl)")
         
        // iOS 13 has native websocket support. For iOS 12 or lower we will use 3rd party library.
        let webSocketProvider: WebSocketProvider
        
        if #available(iOS 13.0, *) {
            webSocketProvider = NativeWebSocket(url: self.config.signalingServerUrl)
        } else {
            webSocketProvider = StarscreamWebSocket(url: self.config.signalingServerUrl)
        }
        

        return SignalingClient(webSocket: webSocketProvider)
         
    }
}
