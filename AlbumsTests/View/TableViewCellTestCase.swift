//
//  TableViewCellTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 3/21/15.
//  Copyright (c) 2015 eBay Software Foundation. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest

final class TableViewCell_BeachBoysAlbumTestDouble: NSObject, TDD_TableViewCell_AlbumType {
    
    let artist = "Beach Boys"
    
    let image = "http://localhost/pet-sounds.jpeg"
    
    let name = "Pet Sounds"
    
}

final class TableViewCell_BeatlesAlbumTestDouble: NSObject, TDD_TableViewCell_AlbumType {
    
    let artist = "Beatles"
    
    let image = "http://localhost/rubber-soul.jpeg"
    
    let name = "Rubber Soul"
    
}

final class TableViewCell_BlankAlbumTestDouble: NSObject, TDD_TableViewCell_AlbumType {
    
    var artist: String?
    
    var image: String?
    
    var name: String?
    
}

var TableViewCell_ImageOperationTestDouble_Self: TableViewCell_ImageOperationTestDouble?

final class TableViewCell_ImageOperationTestDouble: NSObject, TDD_TableViewCell_ImageOperationType {
    
    override init() {
        
        super.init()
        
        TableViewCell_ImageOperationTestDouble_Self = self
        
    }
    
    var didCancel = false
    
    var completionHandler: TDD_NetworkImageOperation_CompletionHandler?
    
    var request: NSURLRequest?
    
    func cancel() {
        
        self.didCancel = true
        
    }
    
    func startWithRequest(request: NSURLRequest, completionHandler: TDD_NetworkImageOperation_CompletionHandler) {
        
        self.request = request
        
        self.completionHandler = completionHandler
        
    }
    
}

final class TableViewCellTestCase: XCTestCase {
    
    lazy var beachBoys = TableViewCell_BeachBoysAlbumTestDouble()
    
    lazy var beatles = TableViewCell_BeatlesAlbumTestDouble()
    
    lazy var blank = TableViewCell_BlankAlbumTestDouble()
    
    lazy var cell = TableViewCellTestDouble(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
    
    lazy var image = UIImage()
    
}

extension TableViewCellTestCase {
    
    func assertAlbumBeachBoys() {
        
        self.assertCell(self.beachBoys)
        
        self.assertOperation(self.beachBoys)
        
    }
    
    func assertAlbumBeatles() {
        
        self.assertCell(self.beatles)
        
        self.assertOperation(self.beatles)
        
    }
    
    func assertAlbumBlank() {
        
        let imageOperation = TableViewCell_ImageOperationTestDouble_Self!
        
        self.assertCell(self.blank)
        
        XCTAssert(TableViewCell_ImageOperationTestDouble_Self!.didCancel)
        
    }
    
    func assertAlbumBlankByItself() {
        
        self.assertCell(self.blank)
        
        XCTAssert(TableViewCell_ImageOperationTestDouble_Self == nil)
        
    }
    
    func assertCell(album: TDD_TableViewCell_AlbumType) {
        
        self.cell.album = album
        
        XCTAssert(self.cell.textLabel!.text == album.artist)
        
        XCTAssert(self.cell.detailTextLabel!.text == album.name)
        
        XCTAssert(self.cell.imageView!.image == nil)
        
    }
    
    func assertOperation(album: TDD_TableViewCell_AlbumType) {
        
        XCTAssert(TableViewCell_ImageOperationTestDouble_Self!.request!.URL!.absoluteString == album.image)
        
        XCTAssert(TableViewCell_ImageOperationTestDouble_Self!.request!.cachePolicy == NSURLRequestCachePolicy.UseProtocolCachePolicy)
        
        XCTAssert(TableViewCell_ImageOperationTestDouble_Self!.request!.timeoutInterval == 60.0)
        
        self.cell.didSetNeedsLayout = false
        
        TableViewCell_ImageOperationTestDouble_Self!.completionHandler!(self.image, nil)
        
        XCTAssert(self.cell.imageView!.image! === self.image)
        
        XCTAssert(self.cell.didSetNeedsLayout)
        
    }
    
    func testAlbum() {
        
        self.assertAlbumBlankByItself()
        
        self.assertAlbumBeachBoys()
        
        self.assertAlbumBeatles()
        
        self.assertAlbumBlank()
        
    }
    
}

extension TableViewCellTestCase {
    
    func testClass() {
        
        XCTAssert(TDD_TableViewCell.imageOperationClass()! === TDD_NetworkImageOperation.self)
        
    }
    
}

final class TableViewCellTestDouble: TDD_TableViewCell {
    
    var didSetNeedsLayout = false
    
    override class func imageOperationClass() -> AnyClass {
        
        return TableViewCell_ImageOperationTestDouble.self
        
    }
    
    override func setNeedsLayout() {
        
        super.setNeedsLayout()
        
        self.didSetNeedsLayout = true
        
    }
    
}
