import XCTest
@testable import SnapEditAI

final class TemplatesViewModelTests: XCTestCase {
    func testFilteringBySelectedCategory() {
        let vm = TemplatesViewModel()
        vm.selectedCategory = .lifestyle
        XCTAssertTrue(vm.filteredTemplates.allSatisfy { $0.category == .lifestyle })
    }
}
