//
//  ContentView.swift
//  Demo
//
//  Created by Daniel Saidi on 2025-06-09.
//  Copyright © 2025 Kankoda Sweden AB. All rights reserved.
//

import PageView
import SwiftUI

struct ContentView: View {
    
    @State var state = PageViewState(pages: Array(0...5))

    var body: some View {
        PageView(state) { value in
            VStack(spacing: 20) {
                Text("Page \(value+1)")
                    .font(.title.bold())
                Text("This is page \(value+1)/\(state.pages.count)")
                    .font(.headline)
                Button(buttonTitle, action: nextPageOrRestart)
                    .padding(50)
                    .buttonStyle(.borderedProminent)
            }
        }
        .pageViewAnimation(.bouncy)
        .pageViewIndicatorDisplayMode(.automatic)
        .pageViewIndicatorStyle(.init(
            dotColor: .blue,
            dotSize: 10,
            currentDotColor: .yellow,
            currentDotSize: 15
        ))
        .fontDesign(.rounded)
        .background(
            ZStack {
                Color.black.ignoresSafeArea()
                color(for: state.pageIndex)
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .animation(.easeOut, value: state.pageIndex)
            }
        )
        .preferredColorScheme(.dark)
    }
}

extension ContentView {

    var buttonTitle: String {
        state.isLastPage ? "Restart" : "Next"
    }

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

    func nextPageOrRestart() {
        if state.isLastPage {
            state.pageIndex = 0
        } else {
            state.showNextPage()
        }
    }
}

#Preview {
    ContentView()
}
