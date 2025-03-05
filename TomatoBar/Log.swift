import Foundation
import SwiftUI

protocol TBLogEvent: Encodable {
    var type: String { get }
    var timestamp: Date { get }
    var verboseMessage: String { get }
}

extension TBLogEvent {
    var verboseMessage: String {
        return "\(type) at \(timestamp)"
    }
}

class TBLogEventAppStart: TBLogEvent {
    internal let type = "appstart"
    internal let timestamp: Date = Date()
}

class TBLogEventTransition: TBLogEvent {
    internal let type = "transition"
    internal let timestamp: Date = Date()
    let from: String
    let to: String
    
    init(from: String, to: String) {
        self.from = from
        self.to = to
    }
    
    var verboseMessage: String {
        return "Transition from \(from) to \(to) at \(timestamp)"
    }
}

private let logFileName = "TomatoBar.log"
private let lineEnd = "\n".data(using: .utf8)!

internal let logger = TBLogger()

class TBLogger {
    private let logHandle: FileHandle?
    private let encoder = JSONEncoder()

    init() {
        encoder.outputFormatting = .sortedKeys
        encoder.dateEncodingStrategy = .secondsSince1970

        let fileManager = FileManager.default
        let logPath = fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(logFileName)
            .path

        if !fileManager.fileExists(atPath: logPath) {
            guard fileManager.createFile(atPath: logPath, contents: nil) else {
                print("cannot create log file")
                logHandle = nil
                return
            }
        }

        logHandle = FileHandle(forUpdatingAtPath: logPath)
        guard logHandle != nil else {
            print("cannot open log file")
            return
        }
    }

    func append(event: TBLogEvent) {
        guard let logHandle = logHandle else {
            return
        }
        do {
            let jsonData = try encoder.encode(event)
            try logHandle.seekToEnd()
            try logHandle.write(contentsOf: jsonData + lineEnd)
            try logHandle.synchronize()
        } catch {
            print("cannot write to log file: \(error)")
        }
    }
}
