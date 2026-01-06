//
//  PageView.swift
//  PageView
//
//  Created by Daniel Saidi on 2022-03-30.
//  Copyright © 2022-2026 Daniel Saidi. All rights reserved.
//

import SwiftUI
import Combine

/// This custom page view can be used on all major Apple platforms.
///
/// This view mimics a native paged tab view and can be used in the same way. It
/// can be created with page views, page models or a ``PageViewState``.
///
/// This view wraps its content in a scroll view and applies arrow key bindings and
/// gestures to support keyboard arrow navigation, edge taps and swipes.
///
/// Available view modifiers:
///   - ``SwiftUICore/View/pageViewAnimation(_:)``
///   - ``SwiftUICore/View/pageViewIndicatorDisplayMode(_:)``
///   - ``SwiftUICore/View/pageViewIndicatorStyle(_:)``
///
/// > Important: Since gestures are applied to the background view, you shouldn't
/// apply a background to the pages within this view. Instead, apply a background
/// to the entire page view. You can vary the background based on the page index.
public struct PageView<PageViewType: View>: View {

    /// Create a page view with a list of views.
    ///
    /// - Parameters:
    ///   - pages: The page views to show.
    ///   - pageIndex: A page index binding.
    public init(
        pages: [PageViewType],
        pageIndex: Binding<Int>
    ) {
        self.pageIndex = pageIndex
        self.pages = pages
    }

    /// Create a page view with a list of values.
    ///
    /// - Parameters:
    ///   - pages: The page values to show.
    ///   - pageIndex: A page index binding.
    ///   - pageBuilder: A page view builder.
    public init<Model>(
        pages: [Model],
        pageIndex: Binding<Int>,
        @ViewBuilder pageBuilder: (Model) -> PageViewType
    ) {
        self.pageIndex = pageIndex
        self.pages = pages.map(pageBuilder)
    }

    /// Create a page view with a page view state value.
    ///
    /// - Parameters:
    ///   - state: A page index binding.
    ///   - pageBuilder: A page view builder.
    public init<Model>(
        _ state: PageViewState<Model>,
        @ViewBuilder pageBuilder: (Model) -> PageViewType
    ) {
        self.init(
            pages: state.pages,
            pageIndex: .init(
                get: { state.pageIndex },
                set: { state.pageIndex = $0 }
            ),
            pageBuilder: pageBuilder
        )
    }

    private var pageIndex: Binding<Int>
    private var pages: [PageViewType]

    @Environment(\.layoutDirection) var layoutDirection

    @Environment(\.pageViewAnimation) var pageViewAnimation
    @Environment(\.pageViewIndicatorDisplayMode) var pageIndicatorDisplayMode

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                ScrollViewReader { scroll in
                    ScrollView(.horizontal) {
                        pageStack(for: geo)
                    }
                    .prefersScrollAdjustments(
                        for: scroll,
                        layoutDirection: layoutDirection,
                        showPrevious: { showPreviousPage() },
                        showNext: { showNextPage() }
                    )
                    .onReceive(Just(pageIndex)) { index in
                        withAnimation(pageViewAnimation) {
                            scroll.scrollTo(index.wrappedValue)
                        }
                    }
                    .overlay(bugfixLayer(for: scroll))
                }
                pageIndicator
            }
        }
    }
}

public extension EnvironmentValues {

    /// Inject a custom page view animation value.
    @Entry var pageViewAnimation: Animation = .linear
}

public extension View {

    /// Inject a custom page view animation value.
    func pageViewAnimation(
        _ value: Animation
    ) -> some View {
        self.environment(\.pageViewAnimation, value)
    }
}

private extension View {

    @ViewBuilder
    func prefersScrollAdjustments(
        for scroll: ScrollViewProxy,
        layoutDirection: LayoutDirection,
        showPrevious: @escaping () -> Void,
        showNext: @escaping () -> Void
    ) -> some View {
        #if os(iOS) || os(watchOS) || os(visionOS)
        if #available(iOS 16.0, watchOS 9.0, *) {
            self.scrollDisabled(true)
        } else {
            self
        }
        #else
        if #available(macOS 13.0, tvOS 16.0, *) {
            self.scrollDisabled(true)
                .onMoveCommand { direction in
                    switch direction.adjusted(for: layoutDirection) {
                    case .left: showPrevious()
                    case .right: showNext()
                    default: break
                    }
                }
        } else {
            self
        }
        #endif
    }
}

#if os(macOS) || os(tvOS)
private extension MoveCommandDirection {

    func adjusted(
        for direction: LayoutDirection
    ) -> Self {
        switch self {
        case .left: direction == .leftToRight ? .left : .right
        case .right: direction == .leftToRight ? .right : .left
        default: self
        }
    }
}
#endif

private extension PageView {

    @ViewBuilder
    var pageIndicator: some View {
        if shouldShowPageIndicator {
            PageViewIndicator(
                numberOfPages: pages.count,
                currentPageIndex: pageIndex
            )
            .padding()
        } else {
            EmptyView()
        }
    }

    // This is needed for the scroll view transition to play.
    func bugfixLayer(for scroll: ScrollViewProxy) -> some View {
        Text("\(pageIndex.wrappedValue)")
            .opacity(0)
    }

    func pageStack(
        for geo: GeometryProxy
    ) -> some View {
        HStack {
            ForEach(Array(pages.enumerated()), id: \.offset) {
                $0.element
                    .id($0.offset)
                    .tag($0.offset)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .background(gestureLayer)
            }
        }
    }
    
    var gestureLayer: some View {
        #if os(tvOS)
        EmptyView()
        #else
        HStack(spacing: 0) {
            gestureLayerView(onTap: showPreviousPage)
            gestureLayerView(onTap: showNextPage)
        }
        #endif
    }

    #if !os(tvOS)
    func gestureLayerView(
        onTap: @escaping () -> Void
    ) -> some View {
        Color.white.opacity(0.00001)
            .onSwipeGesture(
                left: { showNextPage() },
                right: { showPreviousPage() }
            )
            .simultaneousGesture(
                TapGesture().onEnded(onTap)
            )
    }
    #endif
}

private extension PageView {
    
    var shouldShowPageIndicator: Bool {
        switch pageIndicatorDisplayMode {
        case .always: true
        case .automatic: pages.count > 1
        case .never: false
        }
    }

    func setPageIndex(to index: Int) {
        pageIndex.wrappedValue = index
    }
    
    func showNextPage() {
        guard pageIndex.wrappedValue < pages.count - 1 else { return }
        setPageIndex(to: pageIndex.wrappedValue + 1)
    }
    
    func showPreviousPage() {
        guard pageIndex.wrappedValue > 0 else { return }
        setPageIndex(to: pageIndex.wrappedValue - 1)
    }
}

#Preview {

    @Previewable @State var state = PageViewState(pages: Array(0...5))

    return PageView(state) { value in
        VStack(spacing: 20) {
            Text("Page \(value)")
            HStack {
                Button("Next", action: state.showNextPage)
                    .buttonStyle(.borderedProminent)
            }
        }
    }
    .pageViewAnimation(.bouncy)
    .pageViewIndicatorDisplayMode(.automatic)
    .pageViewIndicatorStyle(.init(
        dotColor: .blue,
        currentDotColor: .yellow
    ))
    .background(
        color(for: state.pageIndex)
            .ignoresSafeArea()
            .animation(.easeOut, value: state.pageIndex)
    )

    func color(for index: Int) -> Color {
        switch index {
        case 0: .red
        case 1: .green
        case 2: .purple
        case 3: .orange
        case 4: .pink
        case 5: .mint
        default: .black
        }
    }
}
