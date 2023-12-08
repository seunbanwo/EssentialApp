//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Oluwaseun Adebanwo on 08/12/2023.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
