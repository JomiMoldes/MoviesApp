//
// Created by MIGUEL MOLDES on 19/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import XCTest
import OHHTTPStubs

@testable import MoviesApp

class MALoadImageServiceTest : XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLoadImage() {

        stub(condition: isHost("image.tmdb.org")) {
            response in
            let image = UIImage(named: "testImage.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)
            let data = UIImagePNGRepresentation(image!)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }

        let expect = expectation(description: "ImageService")

        let service = MAService()
        MALoadImageService(service: service).execute(path: "anyImage.png", size: 92).then {
            image -> Void in

            XCTAssertNotNil(image)
            expect.fulfill()

        }.catch(policy: .allErrors) {
            error in
            XCTFail("Fail while loading image")
        }

        waitForExpectations(timeout: 1.0)

    }

}