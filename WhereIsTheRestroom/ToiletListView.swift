//
//  ToiletListView.swift
//  WhereIsTheRestroom
//
//  Created by Taewon Yoon on 5/11/24.
//

//import SwiftUI
//
//struct ToiletListView: View {
//    @EnvironmentObject var coordinator: Coordinator
//    var body: some View {
//        
//        ScrollView {
//            ForEach(coordinator.keyTagMap.sorted(by: { $0.key.distance ?? 0.0 < $1.key.distance ?? 0.0 }), id: \.value.id) { data in
//                HStack {
//                    Text("화장실이름:" + data.value.toiletName)
//                    Text("거리:\(Double(Int(data.key.distance ?? 0.0))/1000)km")
//                }
//            }
//        }
//        
//    }
//}
//
//#Preview {
//    ToiletListView()
//        .environmentObject(Coordinator())
//}
