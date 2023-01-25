//
//  ChatModel.swift
//  KazPlaygroundSwiftUI
//
//  Created by 원태영 on 2023/01/24.
//

import Foundation

let userUID : String = ""

struct Chat : Identifiable {
    let id : String // 채팅방 ID
    let date : Double // 생성 날짜
    let lastDate : Double // 마지막 메세지 날짜
    let lastContent : String // 마지막 메세지 내용
    
    var stringDate : String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateAt = Date(timeIntervalSince1970: date)
        
        return dateFormatter.string(from: dateAt)
    }
    
    var stringLastDate : String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateAt = Date(timeIntervalSince1970: lastDate)
        
        return dateFormatter.string(from: dateAt)
    }
}
