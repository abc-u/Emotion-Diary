import SwiftUI
import Charts

struct BarGraphView: View {
    var emotionCounts: [String: Int]
    
    var body: some View {
        Chart(emotionCounts.sorted(by: >), id: \.key) { key, value in
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
    }
}
