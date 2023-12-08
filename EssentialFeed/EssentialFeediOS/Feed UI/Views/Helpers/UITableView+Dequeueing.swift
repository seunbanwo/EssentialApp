//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Oluwaseun Adebanwo on 29/11/2023.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
