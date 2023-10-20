//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Oluwaseun Adebanwo on 30/04/2023.
//

import Foundation

// By using the HTTPClientResult enum
// we end up with only two representable paths.
public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    // Theres no need to make the HTTPClient a singleton
    // or a shared instance, apart from convenience
    // to locate the instance directly
    // This is considered an anti pattern because it
    // can introduce tight coupling use DI instead
    // DI conforms to the open closed principle
    // and keeps the design modular
    //static var shared = HTTPCLient()
    
    // Use protocol instead of class.
    // This is just a contract defining which external functionality
    // the remote feed loader needs.
    // We dont need to create a new type to confirm it.
    // We can easily create an extension on URLSession
    // or AlamoFire to conform to the protocol
    // This ensures our RemoteFeedLoader does not have to depend
    // on concrete types like URLSession which makes it more flexible
    // and open for extension
    
    // In protocol you dont have implementation just the definition
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
