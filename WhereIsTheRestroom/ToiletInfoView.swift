//
//  ToiletInfoView.swift
//  WhereIsTheRestroom
//
//  Created by Taewon Yoon on 5/11/24.
//

import SwiftUI

struct ToiletInfoView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("길찾기")
                    Button(action: {
                        NaverMap(lat: coordinator.tappedMarkerTag?.latitude ?? 0.0, lng: coordinator.tappedMarkerTag?.longitude ?? 0.0)
                    }, label: {
                        Image("navermap")
                            .resizable()
                            .frame(width: 30, height: 30)
                    })
                    
                    Button {
                        print("흠")
                        KaKaoMap(lat: coordinator.tappedMarkerTag?.latitude ?? 0.0, lng: coordinator.tappedMarkerTag?.longitude ?? 0.0)
                    } label: {
                        Image("kakaomap")
                            .resizable()
                        .frame(width: 30, height: 30)               
                    }
                    
                    Button {
                        TMap(lat: coordinator.tappedMarkerTag?.latitude ?? 0.0, lng: coordinator.tappedMarkerTag?.longitude ?? 0.0)
                    } label: {
                        Image("tmap")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    Spacer()
                }
                
                if let tag = coordinator.tappedMarkerTag, let key = coordinator.tappedMarkerKey {
                    HStackTextView(text: "위치:\(key.position.lat), \(key.position.lng)")
                    HStackTextView(text: "거리:\(Double(Int(key.distance ?? 0.0))/1000)km")
                    HStackTextView(text: "\(tag.line)호선")
                    HStackTextView(text: "화장실이름: " + tag.toiletName)
                    HStackTextView(text: "화장실 상세 위치: " + tag.toiletDetailedLocation)
                    HStackTextView(text: "게이트 내외부: " + tag.toiletDetailedLocationInGate)
                    HStackTextView(text: "운영시간: " + tag.openHours)
                    HStackPhoneCallVeiw(text: "전화번호: ", phoneNumber: tag.phoneNumber)
                    HStackTextView(text: "리모델링: " + tag.remodelingYearMonth)
                    HStackTextView(text: "기저귀교환대설치유무-남자화장실: " + transformXY(value: tag.diaperChangingTableInstallationMaleToilet))
                    HStackTextView(text: "기저귀교환대설치유무-여자화장실: " + transformXY(value: tag.diaperChangingTableInstallationFemaleToilet))
                    HStackTextView(text: "기저귀교환대설치유무-남자장애인화장실: " + transformXY(value: tag.diaperChangingTableInstallationMaleDisabledToilet))
                    HStackTextView(text: "기저귀교환대설치유무-여자장인화장실: " + transformXY(value: tag.diaperChangingTableInstallationFemaleDisabledToilet))
                }
            }
        }
        .padding()
    }
    
    func transformXY(value: Bool) -> String {
        return value ? "있음" : "없음"
    }
}

extension ToiletInfoView {
    func HStackTextView(text: String) -> some View {
        HStack {
            Text(text)
            Spacer()
        }
        .padding(3)
    }
    
    func HStackPhoneCallVeiw(text: String , phoneNumber: String) -> some View {
        HStack {
            Text(text+phoneNumber)
            Button(action: {
                callNumber(phoneNumber: phoneNumber)
            }, label: {
                Image(systemName: "phone.fill")
                    .foregroundStyle(Color.green)
            })
            Spacer()
        }
    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
}

#Preview {
    ToiletInfoView()
        .environmentObject(Coordinator())
}
