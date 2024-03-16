import SwiftUI
import Foundation

enum Orientation {
    case diagonal
    case horizontal
}

struct ContentView: View {

    static var count: Int = 7

    @State var orientation: Orientation = .horizontal
    @State var rectSize: CGFloat = 0
    @State var offsetsX: [CGFloat] = Array(repeating: 0, count: ContentView.count)
    @State var offsetsY: [CGFloat] = Array(repeating: 0, count: ContentView.count)
    @State var size: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<ContentView.count, id: \.self) { index in
                RoundedRectangle(cornerSize: CGSize(width: rectSize/8, height: rectSize/8))
                    .foregroundStyle(Color.blue)
                    .frame(width: rectSize, height: rectSize)
                    .offset(x: offsetsX[index], y: offsetsY[index])
            }
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    size = geometry.size
                    update(orientation: orientation)
                }
            })
        }
        .onTapGesture {
            let orientation: Orientation
            if self.orientation == .horizontal {
                orientation = .diagonal
            }
            else {
                orientation = .horizontal
            }
            withAnimation {
                update(orientation: orientation)
            }
        }
    }

    func update(orientation: Orientation) {
        self.orientation = orientation
        rectSize = makeRectSize(orientation: orientation)
        print(rectSize)
        for index in 0..<ContentView.count {
            let (x, y) = makeOffset(orientation: orientation, index: index)
            offsetsX[index] = x
            offsetsY[index] = y
        }
    }

    func makeRectSize(orientation: Orientation) -> CGFloat {
        let count = CGFloat(ContentView.count)
        switch orientation {
        case .horizontal:
            let spacing: CGFloat = 8
            return (size.width - (spacing * (count - 1))) / count
        case .diagonal:
            return size.height / count
        }
    }

    func makeOffset(orientation: Orientation, index: Int) -> (CGFloat, CGFloat) {
        let index = CGFloat(index)
        let count = CGFloat(ContentView.count)
        let rectSize = makeRectSize(orientation: orientation)
        switch orientation {
        case .horizontal:
            let spacing: CGFloat = 8
            return (rectSize * index + spacing * index, size.height / 2)
        case . diagonal:
            let diffX = (size.height - size.width) / (count - 1)
            let offsetX = size.height / count
            return (offsetX * (count - index - 1) - diffX * (count - index - 1), rectSize * index)
        }
    }
}

#Preview {
    ContentView()
}
