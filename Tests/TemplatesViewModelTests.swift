import XCTest
@testable import SnapEditAI

final class TemplatesViewModelTests: XCTestCase {
    func testFilteredTemplatesMatchCategory() {
        let vm = TemplatesViewModel()
        vm.selectedCategory = .business
        XCTAssertTrue(vm.filteredTemplates.allSatisfy { $0.category == .business })
    }
}
