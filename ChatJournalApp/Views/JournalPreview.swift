import SwiftUI

struct JournalPreview: View {
    let images: [String?]

    var body: some View {
        VStack {
            HStack {
                Text("ああ")
                    .font(.title)
                    .padding()
                Spacer()
                Text("4月29日 月曜日")
                    .padding()
            }
        }
    }
}


struct JournalPreview_Previews: PreviewProvider {
    static var previews: some View {
        JournalPreview(images: <#[String?]#>)
    }
}
