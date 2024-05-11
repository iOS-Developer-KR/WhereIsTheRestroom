//
//  WhereIsTheRestroomApp.swift
//  WhereIsTheRestroom
//
//  Created by Taewon Yoon on 5/10/24.
//

import SwiftUI
import CoreLocation

@main
struct WhereIsTheRestroomApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    CLLocationManager().requestWhenInUseAuthorization()
                }
                .environmentObject(Coordinator())
                .environmentObject(Location())

        }
    }
}
