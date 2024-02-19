# Video Call Implementation using WebRTC in iOS

## Starting the signaling server
1. Navigate to `signaling-swift` folder.
2. Run `make`.
3. Run `./server` to start the server.

## Setup 
1. Start the signaling server.
2. Update the `defaultSignalingServerUrl` with you server port in file `Config.swift`.
3. Build and run on a simulator. (Video Capture is not supported in simulator).

## Run instructions
1. Run the app on two simulators with signaling server running.
2. Make sure both simulators are running on the same server.
3. On the first device, click on `Send Offer` - this will generate a local offer SDP and send it to the other client using the signaling server.
4. Wait until the second device receives the offer from the first device (you should see that a remote SDP has arrived).
5. Click on `Send Answer` on the second device.
6. When the answer arrives to the first device, both of the devices should be now connected to each other using webRTC, try to talk or click on the 'video' button to start capturing video (Video only works on devices not simulators).

When you start the app, if it is connected to the signaling server, the signaling status should say 'Connected'. 

## Sending Offer
1. When the `Send Offer` is tapped, local sdp of the client is sent to the other device via the signaling server.
2. Local Spd contains the message that contain all the information about the client which includes its public and private ip, media attributes etc.

## Sending Answer
1. When the `Send Answer` is tapped after the offer is sent, the other device sends its SDP message as an answer describing its capabilities and session details.

### Once the connection is established, we no longer need the signaling server. We can now communicate with the devices using WebRTC without any need for the server.



