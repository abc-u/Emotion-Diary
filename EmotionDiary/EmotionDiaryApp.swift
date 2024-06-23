import SwiftUI

@main
struct EmotionDiaryApp: App {
    @StateObject private var dataStore = EmotionDataStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
    }
}
