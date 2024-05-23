//
//  Coordinator.swift
//  WhereIsTheRestroom
//
//  Created by Taewon Yoon on 5/10/24.
//

import UIKit
import SwiftUI
import NMapsMap
import Combine


class ItemKey: NSObject, Identifiable, NMCClusteringKey {
    let cases: Int
    let position: NMGLatLng // 경도 위도
    var distance: Double?
    
    init(cases: Int, position: NMGLatLng, distance: Double? = 0.0) {
        self.cases = cases
        self.position = position
        self.distance = distance
    }
    
    static func markerKey(position: NMGLatLng, cases: Int) -> ItemKey {
        return ItemKey(cases: cases, position: position)
    }
    
    override func isEqual(_ o: Any?) -> Bool {
        guard let o = o as? ItemKey else {
            return false
        }
        if self === o {
            return true
        }
        
        return o.cases == self.cases
    }
    
    override var hash: Int {
        return self.cases
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return ItemKey(cases: self.cases, position: self.position)
    }
}

class ItemData: NSObject, Identifiable {
    let serialNumber: String // 연번
     let category: String // 구분
     let line: Int // 호선
     let toiletName: String // 화장실명(역명)
     let roadAddress: String // 소재지도로명주소
     let landLotAddress: String // 소재지지번주소
     let maleToiletCount: Int // 남성용-대변기수
     let maleUrinalCount: Int // 남성용-소변기수
     let maleDisabledToiletCount: Int // 남성용-장애인용대변기수
     let maleDisabledUrinalCount: Int // 남성용-장애인용소변기수
     let maleChildrenToiletCount: Int // 남성용-어린이용대변기수
     let maleChildrenUrinalCount: Int // 남성용-어린이용소변기수
     let femaleToiletCount: Int // 여성용-대변기수
     let femaleDisabledToiletCount: Int // 여성용-장애인용대변기수
     let femaleChildrenToiletCount: Int // 여성용-어린이용대변기수
     let managementAgency: String // 관리기관명
     let phoneNumber: String // 전화번호
     let openHours: String // 개방시간
     let toiletDetailedLocation: String // 화장실 상세위치
     let toiletDetailedLocationInGate: String // 화장실 상세위치(게이트 내외부)
     let latitude: Double // 위도
     let longitude: Double // 경도
     let toiletInstallationPlaceType: String // 화장실설치장소유형
     let emergencyBellInstallation: Bool // 비상벨 설치유무
     let entranceCCTVInstallation: Bool // 화장실입구cctv설치유무
     let diaperChangingTableInstallationMaleToilet: Bool // 기저귀교환대설치유무-남자화장실
     let diaperChangingTableInstallationMaleDisabledToilet: Bool // 기저귀교환대설치유무-남자장애인화장실
     let diaperChangingTableInstallationFemaleToilet: Bool // 기저귀교환대설치유무-여자화장실
     let diaperChangingTableInstallationFemaleDisabledToilet: Bool // 기저귀교환대설치유무-여자장애인화장실
     let remodelingYearMonth: String // 리모델링년월
     let dataStandardDate: String // 데이터기준일자
    
    init(serialNumber: String?, category: String?, line: Int?, toiletName: String?, roadAddress: String?, landLotAddress: String?, maleToiletCount: Int?, maleUrinalCount: Int?, maleDisabledToiletCount: Int?, maleDisabledUrinalCount: Int?, maleChildrenToiletCount: Int?, maleChildrenUrinalCount: Int?, femaleToiletCount: Int?, femaleDisabledToiletCount: Int?, femaleChildrenToiletCount: Int?, managementAgency: String?, phoneNumber: String?, openHours: String?, toiletDetailedLocation: String?, toiletDetailedLocationInGate: String?, latitude: Double?, longitude: Double?, toiletInstallationPlaceType: String?, emergencyBellInstallation: Bool?, entranceCCTVInstallation: Bool?, diaperChangingTableInstallationMaleToilet: Bool?, diaperChangingTableInstallationMaleDisabledToilet: Bool?, diaperChangingTableInstallationFemaleToilet: Bool?, diaperChangingTableInstallationFemaleDisabledToilet: Bool?, remodelingYearMonth: String?, dataStandardDate: String?) {
        
        self.serialNumber = serialNumber ?? "Unknown"
        self.category = category ?? "Unknown"
        self.line = line ?? 0
        self.toiletName = toiletName ?? "Unknown"
        self.roadAddress = roadAddress ?? "Unknown"
        self.landLotAddress = landLotAddress ?? "Unknown"
        self.maleToiletCount = maleToiletCount ?? 0
        self.maleUrinalCount = maleUrinalCount ?? 0
        self.maleDisabledToiletCount = maleDisabledToiletCount ?? 0
        self.maleDisabledUrinalCount = maleDisabledUrinalCount ?? 0
        self.maleChildrenToiletCount = maleChildrenToiletCount ?? 0
        self.maleChildrenUrinalCount = maleChildrenUrinalCount ?? 0
        self.femaleToiletCount = femaleToiletCount ?? 0
        self.femaleDisabledToiletCount = femaleDisabledToiletCount ?? 0
        self.femaleChildrenToiletCount = femaleChildrenToiletCount ?? 0
        self.managementAgency = managementAgency ?? "Unknown"
        self.phoneNumber = phoneNumber ?? "Unknown"
        self.openHours = openHours ?? "Unknown"
        self.toiletDetailedLocation = toiletDetailedLocation ?? "Unknown"
        self.toiletDetailedLocationInGate = toiletDetailedLocationInGate ?? "Unknown"
        self.latitude = latitude ?? 0.0
        self.longitude = longitude ?? 0.0
        self.toiletInstallationPlaceType = toiletInstallationPlaceType ?? "Unknown"
        self.emergencyBellInstallation = emergencyBellInstallation ?? false
        self.entranceCCTVInstallation = entranceCCTVInstallation ?? false
        self.diaperChangingTableInstallationMaleToilet = diaperChangingTableInstallationMaleToilet ?? false
        self.diaperChangingTableInstallationMaleDisabledToilet = diaperChangingTableInstallationMaleDisabledToilet ?? false
        self.diaperChangingTableInstallationFemaleToilet = diaperChangingTableInstallationFemaleToilet ?? false
        self.diaperChangingTableInstallationFemaleDisabledToilet = diaperChangingTableInstallationFemaleDisabledToilet ?? false
        self.remodelingYearMonth = remodelingYearMonth ?? "Unknown"
        self.dataStandardDate = dataStandardDate ?? "Unknown"
    }

}



class Coordinator: NSObject, NMFMapViewOptionDelegate, NMCClusterMarkerUpdater, NMCLeafMarkerUpdater , ObservableObject {
    
    var mapType: NMFMapType = .basic
    var mapDetail: [String:Bool] = [NMF_LAYER_GROUP_BICYCLE:false,
                                    NMF_LAYER_GROUP_TRAFFIC:false,
                                    NMF_LAYER_GROUP_TRANSIT:false,
                                   NMF_LAYER_GROUP_BUILDING:false,
                                   NMF_LAYER_GROUP_MOUNTAIN:false,
                                  NMF_LAYER_GROUP_CADASTRAL:false]
    
    let view = NMFNaverMapView(frame: .infinite)
    
    @Published var markerTapped: Bool = false // 마커가 눌렸는지 여부
    @Published var tappedMarkerInfo: NMCLeafMarkerInfo? // 눌린 마커의 Info
    @Published var tappedMarkerTag: ItemData? // 눌린 마커의 Tag
    @Published var tappedMarkerKey: ItemKey? // 눌린 마커의 Key
    @Published var keyTagMap = [ItemKey: ItemData]()
    @Published var showToiletList: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    let CSV_ASSET_NAME = "seoul_subway_toilet"
    
    var clusterer: NMCClusterer<ItemKey>?
    
    override init() {
        super.init()
        view.mapView.positionMode = .compass
        view.showLocationButton = true
        let builder = NMCComplexBuilder<ItemKey>()
        builder.minClusteringZoom = 9
        builder.maxClusteringZoom = 16
        builder.maxScreenDistance = 200
        builder.clusterMarkerUpdater = self
        builder.leafMarkerUpdater = self
        self.clusterer = builder.build()
        
        self.makeClusterer() // 클러스터 만들기
        self.clusterer?.mapView = self.view.mapView
    }
    
    
    func setMarker(lat : Double, lng:Double, title: String) {
        let marker = NMFMarker()
        marker.iconImage = NMF_MARKER_IMAGE_PINK
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.mapView = view.mapView
        
        let infoWindow = NMFInfoWindow()
        let dataSource = NMFInfoWindowDefaultTextSource.data()
        dataSource.title = "\(lat.description), \(lng.description)"
        infoWindow.dataSource = dataSource
        infoWindow.open(with: marker)
    }
    
    func makeClusterer() {
        let builder = NMCComplexBuilder<ItemKey>()
        builder.minClusteringZoom = 9
        builder.maxClusteringZoom = 16
        builder.maxScreenDistance = 200
        builder.clusterMarkerUpdater = self
        builder.leafMarkerUpdater = self
        
        self.clusterer = builder.build()
        
        DispatchQueue.main.async {
            do {
                if let path = Bundle.main.path(forResource: self.CSV_ASSET_NAME, ofType: "csv") {
                    let contents = try String(contentsOfFile: path, encoding: .utf8)
                    let lines = contents.components(separatedBy: .newlines)
                    for (i, line) in lines.enumerated() {
                        if i > 302 {
                            break
                        }
                        let split = line.components(separatedBy: ",")
                        guard split.count >= 32 && split.count != 31 else {
                            continue
                        }
                        let currentCoordinate = Location().locationManager.location?.coordinate
                        
                        // 두 지점의 위도와 경도
                        let coordinate1 = CLLocationCoordinate2D(latitude: currentCoordinate?.latitude ?? 0.0, longitude: currentCoordinate?.longitude ?? 0.0)
                        
                        let coordinate2 = CLLocationCoordinate2D(latitude: Double(split[21]) ?? 0.0, longitude: Double(split[22]) ?? 0.0)
                        
                        // CLLocation 객체 생성
                        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
                        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
                        
                        let distanceInMeters = location1.distance(from: location2)
                        if let lat = Double(split[21]), let lng = Double(split[22]) {
                            let key = ItemKey(cases: i, position: NMGLatLng(lat: lat, lng: lng), distance: distanceInMeters)
                            let itemData = ItemData(serialNumber: split[0],
                                                    category: split[1],
                                                    line: Int(split[2]),
                                                    toiletName: split[3],
                                                    roadAddress: split[4],
                                                    landLotAddress: split[5],
                                                    maleToiletCount: Int(split[7]),
                                                    maleUrinalCount: Int(split[8]),
                                                    maleDisabledToiletCount: Int(split[9]),
                                                    maleDisabledUrinalCount: Int(split[10]),
                                                    maleChildrenToiletCount: Int(split[11]),
                                                    maleChildrenUrinalCount: Int(split[12]),
                                                    femaleToiletCount: Int(split[13]),
                                                    femaleDisabledToiletCount: Int(split[14]),
                                                    femaleChildrenToiletCount: Int(split[15]),
                                                    managementAgency: split[16],
                                                    phoneNumber: split[17],
                                                    openHours: split[18],
                                                    toiletDetailedLocation: split[19],
                                                    toiletDetailedLocationInGate: split[20],
                                                    latitude: Double(split[21]),
                                                    longitude: Double(split[22]),
                                                    toiletInstallationPlaceType: split[24],
                                                    emergencyBellInstallation: (split[26] == "Y"),
                                                    entranceCCTVInstallation: (split[27] == "Y"),
                                                    diaperChangingTableInstallationMaleToilet: (split[28] == "Y"),
                                                    diaperChangingTableInstallationMaleDisabledToilet: (split[29] == "Y"),
                                                    diaperChangingTableInstallationFemaleToilet: (split[30] == "Y"),
                                                    diaperChangingTableInstallationFemaleDisabledToilet: (split[31] == "Y"),
                                                    remodelingYearMonth: split[32],
                                                    dataStandardDate: split[33])

                            
                            print(itemData.toiletName)
                            self.keyTagMap[key] = itemData

                        }
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
            self.clusterer?.addAll(self.keyTagMap)
            self.clusterer?.mapView = self.view.mapView
        }
    }
    
    
    func updateLeafMarker(_ info: NMCLeafMarkerInfo, _ marker: NMFMarker) {
        let tag = info.tag as? ItemData
        marker.captionText = tag?.toiletName ?? ""
        marker.iconImage = NMF_MARKER_IMAGE_GREEN
        marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
            let cameraUpdate = NMFCameraUpdate(scrollTo: info.position)
            self?.view.mapView.moveCamera(cameraUpdate)
            self?.tappedMarkerInfo = info
            self?.tappedMarkerKey = info.key as? ItemKey
            self?.tappedMarkerTag = info.tag as? ItemData
            return true
        }
    }
    
    
    func updateClusterMarker(_ info: NMCClusterMarkerInfo, _ marker: NMFMarker) {
        marker.captionText = String(info.size)
        marker.captionTextSize = 16
        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: info.position.lat, lng: info.position.lng))
            cameraUpdate.animation = .easeIn
            self.view.mapView.moveCamera(cameraUpdate)
            return true
        }
        
        if info.size < 3 && info.size > 1 {
            marker.iconImage = NMF_MARKER_IMAGE_CLUSTER_LOW_DENSITY
        } else if info.size < 10 {
            marker.iconImage = NMF_MARKER_IMAGE_CLUSTER_MEDIUM_DENSITY
        } else {
            marker.iconImage = NMF_MARKER_IMAGE_CLUSTER_HIGH_DENSITY
        }
    }
}
