//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Seun Adebanwo on 18/02/2023.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>
 
public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
