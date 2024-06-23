import SwiftUI

struct ContentView: View {
    @State private var sadnessCount = 0
    @State private var irritationCount = 0
    @State private var painfulCount = 0
    @State private var anxietyCount = 0
    
    @State private var showSaveView = false
    @State private var showHistoryView = false
    
    @State private var currentEmotion: String? = nil
    @State private var showEmotionIcon = false
    @State private var emotionIconTimer: Timer? = nil
    
    @EnvironmentObject var dataStore: EmotionDataStore
    
    var emotionCounts: [String: Int] {
        return [
            "悲しみ": sadnessCount,
            "イライラ": irritationCount,
            "つらい": painfulCount,
            "不安": anxietyCount
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            EmotionButton(color: .blue, emotion: "悲しみ", count: $sadnessCount, size: geometry.size.width / 2 - 24, onPress: showEmotionIconButton)
                            EmotionButton(color: .orange, emotion: "イライラ", count: $irritationCount, size: geometry.size.width / 2 - 24, onPress: showEmotionIconButton)
                        }
                        HStack(spacing: 16) {
                            EmotionButton(color: .gray, emotion: "つらい", count: $painfulCount, size: geometry.size.width / 2 - 24, onPress: showEmotionIconButton)
                            EmotionButton(color: .purple, emotion: "不安", count: $anxietyCount, size: geometry.size.width / 2 - 24, onPress: showEmotionIconButton)
                        }
                    }
                    .padding()
                    .frame(height: geometry.size.height / 2)
                    
                    Spacer()
                    
                    BarGraphView(emotionCounts: emotionCounts)
                    
                    HStack {
                        if sadnessCount > 0 || irritationCount > 0 || painfulCount > 0 || anxietyCount > 0 {
                            Button(action: {
                                showSaveView = true
                            }) {
                                Text("保存")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                                    .font(.title)
                            }
                            .padding()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showHistoryView = true
                        }) {
                            Text("履歴")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .font(.title)
                        }
                        .padding()
                    }
                    .padding([.leading, .trailing], 16)
                }
                
                if let currentEmotion = currentEmotion {
                    EmotionIcon(emotion: currentEmotion, count: emotionCount(for: currentEmotion), width: geometry.size.width / 2, height: geometry.size.width / 2, backgroundColor: backgroundColor(for: currentEmotion)) {
                        addEntry(emotion: currentEmotion)
                        resetIconHideTimer()
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 4)
                }
            }
            .sheet(isPresented: $showSaveView) {
                SaveEmotionView(sadnessCount: $sadnessCount, irritationCount: $irritationCount, painfulCount: $painfulCount, anxietyCount: $anxietyCount)
                    .environmentObject(dataStore)
            }
            .sheet(isPresented: $showHistoryView) {
                HistoryView()
                    .environmentObject(dataStore)
            }
        }
    }
    
    func showEmotionIconButton(emotion: String) {
        currentEmotion = emotion
        showEmotionIcon = true
        resetIconHideTimer()
    }
    
    func resetIconHideTimer() {
        emotionIconTimer?.invalidate()
        emotionIconTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            withAnimation {
                showEmotionIcon = false
                currentEmotion = nil
            }
        }
    }
    
    func addEntry(emotion: String) {
        switch emotion {
        case "悲しみ":
            sadnessCount += 1
        case "イライラ":
            irritationCount += 1
        case "つらい":
            painfulCount += 1
        case "不安":
            anxietyCount += 1
        default:
            break
        }
    }
    
    func emotionCount(for emotion: String) -> Int {
        switch emotion {
        case "悲しみ":
            return sadnessCount
        case "イライラ":
            return irritationCount
        case "つらい":
            return painfulCount
        case "不安":
            return anxietyCount
        default:
            return 0
        }
    }
    
    func backgroundColor(for emotion: String) -> Color {
        switch emotion {
        case "悲しみ":
            return Color.blue.opacity(0.7)
        case "イライラ":
            return Color.orange.opacity(0.7)
        case "つらい":
            return Color.gray.opacity(0.7)
        case "不安":
            return Color.purple.opacity(0.7)
        default:
            return Color.clear
        }
    }
}

struct EmotionButton: View {
    var color: Color
    var emotion: String
    @Binding var count: Int
    var size: CGFloat
    var onPress: (String) -> Void
    
    var body: some View {
        Button(action: {
            count += 1
            onPress(emotion)
        }) {
            Text(emotion)
                .font(.title) // フォントサイズを大きく設定
                .foregroundColor(.white)
                .frame(width: size, height: size)
                .background(color)
                .cornerRadius(10)
        }
    }
}

struct EmotionIcon: View {
    var emotion: String
    var count: Int
    var width: CGFloat
    var height: CGFloat
    var backgroundColor: Color
    var onTap: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: onTap) {
                Image(imageName(for: emotion, count: count)) // 感情の押した回数に応じたアイコンを表示
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .background(backgroundColor)
                    .cornerRadius(10)
            }
            Spacer()
        }
    }
    
    func imageName(for emotion: String, count: Int) -> String {
        let imageName: String
        if count >= 100 {
            imageName = "\(emotion)_person_5"
        } else if count >= 50 {
            imageName = "\(emotion)_person_4"
        } else if count >= 25 {
            imageName = "\(emotion)_person_3"
        } else if count >= 10 {
            imageName = "\(emotion)_person_2"
        } else {
            imageName = "\(emotion)_person_1"
        }
        return imageName.replacingOccurrences(of: "悲しみ", with: "sad")
                       .replacingOccurrences(of: "イライラ", with: "angry")
                       .replacingOccurrences(of: "つらい", with: "painful")
                       .replacingOccurrences(of: "不安", with: "anxious")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(EmotionDataStore())
    }
}
