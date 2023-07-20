// Copied from fluent-kit/Sources/FluentKit/Query/Builder/QueryBuilder+Paginate.swift
//
// The MIT License (MIT)
// Copyright (c) 2020 Qutheory, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


/// A single section of a larger, traversable result set.
public struct Page<T> {
    /// The page's items. Usually models.
    public let items: [T]

    /// Metadata containing information about current page, items per page, and total items.
    public let metadata: PageMetadata

    /// Creates a new `Page`.
    public init(items: [T], metadata: PageMetadata) {
        self.items = items
        self.metadata = metadata
    }

    /// Maps a page's items to a different type using the supplied closure.
    public func map<U>(_ transform: (T) throws -> (U)) rethrows -> Page<U> {
        try .init(
            items: self.items.map(transform),
            metadata: self.metadata
        )
    }
}

extension Page: Encodable where T: Encodable {}
extension Page: Decodable where T: Decodable {}

/// Metadata for a given `Page`.
public struct PageMetadata: Codable {
    /// Current page number. Starts at `1`.
    public let page: Int

    /// Max items per page.
    public let per: Int

    /// Total number of items available.
    public let total: Int
    
    /// Computed total number of pages with `1` being the minimum.
    public var pageCount: Int {
        let count = Int((Double(self.total)/Double(self.per)).rounded(.up))
        return count < 1 ? 1 : count
    }
    
    /// Creates a new `PageMetadata` instance.
    ///
    /// - Parameters:
    ///.  - page: Current page number.
    ///.  - per: Max items per page.
    ///.  - total: Total number of items available.
    public init(page: Int, per: Int, total: Int) {
        self.page = page
        self.per = per
        self.total = total
    }
}

/// Represents information needed to generate a `Page` from the full result set.
public struct PageRequest: Decodable {
    /// Page number to request. Starts at `1`.
    public let page: Int

    /// Max items per page.
    public let per: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case per = "per"
    }

    /// `Decodable` conformance.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 1
        self.per = try container.decodeIfPresent(Int.self, forKey: .per) ?? 10
    }

    /// Crates a new `PageRequest`
    /// - Parameters:
    ///   - page: Page number to request. Starts at `1`.
    ///   - per: Max items per page.
    public init(page: Int, per: Int) {
        self.page = page
        self.per = per
    }

    var start: Int {
        (self.page - 1) * self.per
    }

    var end: Int {
        self.page * self.per
    }
}
