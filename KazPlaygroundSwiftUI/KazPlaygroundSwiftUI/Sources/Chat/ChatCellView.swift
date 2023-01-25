//
//  ChatCellView.swift
//  KazPlaygroundSwiftUI
//
//  Created by 원태영 on 2023/01/25.
//

import SwiftUI

// MARK: -View : 채팅 메세지 셀
struct ChatCellView : View {
    let userID : String
    let chatCell : ChatCell
    var isMine : Bool {
        return userID == chatCell.userID
    }
    
    var body: some View {
        let dateTime = ChatStore().parseStringDate(strDate: chatCell.stringDate)
        HStack(alignment: .bottom) {
            if isMine {
                Spacer()
                Text(dateTime.time)
                    .modifier(ChatCellTimeModifier())
            }
            
            Text(chatCell.content)
                .modifier(ChatCellModifier(isMine: self.isMine))
            
            if !isMine {
                Text(dateTime.time)
                    .modifier(ChatCellTimeModifier())
                Spacer()
            }
        }
        .padding(isMine ? .trailing : .leading, 20)
    }
}

// MARK: -Modifier : 채팅 메세지 셀 속성
struct ChatCellModifier : ViewModifier {
    let isMine : Bool
    func body(content: Content) -> some View {
        content
            .padding()
            .padding(.vertical,-8)
            .foregroundColor(isMine ? .white : .black)
            .background(isMine ? .orange : .gray)
            .cornerRadius(22)
        
        
    }
}

// MARK: -Modifier : 채팅 메세지 보낸 시간 속성
struct ChatCellTimeModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption2)
            .foregroundColor(.secondary)
    }
}
