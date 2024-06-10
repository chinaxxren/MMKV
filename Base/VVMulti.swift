//
//  VVMulti.swift
//  Base
//
//  Created by 赵江明 on 2024/6/10.
//

import Foundation

protocol VVIdenti {
    var vvid: String { get }
}

class VVMulti<T: Codable & VVIdenti> {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let lock = NSRecursiveLock()

    private let key = "\([T].self)"

    func save(_ ts: [T]) {
        lock.lock()
        defer { lock.unlock() }

        if let data = try? encoder.encode(ts) {
            VVStore.shared.mmkv.set(data, forKey: key)
        } else {
            VVStore.shared.mmkv.removeValue(forKey: key)
        }
    }

    func get() -> [T] {
        lock.lock()
        defer { lock.unlock() }

        if let data = VVStore.shared.mmkv.data(forKey: key), let values = try? decoder.decode([T].self, from: data) {
            return values
        }
        return []
    }

    func save(_ t: T) {
        lock.lock()
        defer { lock.unlock() }

        var items = get()
        if let index = items.firstIndex(where: { $0.vvid == t.vvid }) {
            items[index] = t
        } else {
            items.append(t)
        }

        save(items)
    }

    func remove() {
        lock.lock()
        defer { lock.unlock() }

        VVStore.shared.mmkv.removeValue(forKey: key)
    }

    func count() -> Int {
        lock.lock()
        defer { lock.unlock() }
        return get().count
    }
    
    func exist() -> Bool {
        lock.lock()
        defer { lock.unlock() }

        return count() != 0
    }

    func exist(_ vvid: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        let items = get()
        let index = items.firstIndex(where: { $0.vvid == vvid })
        return index != nil
    }

    func remove(_ vvid: String) {
        lock.lock()
        defer { lock.unlock() }
        var items = get()
        if let index = items.firstIndex(where: { $0.vvid == vvid }) {
            items.remove(at: index)
        }

        save(items)
    }
}
