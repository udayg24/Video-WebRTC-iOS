

import Foundation
import WebRTC
import AVFoundation

class MainViewController: ObservableObject {
    
    @Published var mute: Bool = false
    @Published var speaker: Bool = false
    @Published var status: Bool = false
    @Published var localsdp: Bool = false
    @Published var remotesdp: Bool = false
    @Published var rtcstatus: String = "new"
    
 
    private let signalClient: SignalingClient
    private let webRTCClient: WebRTCClient

    private let config = Config.default
    

    init(signalClient: SignalingClient, webRTCClient: WebRTCClient) {
        self.signalClient = signalClient
        self.webRTCClient = webRTCClient
        self.webRTCClient.delegate = self
        self.signalClient.delegate = self
        self.signalClient.connect()
    }
    
    
    private var signalingConnected: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.signalingConnected {
                    self.status = true
                }
                else {
                    self.status = false
                }
            }
        }
    }
    

    func offerTapped() {
        self.webRTCClient.offer { sdp in
            self.localsdp = true
            self.signalClient.send(sdp: sdp)
        }
    }
    

    
    func answerTapped() {
        self.webRTCClient.answer { (localSdp) in
            self.localsdp = true
            self.signalClient.send(sdp: localSdp)
        }
    }

    
    func speakerTapped() {
        if self.speaker {
            self.webRTCClient.speakerOff()
        }
        else {
            self.webRTCClient.speakerOn()
        }
        self.speaker = !self.speaker
    }
    
    func muteTapped() {
        self.mute = !self.mute
        if self.mute {
            self.webRTCClient.muteAudio()
        }
        else {
            self.webRTCClient.unmuteAudio()
        }
    }
    
}

extension MainViewController: SignalClientDelegate {
    
    func signalClientDidConnect(_ signalClient: SignalingClient) {
        self.signalingConnected = true
    }
    
    func signalClientDidDisconnect(_ signalClient: SignalingClient) {
        self.signalingConnected = false
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription) {
        print("Received remote sdp")
        self.webRTCClient.set(remoteSdp: sdp) { (error) in
            self.remotesdp = true
        }
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate) {
        self.webRTCClient.set(remoteCandidate: candidate) { error in
            print("Received remote candidate")
        }
    }
    
}


extension MainViewController: WebRTCClientDelegate {
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {
        
    }
    
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        print("discovered local candidate")
        self.signalClient.send(candidate: candidate)
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
        DispatchQueue.main.async {
            self.rtcstatus = state.description.capitalized
        }
    }
    

}


