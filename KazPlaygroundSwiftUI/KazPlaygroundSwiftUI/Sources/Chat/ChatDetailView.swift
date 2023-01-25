//
//  ChatDetailView.swift
//  KazPlaygroundSwiftUI
//
//  Created by 원태영 on 2023/01/25.
//

import SwiftUI

// MARK: -View : 채팅방 뷰
struct ChatView : View {
    @ObservedObject var chatStore: ChatStore
    @ObservedObject var chatCellStore : ChatCellStore = ChatCellStore()
    @State var isShowingUpdateCell : Bool = false
    @State var currentChatCell : ChatCell?
    let userID : String
    let chat : Chat
    @State private var contentField : String = ""
    
    var body: some View {
        
        
        VStack {
            // 채팅 메세지 스크롤 뷰
            ScrollView {
                ForEach(chatCellStore.chatCells) { chatCell in
                    
                    ChatCellView(userID: userID, chatCell: chatCell)
                        .contextMenu {
                            
                            Button {
                                self.currentChatCell = chatCell
                                isShowingUpdateCell = true
                            } label: {
                                Text("수정하기")
                                Image(systemName: "pencil")
                            }
                            
                            Button {
                                chatCellStore.removeChatCell(chatCell, chat.id)
                            } label: {
                                Text("삭제하기")
                                Image(systemName: "trash")
                            }
                        }
                }
                
            }
            // 메세지 입력 필드
            typeContentField
                .padding(20)
        }
        .sheet(isPresented: $isShowingUpdateCell) {
            if let currentChatCell {
                ChangeContentSheetView(isShowingUpdateCell: $isShowingUpdateCell,
                                       chatCellStore: chatCellStore,
                                       chatID: chat.id,
                                       chatCell: currentChatCell)
            }
        }
        .onAppear {
            chatCellStore.fetchChatCells(chatID: chat.id)
        }
    }
    
    // MARK: -Button : 메세지 수정
    private var updateContentButton : some View {
        Button {
            isShowingUpdateCell = true
        } label: {
            Text("수정하기")
            Image(systemName: "pencil")
        }
    }
    
    // MARK: -Button : 메세지 삭제
    private var removeContentButton : some View {
        Button {
            
        } label: {
            Text("삭제하기")
            Image(systemName: "trash")
        }
    }
    
    // MARK: -Section : 메세지 입력
    private var typeContentField : some View {
        HStack {
            TextField("",text: $contentField)
                .textFieldStyle(.roundedBorder)
            addContentButton
        }
    }
    
    // MARK: -Button : 메세지 추가(보내기)
    private var addContentButton : some View {
        Button {
            let newChatCell = makeChatCell()
            chatCellStore.addChatCell(newChatCell, chat.id)
            contentField = ""
            /*
             let newChat = Chat(id: chat.id, boardID: chat.boardID, userIDList: chat.userIDList, date: chat.date, lastContent: newChatCell.content)
             chatStore.updateChat(newChat)
             */
        } label: {
            Image(systemName: "paperplane.circle.fill")
        }
    }
    
    // MARK: -Method : ChatCell 인스턴스를 만들어서 반환하는 함수
    private func makeChatCell() -> ChatCell {
        
        let date = Date().timeIntervalSince1970
        let chatCell = ChatCell(id: UUID().uuidString,
                                userID: userUID,
                                content: contentField,
                                date: date)
        return chatCell
    }
}

struct ChangeContentSheetView : View {
    @Binding var isShowingUpdateCell : Bool
    @State var changeContentField : String = ""
    @ObservedObject var chatCellStore : ChatCellStore
    let chatID : String
    let chatCell : ChatCell
    
    var body: some View {
        VStack(spacing : 50) {
            
            TextField(chatCell.content, text: $changeContentField)
                .textFieldStyle(.roundedBorder)
            
            Button {
                chatCellStore.updateChatCell(chatCell, chatID)
                isShowingUpdateCell = false
            } label: {
                Text("수정하기")
                Image(systemName: "pencil")
            }
            
        }
    }
}
