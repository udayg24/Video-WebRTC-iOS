

import SwiftUI
import UIKit

struct MainView: View {
    
    @EnvironmentObject private var vm: MainViewController
    private let config = Config.default
    private let fir: First = First()

    let webRTCClient: WebRTCClient
    let signalClient: SignalingClient
    
 
    @State private var status: Bool = false

    @State private var video: Bool = false

    
    var body: some View {
        
        
        VStack {
            
            Status
                .padding()
            webRTCStatus
                .padding()
            ButtonHStack
            ConnectButton
                .padding(.vertical, 50)
        }
        .sheet(isPresented: $video, content: {
            UIKitViewControllerWrapper(viewController: VideoViewController(webRTCClient: WebRTCClient(iceServers: config.webRTCIceServers)))
        })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
         let config = Config.default
         let fir:First = First()
        let signalClient = fir.buildSignalingClient()
        let webRTCClient = WebRTCClient(iceServers: config.webRTCIceServers)
        MainView(webRTCClient: WebRTCClient(iceServers: config.webRTCIceServers), signalClient: signalClient)
            .environmentObject(MainViewController(signalClient: signalClient, webRTCClient: webRTCClient))
    }
}

extension MainView {
    private var ButtonHStack: some View {
        HStack {
            Button {
                vm.muteTapped()
            } label: {
                Image(systemName: vm.mute ? "mic.slash" : "mic.fill")
                    .padding(10)
                    .foregroundColor(.orange)
                    .shadow(radius: 3, x: 3)
            }
            
            Button {
                vm.speakerTapped()
            } label: {
                Image(systemName: vm.speaker ? "speaker.slash.circle.fill" : "speaker.wave.2.circle.fill")
                    .padding(10)
                    .foregroundColor(.blue)
                    .shadow(radius: 3, x: 3)
            }
            
            Button {
                video.toggle()
            } label: {
                Image(systemName: "video.fill")
                    .padding(10)
                    .foregroundColor(.green)
                    .shadow(radius: 3, x: 3)
            }
            
            }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .font(.system(size: 55))
    }
    
    private var ConnectButton: some View {
        VStack {
            Button {
                vm.offerTapped()
            } label: {
                Text("Send Offer")
                    .font(.largeTitle)
                    .foregroundStyle(Color.white)
                    .padding()
                    .padding(.horizontal)
                    .frame(width: 300)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                    )
                    .shadow(radius: 10, y: 10)
                    
            }
            .padding()
            
            Button {
                vm.answerTapped()
            } label: {
                Text("Send Answer")
                    .font(.largeTitle)
                    .foregroundStyle(Color.white)
                    .padding()
                    .padding(.horizontal)
                    .frame(width: 300)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                    )
                    .shadow(radius: 10, y: 10)
            }

        }
    }
    
    private var Status: some View {
        
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Signaling Status:")
                        .font(.title3)
                    Text( vm.status ? "Connected" : "Not Connected")
                        .font(.caption)
                }
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Local SDP:")
                        .font(.title3)
                    Text( vm.localsdp ? "✅" : "❌")
                        .font(.title2)
                }
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Remote SDP:")
                        .font(.title3)
                    Text( vm.remotesdp ? "✅" : "❌")
                        .font(.title2)
                }
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
            }
            
            Rectangle()
                .fill(Color(uiColor: .systemBackground))
                .frame(width: 110)
            
            
        }
        .frame(maxWidth: .infinity)
        
        
    }
    
    private var webRTCStatus: some View {
        
        VStack {
            Text("WebRTC Status")
                .font(.title)
                .fontWeight(.bold)
                
            Text(vm.rtcstatus)
                .font(.title2)
        }
    }
    
}

