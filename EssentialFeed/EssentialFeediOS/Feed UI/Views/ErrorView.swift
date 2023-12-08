//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Oluwaseun Adebanwo on 08/12/2023.
//

import UIKit

public final class ErrorView: UIView {
    @IBOutlet private var label: UILabel!

    public var message: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        label.text = nil
    }
}
