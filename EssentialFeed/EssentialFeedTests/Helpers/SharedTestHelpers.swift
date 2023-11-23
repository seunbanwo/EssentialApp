//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Oluwaseun Adebanwo on 20/10/2023.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
