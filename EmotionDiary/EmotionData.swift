import Foundation

struct EmotionData: Identifiable, Codable {
    var id = UUID()
    let date: Date
    let title: String
    let details: String
    let counts: [String: Int]
}

class EmotionDataStore: ObservableObject {
    @Published var emotionDataList: [EmotionData] = []
    
    init() {
        load()
    }
    
    func addEmotionData(title: String, details: String, counts: [String: Int]) {
        let newData = EmotionData(date: Date(), title: title, details: details, counts: counts)
        emotionDataList.append(newData)
        save()
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(emotionDataList) {
            UserDefaults.standard.set(data, forKey: "EmotionData")
        }
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: "EmotionData"),
           let list = try? JSONDecoder().decode([EmotionData].self, from: data) {
            emotionDataList = list
        }
    }
}
