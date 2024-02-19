

import Foundation

let server = try WebSocketServer()
server.start()
RunLoop.main.run()
