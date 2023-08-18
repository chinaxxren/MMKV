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

    var current = WQMMKV()
    var global = WQMMKV()

    func create(mmkvID: String?) {
        current.config(mmkvID: mmkvID)
        global.config(mmkvID: "global")
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

class WQMMKV {

    fileprivate var mmkv: MMKV!

    fileprivate func config(mmkvID: String? = nil,cryptKey: Data? = nil,mode: MMKVMode = .singleProcess) {
        mmkv = MMKV.custom(mmkvID: mmkvID,cryptKey: cryptKey,mode: mode)
    }

    func saveItem<T: Codable>(_ item: T?, _ key: String = "\(T.self)") {
        if let data = try? JSONEncoder().encode(item) {
            mmkv.set(data, forKey: key)
        } else {
            mmkv.removeValue(forKey: key)
        }
    }

    func getItem<T: Codable>(_ as: T.Type, key: String = "\(T.self)") -> T? {
        if let data = mmkv.data(forKey: key), let value = try? JSONDecoder().decode(T.self, from: data) {
            return value
        }
        return nil
    }
}

extension MMKV {

    static let path: String = {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        return paths[0]
    }()

    static let rootDir = MMKV.path.appending("/MMKV")
    static private let didInitialize = false

    public static func custom(mmkvID: String? = "default",cryptKey: Data?, mode: MMKVMode = .singleProcess) -> MMKV {
        initializeMMKV()
        if let mmkvID = mmkvID, let mmkv = MMKV(mmapID: mmkvID, cryptKey: cryptKey, mode: mode) {
            return mmkv
        } else {
            return MMKV.default()!
        }
    }

    static private func initializeMMKV() {
        guard !didInitialize else {
            return
        }
        
        try? FileManager.default.createDirectory(atPath: rootDir, withIntermediateDirectories: true)
        MMKV.initialize(rootDir: rootDir)
    }
}

