import SwiftUI
import Charts

struct HistoryView: View {
    @EnvironmentObject var dataStore: EmotionDataStore
    
    var body: some View {
        List(dataStore.emotionDataList) { data in
            VStack(alignment: .leading) {
                Text(data.title)
                    .font(.headline)
                Text(data.date, style: .date)
                    .font(.subheadline)
                Chart(data.counts.sorted(by: >), id: \.key) { key, value in
                    BarMark(
                        x: .value("Emotion", key),
                        y: .value("Count", value)
                    )
                    .foregroundStyle(by: .value("Emotion", key))
                }
                .chartForegroundStyleScale([
                    "悲しみ": Color.blue,
                    "イライラ": Color.orange,
                    "つらい": Color.gray,
                    "不安": Color.purple
                ])
                .frame(height: 200)
                .padding()
                Text(data.details)
                    .font(.body)
            }
            .padding()
        }
    }
}
