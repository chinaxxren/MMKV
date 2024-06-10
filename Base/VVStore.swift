//
//  MMKVStore.swift
//  Base
//
//  Created by 赵江明 on 2023/4/4.
//

import Foundation
import MMKV

class VVStore {
    public static var shared = VVStore()

    var mmkvID: String = ""

    public var mmkv: MMKV!

    func create(mmkvID: String = "default", cryptKey: Data? = nil, mode: MMKVMode = .singleProcess) {
        mmkv = MMKV.custom(mmkvID: mmkvID, cryptKey: cryptKey, mode: mode)
    }

    func clear() {
        let manager = FileManager.default
        let path = MMKV.rootDir
        if manager.fileExists(atPath: path) {
            try! manager.removeItem(atPath: path.appending(mmkvID))
        }

        if manager.fileExists(atPath: path) {
            try! manager.removeItem(atPath: path.appending("\(mmkvID).crc"))
        }
    }
}

extension MMKV {
    static let path: String = {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        return paths[0]
    }()

    static let rootDir = MMKV.path.appending("/MMKV")
    private static let didInitialize = false

    public static func custom(mmkvID: String? = "default", cryptKey: Data?, mode: MMKVMode = .singleProcess) -> MMKV {
        initializeMMKV()
        if let mmkvID = mmkvID, let mmkv = MMKV(mmapID: mmkvID, cryptKey: cryptKey, mode: mode) {
            return mmkv
        } else {
            return MMKV.default()!
        }
    }

    private static func initializeMMKV() {
        guard !didInitialize else {
            return
        }

        try? FileManager.default.createDirectory(atPath: rootDir, withIntermediateDirectories: true)
        MMKV.initialize(rootDir: rootDir)
    }
}
