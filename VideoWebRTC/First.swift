

import Foundation
import WebRTC

class First {
    
    
    
    private let config = Config.default
    
     func buildSignalingClient() -> SignalingClient {
        
         debugPrint("this is the first class")

        let webSocketProvider: WebSocketProvider
        
        if #available(iOS 13.0, *) {
            webSocketProvider = NativeWebSocket(url: self.config.signalingServerUrl)
        } else {
            webSocketProvider = StarscreamWebSocket(url: self.config.signalingServerUrl)
        }
        

        return SignalingClient(webSocket: webSocketProvider)
         
    }
}
