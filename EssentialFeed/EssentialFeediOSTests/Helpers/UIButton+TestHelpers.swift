//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Oluwaseun Adebanwo on 27/11/2023.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
