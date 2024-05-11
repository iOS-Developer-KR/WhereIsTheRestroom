//
//  ContentView.swift
//  WhereIsTheRestroom
//
//  Created by Taewon Yoon on 5/10/24.
//

import SwiftUI
import NMapsMap

extension Binding where Value == Bool {
    
    init<T>(value: Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}

struct ContentView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var location: Location
    
    var body: some View {
        NaverMapView()
            .ignoresSafeArea()
            .sheet(isPresented: Binding(value: $coordinator.tappedMarkerTag), content: {
                ToiletInfoView()
                    .presentationDetents([.fraction(0.35)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.35)))
            })
    }
    
}

struct NaverMapView: UIViewRepresentable {
    
    @EnvironmentObject var coordinator: Coordinator
    
    func makeCoordinator() -> Coordinator {
        return coordinator
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        return coordinator.view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        uiView.mapView.mapType = coordinator.mapType
    }
    
}

#Preview {
    ContentView()
        .environmentObject(Coordinator())
        .environmentObject(Location())
}
