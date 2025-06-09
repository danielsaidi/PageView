//
//  PageIndicator.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2022-03-30.
//  Copyright © 2022-2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

/// This view can be used to display a horizontal collection
/// of dots that are bound to pages in a ``PageView``.
///
/// You can style the view with a ``PageViewIndicatorStyle``.
public struct PageViewIndicator: View {

    /// Create a page indicator.
    ///
    /// - Parameters:
    ///   - numberOfPages: The number of pages to display.
    ///   - currentPageIndex: The current page index.
    ///   - style: The style to apply to the indicator.
    public init(
        numberOfPages: Int,
        currentPageIndex: Binding<Int>,
        style: PageViewIndicatorStyle = .standard
    ) {
        self.numberOfPages = numberOfPages
        self.currentPageIndex = currentPageIndex
        self.style = style
    }
    
    /// This enum mimics `PageTabViewStyle.IndexDisplayMode`.
    public enum DisplayMode {

        /// Always display a page indicator regardless of page count.
        case always
        
        /// Display a page indicator when there are more than one page.
        case automatic
        
        /// Never display a page indicator.
        case never
    }

    private let currentPageIndex: Binding<Int>
    private let numberOfPages: Int
    private let style: PageViewIndicatorStyle

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

private extension PageViewIndicator {
    
    func isCurrentPage(_ index: Int) -> Bool {
        index == currentPageIndex.wrappedValue
    }
    
    func setCurrentPage(_ index: Int) {
        if style.isAnimated {
            withAnimation { currentPageIndex.wrappedValue = index }
        } else {
            currentPageIndex.wrappedValue = index
        }
    }
}

#Preview {
    
    VStack(spacing: 20) {
        PageViewIndicator(
            numberOfPages: 10,
            currentPageIndex: .constant(3)
        )
        
        PageViewIndicator(
            numberOfPages: 5,
            currentPageIndex: .constant(3),
            style: PageViewIndicatorStyle(
                dotColor: .blue,
                dotSpacing: 20,
                currentDotColor: .yellow
            )
        )
    }
    .padding()
    .background(Color.gray)
    .cornerRadius(20)
}
