import PageView
import Testing

class PageViewStateTests {

    @Test func handlesPageIndexOverflow() async throws {
        let state = PageViewState(pages: Array(0..<5))
        #expect(state.pages.count == 5)
        #expect(state.pageIndex == 0)
        #expect(state.isFirstPage == true)
        #expect(state.isLastPage == false)
        state.showPreviousPage()
        #expect(state.pageIndex == 0)
        state.showNextPage()
        #expect(state.pageIndex == 1)
        state.showNextPage()
        state.showNextPage()
        state.showNextPage()
        state.showNextPage()
        state.showNextPage()
        state.showNextPage()
        state.showNextPage()
        state.showNextPage()
        #expect(state.pageIndex == 4)
        #expect(state.isFirstPage == false)
        #expect(state.isLastPage == true)
    }
}
