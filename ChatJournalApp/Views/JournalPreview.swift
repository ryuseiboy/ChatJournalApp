import SwiftUI

struct CustomGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.headline)
                .padding(.bottom, 5)
            configuration.content
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.secondary.opacity(0.1)))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 1))
    }
}

struct JournalPreview: View {
    @State var isExpanded: Bool = false
    @State private var images: [String?] = []
    @State var diaryText: String

    var body: some View {
        GroupBox(label: Label("User Information", systemImage: "person.circle")) {
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(images, id: \.self) { image in
                            if let image = image {
                                Image(systemName: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity, maxHeight: 100)
                            }
                        }
                    }
                }
                
                VStack {
                    Text(diaryText)
                        .frame(maxWidth: .infinity)
                        .lineLimit(isExpanded ? nil : 3)
                        .padding()
                        .onTapGesture {
                            isExpanded.toggle()
                        }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
        }
        .groupBoxStyle(DefaultGroupBoxStyle())
        .padding()
    }
}


#Preview {
    JournalPreview(diaryText: "あああああ\nあああああ\n\nあああああ\nあああああ\n\nあああああ")
}
