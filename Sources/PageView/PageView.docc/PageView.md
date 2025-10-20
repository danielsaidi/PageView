# ``PageView``

PageView is a custom SwiftUI page view that works on all major Apple platforms.


## Overview

![PageView logo](Logo.png)

``PageView/PageView`` is a custom SwiftUI page view that works on all major Apple platforms. It mimics a native, paged TabView and can be used in the same way on all major Apple platforms. 

The ``PageView/PageView`` component can be set up with a list of pages, a list of page model, or a ``PageViewState`` value. It can be customized in many ways, using custom styles and configurations.



## Installation

PageView can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/PageView.git
```



## Support My Work

You can [become a sponsor][Sponsors] to help me dedicate more time on my various [open-source tools][OpenSource]. Every contribution, no matter the size, makes a real difference in keeping these tools free and actively developed.



## Getting started

You can create a ``PageView`` with a collection of page views, an array of page items, or a ``PageViewState``.

```swift
struct MyView: View {

    @State var state = PageViewState(pages: Array(0...5))

    var body: some View {
        PageView(state) { page in
            VStack(spacing: 20) {
                Text("Page \(page)")
                Button(buttonTitle, action: nextPageOrRestart)
                    .padding(50)
                    .buttonStyle(.borderedProminent)
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
    }

    func color(for index: Int) -> Color {
        switch index {
        case 0: .red
        case 1: .green
        case 2: .blue
        case 3: .orange
        case 4: .pink
        case 5: .mint
        default: .purple
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
```

You can customize the page view animation with the ``SwiftUICore/View/pageViewAnimation(_:)`` view modifier, the page indicator display mode with ``SwiftUICore/View/pageViewIndicatorDisplayMode(_:)`` and its style with ``SwiftUICore/View/pageViewIndicatorStyle(_:)``.



## Repository

For more information, source code, etc., visit the [project repository](https://github.com/danielsaidi/PageView).



## License

PageView is available under the MIT license.



## Topics

### Essentials

- ``PageView``
- ``PageViewIndicator``
- ``PageViewState``



[Email]: mailto:daniel.saidi@gmail.com
[Website]: https://danielsaidi.com
[GitHub]: https://github.com/danielsaidi
[OpenSource]: https://danielsaidi.com/opensource
[Sponsors]: https://github.com/sponsors/danielsaidi
