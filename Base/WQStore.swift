//
//  MMKVStore.swift
//  Base
//
//  Created by 赵江明 on 2023/4/4.
//

import Foundation
import MMKV

class WQStore {
    
    public static var shared = WQStore()
        
    var mmkv: MMKV!
    
    func config(mmkvID: String? = nil) {
        self.mmkv = MMKV.custom(mmkvID: mmkvID)
    }

    func saveItem<T: Codable>(_ object: T?, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            mmkv.set(data, forKey: key)
        } else {
            self.mmkv.removeValue(forKey: key)
        }
    }
    
    func getItem<T: Codable>(forKey key: String, as _: T.Type) -> T? {
        if let data = self.mmkv.data(forKey: key), let value = try? JSONDecoder().decode(T.self, from: data) {
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
    
    static private let didInitialize = false
    
    public static var relativePath: String = MMKV.path.appending("/MMKV") {
        didSet {
            initializeMMKV()
        }
    }
    
    public static func custom(mmkvID: String? = "default") -> MMKV {
        initializeMMKV()
        if let mmkvID = mmkvID, let mmkv = MMKV(mmapID: mmkvID, rootPath: MMKV.relativePath) {
            return mmkv
        } else {
            return MMKV.default()!
        }
    }
    
    static private func initializeMMKV() {
        guard !didInitialize else { return }
        try? FileManager.default.createDirectory(atPath: relativePath, withIntermediateDirectories: true)
        MMKV.initialize(rootDir: nil)
    }
}

public extension MMKV {
    
    func saveItem<T: Codable>(_ item: T?, forKey key: String) {
        if let data = try? JSONEncoder().encode(item) {
            set(data, forKey: key)
        } else {
            self.removeValue(forKey: key)
        }
    }
    
    func getItem<T: Codable>(forKey key: String, as _: T.Type) -> T? {
        if let data = self.data(forKey: key), let value = try? JSONDecoder().decode(T.self, from: data) {
            return value
        }
        return nil
    }
    
}
