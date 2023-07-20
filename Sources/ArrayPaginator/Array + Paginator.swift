// The MIT License (MIT)
// Copyright (c) 2023 Naufal Fachrian
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


extension Array {

    public func paginate(for req: PageRequest) -> Page<Element> {
        return self.paginate(page: req.page, size: req.per)
    }
    
    public func paginate(page: Int, size per: Int) -> Page<Element> {
        let count = self.count
        let trimmedRequest: PageRequest = {
            return .init(
                page: Swift.max(page, 1),
                per: Swift.max(Swift.min(per, count), 1)
            )
        }()
        if trimmedRequest.start >= count {
            return Page(
                items: [],
                metadata: .init(
                    page: trimmedRequest.page,
                    per: trimmedRequest.per,
                    total: count
                )
            )
        }
        let last = Swift.min(trimmedRequest.end, count)
        let items = self[trimmedRequest.start..<last]
        return Page(
            items: Array(items),
            metadata: .init(
                page: trimmedRequest.page,
                per: trimmedRequest.per,
                total: count
            )
        )
    }
    
}
