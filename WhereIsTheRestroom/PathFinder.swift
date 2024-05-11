//
//  PathFinder.swift
//  WhereIsTheRestroom
//
//  Created by Taewon Yoon on 5/11/24.
//

import Foundation
import UIKit
import NMapsMap


func distance(to coordinate1: NMGLatLng, coordinate2: NMGLatLng) -> Double {
    let earthRadius: Double = 6371 // 지구의 반지름 (단위: km)

    // 라디안 단위로 변환
    let lat1Rad = coordinate1.lat * .pi / 180
    let lon1Rad = coordinate1.lng * .pi / 180
    let lat2Rad = coordinate2.lat * .pi / 180
    let lon2Rad = coordinate2.lng * .pi / 180

    // 위도와 경도의 차이
    let latDiff = lat2Rad - lat1Rad
    let lonDiff = lon2Rad - lon1Rad

    // 위도와 경도의 차이에 대한 Haversine 공식
    let a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(lat1Rad) * cos(lat2Rad) *
        sin(lonDiff / 2) * sin(lonDiff / 2)
    let c = 2 * atan2(sqrt(a), sqrt(1 - a))

    // 거리 계산
    let distance = earthRadius * c
    return distance
}

func NaverMap(lat: Double, lng: Double) {
    // URL Scheme을 사용하여 네이버맵 앱을 열고 자동차 경로를 생성합니다.
    guard let url = URL(string: "nmap://route/car?dlat=\(lat)&dlng=\(lng)&appname=kr.co.kepco.ElectricCar") else { return }
    // 앱 스토어 URL을 설정합니다.
    guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8") else { return }
    
    if UIApplication.shared.canOpenURL(url) {
        // 네이버맵 앱이 설치되어 있는 경우 앱을 엽니다.
        UIApplication.shared.open(url)
    } else {
        // 네이버맵 앱이 설치되어 있지 않은 경우 앱 스토어로 이동합니다.
        UIApplication.shared.open(appStoreURL)
    }
}

func KaKaoMap(lat: Double, lng: Double) {
    // URL Scheme을 사용하여 kakaomap 앱 열고 경로 생성합니다
    guard let url = URL(string: "kakaomap://route?ep=\(lat),\(lng)&by=CAR") else { return }
    
    // Kakaomap 앱의 App Store URL 생성
    guard let appStoreUrl = URL(string: "itms-apps://itunes.apple.com/app/id304608425") else { return }
    
    let urlString = "kakaomap://open"
    
    // Kakaomap 앱이 설치되어 있는지 확인하고 URL 열기
    if let appUrl = URL(string: urlString) {
        if UIApplication.shared.canOpenURL(appUrl) {
            UIApplication.shared.open(url)
        } else {
            // Kakaomap 앱이 설치되어 있지 않은 경우 App Store URL 열기
            print("안깔려있는데")
            UIApplication.shared.open(appStoreUrl)
        }
    }
}

func TMap(lat:Double, lng:Double) {
    // URL Scheme을 사용하여 티맵 앱을 열고 자동차 경로를 생성합니다.
    let urlStr = "tmap://route?rGoName=목적지&rGoX=\(lng)&rGoY=\(lat)"
    
    // URL 문자열을 인코딩하여 올바른 형식으로 변환합니다.
    guard let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
    
    // 인코딩된 URL 문자열을 URL 객체로 변환합니다.
    guard let url = URL(string: encodedStr) else { return }
    
    // TMap 앱이 설치되어 있는지 확인합니다.
    if UIApplication.shared.canOpenURL(url) {
        // TMap 앱을 엽니다.
        UIApplication.shared.open(url)
    } else {
        // TMap 앱이 설치되어 있지 않은 경우 앱 스토어로 이동합니다.
        guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id431589174") else { return }
        UIApplication.shared.open(appStoreURL)
    }
}
