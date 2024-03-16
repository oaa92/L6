import SwiftUI
import Foundation

enum Orientation {
    case diagonal
    case horizontal
}

struct ContentView: View {

    let count: Int = 7
    @State var orientation: Orientation = .horizontal

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            ForEach(0..<count, id: \.self) { index in
                let x: CGFloat
                let y: CGFloat
                let rectSize: CGFloat
                switch orientation {
                case .horizontal:
                    let index = CGFloat(index)
                    let spacing: CGFloat = 8
                    let count = CGFloat(count)
                    rectSize = (size.width - (spacing * (count - 1))) / count
                    let offsetY = size.height / 2
                    x = rectSize * index + spacing * index
                    y = offsetY
                case .diagonal:
                    let index = CGFloat(index)
                    let count = CGFloat(count)
                    rectSize = size.height / count
                    let diffX = (size.height - size.width) / (count - 1)
                    let offsetX = size.height / count
                    x = offsetX * (count - index - 1) - diffX * (count - index - 1)
                    y = rectSize * index
                }

                let rectSize = makeRectSize()
                RoundedRectangle(cornerSize: CGSize(width: rectSize/4, height: rectSize/4))
                    .foregroundStyle(Color.blue)
                    .frame(width: rectSize, height: rectSize)
                    .offset(x: x, y: y)
            }

        }
        .background(Color.gray)
    }

    func makeRectSize(orientation: Orientation, size: CGSize) -> CGFloat {
        let count = CGFloat(count)
        switch orientation {
        case .horizontal:
            let spacing: CGFloat = 8
            return (size.width - (spacing * (count - 1))) / count
        case . diagonal:
            return size.height / count
        }
    }

    func makeOffset(orientation: Orientation, size: CGSize, index: Int) -> (CGFloat, CGFloat) {
        let index = CGFloat(index)
        let count = CGFloat(count)
        let rectSize = makeRectSize(orientation: orientation, size: size)
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
