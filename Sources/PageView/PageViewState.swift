//
//  PageViewState.swift
//  PageView
//
//  Created by Daniel Saidi on 2022-03-30.
//  Copyright © 2022-2025 Daniel Saidi. All rights reserved.
//

import SwiftUI
import Combine

/// This class can be used to manage page view state, with a set of functions that
/// can handle navigation.
@Observable
public class PageViewState<PageModel> {

    /// Create a page view state instance.
    ///
    /// - Parameters:
    ///   - pages: The page view models to show.
    public init(
        pages: [PageModel]
    ) {
        self.pages = pages
    }

    /// The pages to display.
    public let pages: [PageModel]

    /// The current page index.
    public var pageIndex = 0 {
        didSet {
            guard isOutsideOfBounds else { return }
            pageIndex = min(max(0, pageIndex), pages.count - 1)
        }
    }
}

public extension PageViewState {

    /// Whether the state is at the first page.
    var isFirstPage: Bool {
        pageIndex <= 0
    }

    /// Whether the state is at the first page.
    var isLastPage: Bool {
        pageIndex >= pages.count - 1
    }

    /// Whether the page index is out of bounds.
    var isOutsideOfBounds: Bool {
        pageIndex < 0 || pageIndex >= pages.count
    }

    /// Show the previous page, if any.
    func showPreviousPage() {
        guard !isFirstPage else { return }
        pageIndex -= 1
    }

    /// Show the next page, if any.
    func showNextPage() {
        guard !isLastPage else { return }
        pageIndex += 1
    }
}
