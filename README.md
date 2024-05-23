# WhereIsTheRestroom
Finding RestRoom In Seoul Subway Restroom
1호선부터 8호선 역사 내 화장실 위치를 찾기 위한 앱입니다.

## 시작하기 전에
https://apple-document.tistory.com/156 에서 자세한 내용을 확인할 수 있습니다.
* 반드시 API Key를 info.plist에 추가하거나 앱을 시작할 때 API Key를 사용해야 지도를 띄울 수 있습니다.
## cocoapods
```swift
# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'DiseaseTrackerMap' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DiseaseTrackerMap
  pod 'NMapsMap'

end
```

## csv 파일 불러오기
좌표가 포함되어 있는 csv 파일을 불러옵니다.
하지만 csv를 xcode로 불러왔을때 정확하게 모두 가져오지 않는다는 것을 확인하였습니다. (outlier 존재)
```swift
if let path = Bundle.main.path(forResource: self.CSV_ASSET_NAME, ofType: "csv") {
  let contents = try String(contentsOfFile: path, encoding: .utf8)
  let lines = contents.components(separatedBy: .newlines)
```

## 클러스터링
원하는 데이터를 keyTagMap 프로퍼티에 담아 addAll을 사용하여 클러스터링을 진행할 수 있습니다.
```
@Published var keyTagMap = [ItemKey: ItemData]()
self.clusterer?.addAll(self.keyTagMap)
```

클러스터 마커의 이름또한 정할 수 있고 크기, 마커를 탭했을 때 동작도 정의할 수 있습니다.
```swift
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
```

<div align="center">
  <img src="https://github.com/iOS-Developer-KR/WhereIsTheRestroom/blob/main/Asset/Simulator%20Screenshot%20-%20iPhone%2015%20Plus%20-%202024-05-23%20at%2011.03.31.png" width="300" height="600"/>

## 일반 마커
일반 마커를 탭하였을 때 특정 뷰를 띄우기 위해 코드를 만들었습니다.
```swift
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
```

### 뷰에서 탭한 마커의 정보 확인
탭한 마커의 정보를 나타내기 위해서 코드를 만들었으며 반복되는 코드의 길이를 줄이기 위해서 extension에 HStackTextView를 만들었습니다.
```swift
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
```

```swift
func HStackTextView(text: String) -> some View {
    HStack {
        Text(text)
        Spacer()
    }
    .padding(3)
}
```

## 거리 계산
현 위치의 좌표와 목적지의 좌표 사이의 거리를 수직으로 뻗었을 때의 거리를 의미하며 실제 경로의 거리와 차이가 날 수 있습니다.
```swift
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
```

<div align="center">
  <img src="https://github.com/iOS-Developer-KR/WhereIsTheRestroom/blob/main/Asset/Simulator%20Screenshot%20-%20iPhone%2015%20Plus%20-%202024-05-23%20at%2011.03.31.png" width="300" height="600"/>
