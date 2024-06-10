//
//  VVSingle.swift
//  Base
//
//  Created by 赵江明 on 2024/6/10.
//

import Foundation

class VVSingle<T: Codable> {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let lock = NSRecursiveLock()

    private let key: String = "\(T.self)"

    func save(_ item: T?) {
        lock.lock()
        defer { lock.unlock() }
        if let data = try? encoder.encode(item) {
            VVStore.shared.mmkv.set(data, forKey: key)
        } else {
            VVStore.shared.mmkv.removeValue(forKey: key)
        }
    }

    func get() -> T? {
        lock.lock()
        defer { lock.unlock() }
        if let data = VVStore.shared.mmkv.data(forKey: key), let value = try? decoder.decode(T.self, from: data) {
            return value
        }
        return nil
    }

    func remove() {
        VVStore.shared.mmkv.removeValue(forKey: key)
    }
}
