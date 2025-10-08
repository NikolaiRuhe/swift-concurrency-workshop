import SwiftUI
import AppKit

@main struct RoboApp: App {
    var body: some Scene { WindowGroup { RoboView() } }
}


struct RoboView: View {
    @State var input: String = "Nikolai"
    @State var robo: Robo?

    struct Robo {
        var caption: String
        var image: NSImage
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            TextField("URL", text: $input)
                .font(.system(size: 18))
                .onChange(of: input, initial: true) { _, _ in
                    Task {
                        await loadRobo()
                    }
                }

            roboView

            Spacer()

            Text("Robots lovingly delivered by Robohash.org")
                .font(Font.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: 300)
        .padding()
    }

    @ViewBuilder var roboView: some View {
        Group {
            if let robo {
                Image(nsImage: robo.image)
            } else {
                ZStack { ProgressView() }
            }
        }
        .frame(width: 300, height: 300)
        .background(Color.white)
        .border(Color.black)
        .compositingGroup()
        .shadow(color: Color.black.opacity(0.3), radius: 10)

        Text(robo?.caption ?? "...")
    }

    func loadRobo() async {
        robo = nil

        let session = URLSession(configuration: .ephemeral)
        guard
            let url = URL(string: "https://robohash.org/" + input),
            let data = try? await session.data(from: url).0,
            let image = NSImage(data: data) else { return }

        robo = .init(caption: url.absoluteString, image: image)
    }
}
