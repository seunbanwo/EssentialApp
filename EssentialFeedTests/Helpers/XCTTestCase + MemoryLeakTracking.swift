//
//  XCTTestCase + MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by Oluwaseun Adebanwo on 30/05/2023.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line : UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated, Potential memory leak.", file: file, line: line)
        }
    }
}
