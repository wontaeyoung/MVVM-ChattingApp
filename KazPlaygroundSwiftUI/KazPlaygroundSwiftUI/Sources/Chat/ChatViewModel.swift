//
//  ChatViewModel.swift
//  KazPlaygroundSwiftUI
//
//  Created by 원태영 on 2023/01/24.
//

import Foundation
import FirebaseFirestore

class ChatStore: ObservableObject {
    @Published var chats: [Chat]
    
    let database = Firestore.firestore()
    
    init() {
        chats = []
    }
    
    func fetchChats() {
        database.collection("Chat").order(by: "lastDate", descending: true)
            .getDocuments { (snapshot, error) in
                self.chats.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        let date = docData["date"] as? Double ?? 0.0
                        let lastDate = docData["lastDate"] as? Double ?? 0.0
                        let lastContent = docData["lastContent"] as? String ?? ""
                        
                        let chat = Chat(id: id, date: date, lastDate: lastDate, lastContent: lastContent)
                        self.chats.append(chat)
                    }
                }
            }
    }
    
    // MARK: -Chat CRUD
    func addChat(_ chat: Chat) {
        database.collection("Chat")
            .document(chat.id)
            .setData(["id" : chat.id,
                      "date" : chat.date,
                      "lastDate" : chat.lastDate,
                      "lastContent" : chat.lastContent])
        fetchChats()
    }
    
    func updateChat(_ chat: Chat) {
        database.collection("Chat")
            .document(chat.id)
            .updateData(["id" : chat.id,
                         "date" : chat.date,
                         "lastDate" : chat.lastDate,
                         "lastContent" : chat.lastContent])
        fetchChats()
    }
    
    func removeChat(_ chat: Chat) {
        database.collection("Chat")
            .document(chat.id).delete()
        
        fetchChats()
    }
}
