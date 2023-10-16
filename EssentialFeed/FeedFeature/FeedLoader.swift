//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Seun Adebanwo on 18/02/2023.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure (Error)
}
 
public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
