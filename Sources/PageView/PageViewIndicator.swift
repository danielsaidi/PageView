//
//  PageIndicator.swift
//  PageView
//
//  Created by Daniel Saidi on 2022-03-30.
//  Copyright © 2022-2026 Daniel Saidi. All rights reserved.
//

import SwiftUI

/// This view can be used to display a horizontal collection of dots that are bound
/// to the pages in a ``PageView``.
///
/// Available view modifiers:
///   - ``SwiftUICore/View/pageViewIndicatorDisplayMode(_:)``
///   - ``SwiftUICore/View/pageViewIndicatorStyle(_:)``.
public struct PageViewIndicator: View {

    /// Create a page indicator.
    ///
    /// - Parameters:
    ///   - numberOfPages: The number of pages to display.
    ///   - currentPageIndex: A current page index binding.
    public init(
        numberOfPages: Int,
        currentPageIndex: Binding<Int>
    ) {
        self.numberOfPages = numberOfPages
        self.currentPageIndex = currentPageIndex
    }

    private let currentPageIndex: Binding<Int>
    private let numberOfPages: Int

    @Environment(\.pageViewIndicatorDisplayMode) var displayMode
    @Environment(\.pageViewIndicatorStyle) var style

    public var body: some View {
        HStack(spacing: style.dotSpacing) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Button {
                    setCurrentPage(index)
                } label: {
                    Circle()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: isCurrentPage(index) ? style.currentDotSize : style.dotSize)
                        .foregroundColor(isCurrentPage(index) ? style.currentDotColor : style.dotColor)
                }
                .buttonStyle(.plain)
            }
        }
    }
}


// MARK: - DisplayMode

public extension PageViewIndicator {

    /// This enum defines ``PageViewIndicator`` display modes.
    enum DisplayMode {

        /// Always display a page indicator regardless of page count.
        case always

        /// Display a page indicator when there are more than one page.
        case automatic

        /// Never display a page indicator.
        case never
    }
}


// MARK: - Style

public extension PageViewIndicator {

    /// This style can be used with a ``PageViewIndicator``.
    struct Style: Equatable, Sendable {

        /// Create a custom page view indicator style.
        ///
        /// - Parameters:
        ///   - dotColor: The dot color, by default `.white` with 0.5 opacity.
        ///   - dotSize: The dot size in points, by default `10`.
        ///   - currentDotColor: The current dot color, by default `.white`.
        ///   - currentDotSize: The current dot size in points, by default `10`.
        ///   - dotSpacing: The spacing to apply between dots, by default `nil`.
        public init(
            dotColor: Color = .white.opacity(0.5),
            dotSize: CGFloat = 7,
            dotSpacing: CGFloat? = nil,
            currentDotColor: Color = .white,
            currentDotSize: CGFloat = 7
        ) {
            self.dotColor = dotColor
            self.dotSize = dotSize
            self.dotSpacing = dotSpacing
            self.currentDotColor = currentDotColor
            self.currentDotSize = currentDotSize
        }

        /// The indicator current dot color.
        public var currentDotColor: Color

        /// The indicator current dot size.
        public var currentDotSize: CGFloat

        /// The indicator dot color.
        public var dotColor: Color

        /// The indicator dot size.
        public var dotSize: CGFloat

        /// The spacing to apply between dots.
        public var dotSpacing: CGFloat?
    }
}

public extension PageViewIndicator.Style {

    /// The standard page indicator style.
    static let standard = Self()
}

public extension EnvironmentValues {

    /// A ``PageViewIndicator/DisplayMode`` environment value.
    @Entry var pageViewIndicatorDisplayMode = PageViewIndicator.DisplayMode.automatic

    /// A ``PageViewIndicator/Style`` environment value.
    @Entry var pageViewIndicatorStyle = PageViewIndicator.Style.standard
}

public extension View {

    /// Inject a custom ``PageViewIndicator/DisplayMode`` value.
    func pageViewIndicatorDisplayMode(
        _ value: PageViewIndicator.DisplayMode
    ) -> some View {
        self.environment(\.pageViewIndicatorDisplayMode, value)
    }

    /// Inject a custom ``PageViewIndicator/Style`` value.
    func pageViewIndicatorStyle(
        _ value: PageViewIndicator.Style
    ) -> some View {
        self.environment(\.pageViewIndicatorStyle, value)
    }
}

private extension PageViewIndicator {
    
    func isCurrentPage(_ index: Int) -> Bool {
        index == currentPageIndex.wrappedValue
    }
    
    func setCurrentPage(_ index: Int) {
        currentPageIndex.wrappedValue = index
    }
}

#Preview {

    @Previewable @State var index = 0

    VStack(spacing: 20) {
        PageViewIndicator(
            numberOfPages: 10,
            currentPageIndex: $index
        )
        
        PageViewIndicator(
            numberOfPages: 5,
            currentPageIndex: $index
        )
        .pageViewIndicatorStyle(.init(
            dotColor: .blue,
            dotSize: 15,
            dotSpacing: 30,
            currentDotColor: .yellow,
            currentDotSize: 25
        ))
    }
    .padding()
    .background(Color.gray)
    .cornerRadius(20)
}
