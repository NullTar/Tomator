
import Foundation
import SwiftUI

private let logFileName = "Tomator.log"
private let lineEnd = "\n".data(using: .utf8)!

internal let logger = Logger()

class Logger {
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

    func append(event: LogEventProtocol) {
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
