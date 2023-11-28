//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Oluwaseun Adebanwo on 28/11/2023.
//

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool

    var hasLocation: Bool {
        return location != nil
    }
}
