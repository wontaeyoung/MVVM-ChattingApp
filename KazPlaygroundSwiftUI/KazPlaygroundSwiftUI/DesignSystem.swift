//
//  #3_DesignSystem.swift
//  KazPlaygroundSwiftUI
//
//  Created by 원태영 on 2023/01/21.
//





import SwiftUI

struct DesignSystem: View {
    var body: some View {
        NavigationView {
            KazNavigationLink(style: .main) {
                Text("도착지")
            } content : {
                Text("링크 버튼")
            }
        }
    }
}

struct DesignSystem_Previews: PreviewProvider {
    static var previews: some View {
        DesignSystem()
    }
}

struct KazNavigationLink<Content: View> : View {
    enum NavigationLinkStyle {
        case main
        case text
        case toolbar
    }
    
    let style : NavigationLinkStyle
    let destination : () -> Content
    let content : () -> Content
    
//    init(style : NavigationLinkStyle,
//         destination : @escaping () -> Content,
//         content : @escaping () -> Content) {
//        self.style = style
//        self.destination = destination
//        self.content = content
//    }
    
    // MARK: -Comment : ViewBuilder는 2개 이상의 컴포넌트를 전달받는 뷰에서 사용 ex. Label 안의 Image와 Text
    init(style : NavigationLinkStyle,
         @ViewBuilder destination : @escaping () -> Content,
         @ViewBuilder content : @escaping () -> Content) {
        self.style = style
        self.destination = destination
        self.content = content
    }
    
    var body : some View {
        switch style {
        case .main:
            NavigationLink {
                destination()
            } label: {
                content()
                    .font(.title)
                    .background(Color.yellow)
                    .padding()
            }
        default:
            NavigationLink {
                ContentView()
            } label : {
                Text("ASD")
            }
        }
    }
}


