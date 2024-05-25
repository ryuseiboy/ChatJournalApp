import SwiftUI

enum SubContentType {
    case left
    case right
    case nothing
}

struct SwipeableStack<
    MainContent:View,
    RightSubContent:View,
    LeftSubContent:View
>: View {
    @State private var translationWidth: CGFloat = 0
    @State private var endedTranslationWidth: CGFloat = 0
    @State private var subContentType: SubContentType = .nothing
    @State private var subContentBackgroundColor: Color = .white

    private let mainContent: MainContent
    private let rightSubContent: RightSubContent
    private let leftSubContent: LeftSubContent
    private let rightSubContentWidth: CGFloat
    private let leftSubContentWidth: CGFloat
    private let mainContentBackgroundColor: Color
    private let rightSubContentBackgroundColor: Color
    private let leftSubContentBackgroundColor: Color
    private let parentCornerRadius: CGFloat

    init(
        @ViewBuilder mainContent: () -> MainContent,
        @ViewBuilder rightSubContent: () -> RightSubContent,
        @ViewBuilder leftSubContent: () -> LeftSubContent,
        rightSubContentWidth: CGFloat,
        leftSubContentWidth: CGFloat,
        mainContentBackgroundColor: Color,
        rightSubContentBackgroundColor: Color,
        leftSubContentBackgroundColor: Color,
        parentCornerRadius: CGFloat = 0
    ) {
        self.mainContent = mainContent()
        self.rightSubContent = rightSubContent()
        self.leftSubContent = leftSubContent()
        self.rightSubContentWidth = rightSubContentWidth
        self.leftSubContentWidth = leftSubContentWidth
        self.mainContentBackgroundColor = mainContentBackgroundColor
        self.rightSubContentBackgroundColor = rightSubContentBackgroundColor
        self.leftSubContentBackgroundColor = leftSubContentBackgroundColor
        self.parentCornerRadius = parentCornerRadius
    }

    var body: some View {
        ZStack {
            HStack {
                leftSubContent
                    .frame(
                        maxWidth: leftSubContentWidth,
                        maxHeight: .infinity
                    )
                    .offset(x: calcLeftSubContentWidth(), y: 0)
                    .animation(
                        .spring(response: 0.6),
                        value: endedTranslationWidth
                    )
                    .clipped()
                Spacer()
                rightSubContent
                    .frame(
                        maxWidth: rightSubContentWidth,
                        maxHeight: .infinity
                    )
                    .offset(x: calcRightSubContentWidth(), y: 0)
                    .animation(
                        .spring(response: 0.6),
                        value: endedTranslationWidth
                    )
                    .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(subContentBackgroundColor)

            mainContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(mainContentBackgroundColor)
                .offset(x: translationWidth, y: 0)
                .animation(
                    .spring(response: 0.6),
                    value: endedTranslationWidth
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            translationWidth = calcChangedWidth(
                                width: value.translation.width
                            )
                            changeSubContentBackgroundColor()
                        }
                        .onEnded { value in
                            endedTranslationWidth = value.translation.width
                            let width = calcChangedWidth(
                                width: value.translation.width
                            )
                            changeSubContentType(width: width)

                            switch subContentType {
                            case .left:
                                translationWidth = leftSubContentWidth
                            case .right:
                                translationWidth =
                                        rightSubContentWidth * -1
                            case .nothing:
                                translationWidth = 0
                            }
                        }
                )
                .clipped()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(parentCornerRadius)
    }

    private func calcRightSubContentWidth() -> CGFloat {
        let width = rightSubContentWidth + translationWidth
        if width <= 0 {
            return 0
        }
        return width
    }

    private func calcLeftSubContentWidth() -> CGFloat {
        let width = (leftSubContentWidth * -1) + translationWidth
        if width >= 0 {
            return 0
        }
        return width
    }

    private func changeSubContentBackgroundColor() {
        if translationWidth < 0 {
            subContentBackgroundColor = rightSubContentBackgroundColor
        } else if translationWidth > 0 {
            subContentBackgroundColor = leftSubContentBackgroundColor
        }
    }

    private func calcChangedWidth(width: CGFloat) -> CGFloat {
        switch subContentType {
        case .left:
            return width + leftSubContentWidth
        case .right:
            return width + rightSubContentWidth * -1
        case .nothing:
            return width
        }
    }

    private func changeSubContentType(width: CGFloat) {
        if width < 0 {
            if width <= rightSubContentWidth / 2 * -1 {
                subContentType = .right
            } else {
                subContentType = .nothing
            }
        } else if width > 0 {
            if width >= leftSubContentWidth / 2 {
                subContentType = .left
            } else {
                subContentType = .nothing
            }
        } else {
            subContentType = .nothing
        }
    }
}

struct SwipeableStack_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 100) {
            SwipeableStack(
                mainContent: { Text("main") },
                rightSubContent: { Text("rightSub") },
                leftSubContent: { Text("leftSub") },
                rightSubContentWidth: 80,
                leftSubContentWidth: 80,
                mainContentBackgroundColor: .gray,
                rightSubContentBackgroundColor: .red,
                leftSubContentBackgroundColor: .red
            )
            .frame(width: 250, height: 80)

            SwipeableStack(
                mainContent: {
                    HStack(spacing: 20) {
                        Text("SampleText")
                            .font(.title)
                        Image(systemName: "hand.thumbsup.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                },
                rightSubContent: {
                    HStack(spacing: 0) {
                        Button(action: { print("ButtonA") }) {
                            Text("ButtonA")
                        }
                        .padding()
                        .frame(maxHeight: .infinity)
                        .accentColor(Color.white)
                        .background(Color.blue)

                        Button(action: { print("ButtonB") }) {
                            Text("ButtonB")
                        }
                        .padding()
                        .frame(maxHeight: .infinity)
                        .accentColor(Color.white)
                        .background(Color.red)
                        
                        Button(action: { print("ButtonC") }) {
                            Text("ButtonC")
                        }
                        .padding()
                        .frame(maxHeight: .infinity)
                        .accentColor(Color.white)
                        .background(Color.yellow)
                    }
                },
                leftSubContent: { Text("leftSub") },
                rightSubContentWidth: 170,
                leftSubContentWidth: 80,
                mainContentBackgroundColor: .brown,
                rightSubContentBackgroundColor: .blue,
                leftSubContentBackgroundColor: .red,
                parentCornerRadius: 10
            )
            .frame(height: 80)
            .padding(.horizontal, 10)
            
            SwipeableStack(
                mainContent: {
                    Image(systemName: "hand.thumbsup.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                },
                rightSubContent: { Text("Good") },
                leftSubContent: { Text("Good") },
                rightSubContentWidth: 80,
                leftSubContentWidth: 80,
                mainContentBackgroundColor: .white,
                rightSubContentBackgroundColor: .cyan,
                leftSubContentBackgroundColor: .cyan
            )
            .frame(width: 150, height: 80)
        }
    }
}
