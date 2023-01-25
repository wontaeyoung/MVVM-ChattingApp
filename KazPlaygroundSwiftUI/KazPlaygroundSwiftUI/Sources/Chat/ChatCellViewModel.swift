//
//  ChatCellViewModel.swift
//  KazPlaygroundSwiftUI
//
//  Created by 원태영 on 2023/01/24.
//

import Foundation
import FirebaseFirestore

class ChatCellStore : ObservableObject {
    
    @Published var chatCells : [ChatCell]
    
    let database = Firestore.firestore()
    
    init() {
        chatCells = []
    }
    
    
    // MARK: -Method : 채팅 ID를 받아서 메세지들을 불러오는 함수
    func fetchChatCells(chatID : String) {
        self.database.collection("Chat").document(chatID).collection("ChatCell").order(by: "date")
            .getDocuments { snapshot, error in
                self.chatCells.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        let userID : String = docData["userID"] as? String ?? ""
                        let content : String = docData["content"] as? String ?? ""
                        let date : Double = docData["date"] as? Double ?? 0.0
                        self.chatCells.append(ChatCell(id: id, userID: userID, content: content, date: date))
                    }
                }
                
            }
    }
    
    // MARK: - ChatCell CRUD
    func addChatCell(_ chatCell: ChatCell, _ chatID: String) {
        
        database.collection("Chats").document(chatID).collection("ChatCells")
            .document(chatCell.id)
            .setData(["id" : chatCell.id,
                      "userID" : chatCell.userID,
                      "content" : chatCell.content,
                      "date" : chatCell.date])
        
        fetchChatCells(chatID: chatID)
    }
    
    func updateChatCell(_ chatCell: ChatCell, _ chatID: String) {
        database.collection("Chats").document(chatID).collection("ChatCells")
            .document(chatCell.id)
            .updateData(["id" : chatCell.id,
                         "userID" : chatCell.userID,
                         "content" : chatCell.content,
                         "date" : chatCell.date])
        
        fetchChatCells(chatID: chatID)
    }
    
    func removeChatCell(_ chatCell: ChatCell, _ chatID: String) {
        database.collection("Chats").document(chatID).collection("ChatCells")
            .document(chatCell.id)
            .delete()
        
        fetchChatCells(chatID: chatID)
    }
}
