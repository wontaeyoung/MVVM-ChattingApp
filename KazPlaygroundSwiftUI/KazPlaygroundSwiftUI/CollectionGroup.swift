//
//  CollectionGroup.swift
//  KazPlaygroundSwiftUI
//
//  Created by 원태영 on 2023/01/20.
//

import SwiftUI
import FirebaseFirestore

struct ReviewView: View {
    @StateObject var storeVM : StoreViewModel = StoreViewModel()
    
    var body: some View {
        VStack {
            Button {
                Task {
                    storeVM.requestData(userID: "dduri")
                }
            } label: {
                Text("패치하기")
            }
            
            List {
                ForEach(storeVM.reviews) { review in
                    Text(review.content)
                }
            }
            
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView()
    }
}

// MARK: -Models
struct Store : Identifiable {
    let id : String = UUID().uuidString
    let name : String
}

struct Item : Identifiable {
    let id : String = UUID().uuidString
    let storeID : String
    let name : String
    let price : Int
}


struct Review : Identifiable {
    let id : String
    let storeID : String
    let userID : String
    let content : String
}

// MARK: -ViewModel
class StoreViewModel: ObservableObject {
    @Published var stores: [Store]
    @Published var items: [Item]
    @Published var reviews: [Review]
    
    let db = Firestore.firestore()
    
    init(stores : [Store] = [], items : [Item] = [], reviews : [Review] = []) {
        self.stores = stores
        self.items = items
        self.reviews = reviews
    }
    
    
    func requestData(userID : String) {
        
        print("A")
        
        db.collectionGroup("Review")
            .whereField("userID", isEqualTo: "kaz")
//            .order(by: "content") //해...결? 인가...?
            .getDocuments { (snapshot, error) in
                self.reviews.removeAll()
                print("B")
                if let snapshot {
                    for document in snapshot.documents {
                        print("C")
                        let id : String = document.documentID
                        let docData = document.data()
                        let storeID : String = docData["storeID"] as? String ?? ""
                        let userID : String = docData["userID"] as? String ?? ""
                        let content : String = docData["content"] as? String ?? ""
                        
                        
                        let newReview : Review = Review(id: id,
                                                        storeID: storeID,
                                                        userID: userID,
                                                        content: content)
                        
                        self.reviews.append(newReview)
                    }
                }
            }
    }
    
    
    /*
    // MARK: -Diary CRUD
    func addDiary(_ diary: Diary) {
        
        database.collection("Diary")
            .document(diary.id)
            .setData(["id" : diary.id,
                      "userID" : diary.userID,
                      "title" : diary.title,
                      "content" : diary.content,
                      "createAt" : diary.createAt,
                      "updateAt" : diary.updateAt])
        requestDiaries(userID: diary.userID)
    }
    
    
    func updateDiary(_ diary: Diary) {
        
        database.collection("Diary")
            .document(diary.id)
            .updateData(["id" : diary.id,
                         "userID" : diary.userID,
                         "title" : diary.title,
                         "content" : diary.content,
                         "createAt" : diary.createAt,
                         "updateAt" : diary.updateAt])
        requestDiaries(userID: diary.userID)
    }
    
    func removeDiary(_ diary: Diary) {
        
        database.collection("Diary")
            .document(diary.id).delete()
        
        requestDiaries(userID: diary.userID)
    }
     */
}
