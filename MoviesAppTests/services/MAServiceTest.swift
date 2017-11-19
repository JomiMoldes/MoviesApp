//
// Created by MIGUEL MOLDES on 19/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

//
// Created by MIGUEL MOLDES on 8/11/17.
// Copyright (c) 2017 MIGUEL MOLDES. All rights reserved.
//

import Foundation
import XCTest
import OHHTTPStubs

@testable import MoviesApp

class MAServiceTest : XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRequest() {

        stub(condition: isHost("api.themoviedb.org")) {
            response in
            let path = OHPathForFile("Movies.json", type(of: self))
            return OHHTTPStubsResponse(fileAtPath: path!, statusCode: 200, headers: ["Content-Type":"application/json"])
        }

        let service = MAService()
        let request = MARequest(requestType: .get, path: "https://api.themoviedb.org/Movies")

        let expect = expectation(description: "service")

        service.execute(request, nil).then {
            response -> Void in

            XCTAssertTrue(response.result.isSuccess)
            expect.fulfill()
        }.catch(policy: .allErrors) {
            error in
            XCTFail("MAServiceTest - testRequest")
        }

        waitForExpectations(timeout: 1.0)

    }

    func testExecuteData() {

        stub(condition: isHost("image.tmdb.org")) {
            response in
            return OHHTTPStubsResponse(data: Data(), statusCode:200, headers:nil)
        }

        let service = MAService()
        let request = MARequest(requestType: .get, path: "https://image.tmdb.org/t/p/w500/1yeVJox3rjo2jBKrrihIMj7uoS9.jpg")

        let expect = expectation(description: "service")

        service.executeData(request, nil).then {
            data -> Void in

            XCTAssertNotNil(data)
            expect.fulfill()
        }.catch(policy: .allErrors) {
            error in
            XCTFail("MAServiceTest - testExecuteData")
        }

        waitForExpectations(timeout: 1.0)


    }

}
