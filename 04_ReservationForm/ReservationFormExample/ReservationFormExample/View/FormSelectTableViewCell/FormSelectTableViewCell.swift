//
//  FormSelectTableViewCell.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/23.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class FormSelectTableViewCell: UITableViewCell {

    var selectButtonTappedhandler: (() -> ())?

    @IBOutlet weak private var selectedLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var selectButton: UIButton!

    // MARK: - Initializer

    override func awakeFromNib() {
        super.awakeFromNib()

        setupFormInputSelectTableViewCell()
    }

    // MARK: - Functions

    func setCell(_ /*event: Event,*/ selected: Bool) {
        if selected {
            selectedLabel.backgroundColor = UIColor(code: "#44aeea")
        } else {
            selectedLabel.backgroundColor = UIColor(code: "#cccccc")
        }
    }

    // MARK: - Private Function

    @objc private func selectButtonTapped() {
        selectButtonTappedhandler?()
    }

    private func setupFormInputSelectTableViewCell() {

        selectedLabel.layer.cornerRadius = 6.0
        selectedLabel.layer.masksToBounds = true
        selectedLabel.backgroundColor = UIColor(code: "#cccccc")

        selectButton.addTarget(self, action: #selector(self.selectButtonTapped), for: .touchUpInside)

        self.tintColor = UIColor(code: "#6db5a9")
        self.accessoryType  = .none
        self.selectionStyle = .none
    }
}
