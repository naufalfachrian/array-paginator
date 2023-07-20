# Swift Array Paginator

Brings FluentKit paginator for all array type!

## Installing

To use Swift Array Paginator, specify it in your `Package.swift`

``` swift
let package = Package(
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/naufalfachrian/array-paginator.git", branch: "release") // or specify the exact version (see tags)
    ],
    targets: [
        .target(
            dependencies: [
                // other dependencies
                .product(name: "ArrayPaginator", package: "array-paginator"),
            ]
        )
    ]
)
```

## Usage

``` swift
let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let page1 = array.paginate(page: 1, size: 3)
// page1.items will return [1, 2, 3]

let page4 = array.paginate(page: 4, size: 3)
// page4.items will return [10]

let page5 = array.paginate(page: 5, size: 3)
// page5.items will return []

let asString = array.paginate(page: 1, size: 5).map { String($0) }
// asString.items will return ["1", "2", "3", "4", "5"]

let pageCount = array.paginate(page: 1, size: 5).metadata.pageCount
// pageCount will return 2

let request = try JSONDecoder().decode(PageRequest.self, from: #"{"page": 1, "per": 5}"#.data(using: .utf8)!)
// request.page will return 1
// request.per will return 5
let items = array.paginate(for: reqeust).items
// items will return [1, 2, 3, 4, 5]
```

### Usage with Vapor's Request

#### Create a helper extension
``` swift
import Vapor
import ArrayPaginator

extension Array {
    
    func paginate(for req: Request) throws -> Page<Element> {
        let page = try req.query.decode(PageRequest.self)
        return self.paginate(withIndex: page.page, size: page.per)
    }

}
```

### Example usage with Vapor's Request
``` swift
import Vapor
import ArrayPaginator

struct MyController: RouteCollection {
    
    func index(req: Request) async throws -> Page<Int> {
        let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        return array.paginate(for: req)
    }
    
}
```
