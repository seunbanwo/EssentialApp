//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Seun Adebanwo on 19/02/2023.
//

import Foundation

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
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}

public final class RemoteFeedLoader {
    // `public` makes the class accessible from other modules
    // By making final you prevent subclassing
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping(Error) -> Void) {
        client.get(from: url) { error, response in
            if response != nil {
                completion(.invalidData)
            } else {
                completion(.connectivity)
            }
        }
    }
}
