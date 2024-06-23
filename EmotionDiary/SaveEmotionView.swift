import SwiftUI

struct SaveEmotionView: View {
    @Binding var sadnessCount: Int
    @Binding var irritationCount: Int
    @Binding var painfulCount: Int
    @Binding var anxietyCount: Int
    
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var details: String = ""
    
    @EnvironmentObject var dataStore: EmotionDataStore
    
    var body: some View {
        VStack {
            TextField("タイトル", text: $title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            TextField("詳細", text: $details)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            Button("決定") {
                saveEmotionData()
                resetCounts()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .padding()
    }
    
    func saveEmotionData() {
        let counts = ["悲しみ": sadnessCount, "イライラ": irritationCount, "つらい": painfulCount, "不安": anxietyCount]
        dataStore.addEmotionData(title: title, details: details, counts: counts)
    }
    
    func resetCounts() {
        sadnessCount = 0
        irritationCount = 0
        painfulCount = 0
        anxietyCount = 0
    }
}
