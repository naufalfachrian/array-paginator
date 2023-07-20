import XCTest
@testable import ArrayPaginator

final class ArrayPaginatorTests: XCTestCase {
    func testExample() throws {
        let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        XCTAssertEqual(array.paginate(page: 1, size: 3).items, [1, 2, 3])
        XCTAssertEqual(array.paginate(page: 2, size: 3).items, [4, 5, 6])
        XCTAssertEqual(array.paginate(page: 3, size: 3).items, [7, 8, 9])
        XCTAssertEqual(array.paginate(page: 4, size: 3).items, [10])
        XCTAssertEqual(array.paginate(page: 5, size: 3).items, [])

        let asString = array.paginate(page: 1, size: 5).map { String($0) }
        XCTAssertEqual(asString.items, ["1", "2", "3", "4", "5"])

        let pageCount = array.paginate(page: 1, size: 5).metadata.pageCount
        XCTAssertEqual(pageCount, 2)

        let request = try JSONDecoder().decode(PageRequest.self, from: #"{"page": 1, "per": 5}"#.data(using: .utf8)!)
        XCTAssertEqual(request.page, 1)
        XCTAssertEqual(request.per, 5)
        XCTAssertEqual(array.paginate(for: request).items, [1, 2, 3, 4, 5])
    }
}
