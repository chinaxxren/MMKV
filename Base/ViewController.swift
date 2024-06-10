//
//  ViewController.swift
//  Base
//
//  Created by 赵江明 on 2022/1/15.
//

import CodableWrapper
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Main"
        view.backgroundColor = .red
        testBook()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        testMMKV()
    }
    
    func testBook() {
        VVStore.shared.create(mmkvID: "store")
        
        let store = VVMulti<Book>()
        store.remove()
        
        let book1 = Book()
        book1.name = "1"
        book1.time = Date()
        book1.content = "111"
        
        let book2 = Book()
        book2.name = "2"
        book2.time = Date()
        book2.content = "222"
        
        store.save([book1, book2])
       
        var books = store.get()
        for book in books {
            print("\(book.name)   \(book.content)")
        }
        print("++++++++++++++++++++++++++++++++++++")
        
        book1.content = "121"
        store.save(book1)
        
        books = store.get()
        for book in books {
            print("\(book.name)   \(book.content)")
        }
        print("++++++++++++++++++++++++++++++++++++")
        
        store.remove(book1.vvid)
        books = store.get()
        for book in books {
            print("\(book.name)   \(book.content)")
        }
        print("++++++++++++++++++++++++++++++++++++")
        store.remove()
        books = store.get()
        for book in books {
            print("\(book.name)   \(book.content)")
        }
        print("++++++++++++++++++++++++++++++++++++")
        
    
    }
    
//    func testMMKV() {
//        let store = WQStore()
//        store.config(mmkvID: "test")
//
//        let book00 = store.getItem(forKey: "book1", as: Book.self)
//        print(book00?.content ?? "error")
//
//        let book1 = Book()
//        book1.time = Date()
//        book1.content = "2222"
//        store.saveItem(book1, forKey: "book1")
//
//        let book11 = store.getItem(forKey: "book1", as: Book.self)
//        print(book11?.content ?? "error")
//
//
//        let book21 = Book()
//        book21.time = Date()
//        book21.content = "--2211"
//
//        let book22 = Book()
//        book22.time = Date()
//        book22.content = "--2222"
//
//        store.saveItem([book21,book22], forKey: "books")
//
//        let book01 = store.getItem(forKey: "books", as: [Book].self)
//        print(book01?.last?.content ?? "error")
//    }
}

class Book: Codable, VVIdenti {
    @Codec var time: Date?
    @Codec var content: String = ""
    @Codec var name: String = ""
    
    var vvid: String {
        return name
    }
}
