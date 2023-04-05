//
//  ViewController.swift
//  Base
//
//  Created by 赵江明 on 2022/1/15.
//

import UIKit
import CodableWrapper

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Main"
        self.view.backgroundColor = .red
        testMMKV()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        testMMKV()
    }
    
    func testMMKV() {
        let store = WQStore()
        store.config(mmkvID: "test")
        
        let book00 = store.getItem(forKey: "book1", as: Book.self)
        print(book00?.content ?? "error")
        
        let book1 = Book()
        book1.time = Date()
        book1.content = "2222"
        store.saveItem(book1, forKey: "book1")
       
        let book11 = store.getItem(forKey: "book1", as: Book.self)
        print(book11?.content ?? "error")
        
        
        let book21 = Book()
        book21.time = Date()
        book21.content = "--2211"
        
        let book22 = Book()
        book22.time = Date()
        book22.content = "--2222"
        
        store.saveItem([book21,book22], forKey: "books")
        
        let book01 = store.getItem(forKey: "books", as: [Book].self)
        print(book01?.last?.content ?? "error")
    }
}

class Book: Codable {
    @Codec var time: Date?
    @Codec var content: String = ""
}
