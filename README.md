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

