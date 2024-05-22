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
    var body: some View {
        VStack {
            GroupBox(label: Label("User Information", systemImage: "person.circle")) {
                VStack(alignment: .leading) {
                    Text("Name: John Doe")
                    Text("Age: 29")
                    Text("Location: New York")
                }
                .padding()
            }
            .groupBoxStyle(DefaultGroupBoxStyle())
            .padding()

            GroupBox {
                Text("This is another group without a label.")
                    .padding()
            }
            .padding()
            
            GroupBox(label: Label("User Information", systemImage: "person.circle")) {
                VStack(alignment: .leading) {
                    Text("Name: John Doe")
                    Text("Age: 29")
                    Text("Location: New York")
                }
                .padding()
            }
            .groupBoxStyle(CustomGroupBoxStyle())
            .padding()
            
            Grid {
                GridRow {
                    Text("1")
                    Text("2")
                    Text("3")
                }
                GridRow {
                    Text("4")
                    Text("5")
                    Text("6")
                }
                GridRow {
                    Text("7")
                    Text("8")
                    Text("9")
                }
            }
            .padding()
        }
    }
}

#Preview {
        JournalPreview()
}
