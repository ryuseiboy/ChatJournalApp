import SwiftUI

struct JournalPreview: View {
    let images: [String?]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray)
                .frame(width: .infinity, height: 100)
                .shadow(radius: 10)
                .padding(.horizontal)
            VStack{
                Text("あ")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.secondary)
                Text("a")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
        JournalPreview(images: ["image1"])
}
