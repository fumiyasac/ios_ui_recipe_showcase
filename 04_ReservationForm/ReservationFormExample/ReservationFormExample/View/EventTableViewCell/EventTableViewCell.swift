//
//  EventTableViewCell.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/25.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak private var categoryLabel: UILabel!
    @IBOutlet weak private var placeLabel: UILabel!
    @IBOutlet weak private var eventImageView: UIImageView!
    @IBOutlet weak private var summaryLabel: UILabel!

    // MARK: - Initializer

    override func awakeFromNib() {
        super.awakeFromNib()

        setupEventTableViewCell()
    }

    // MARK: - Function

    func setCell(_ event: EventEntity) {
        categoryLabel.text   = "カテゴリ名: " + event.category
        placeLabel.text      = "開催場所: " + event.place

        eventImageView.image = event.photo
        eventImageView.contentMode   = .scaleAspectFill
        eventImageView.clipsToBounds = true

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        var attributes = [NSAttributedStringKey : Any]()
        attributes[NSAttributedStringKey.paragraphStyle] = paragraphStyle
        attributes[NSAttributedStringKey.font] = UIFont(name: "HiraKakuProN-W3", size: 12.0)
        attributes[NSAttributedStringKey.foregroundColor] = UIColor(code: "#777777")

        summaryLabel.attributedText = NSAttributedString(string: event.summary, attributes: attributes)
    }

    // MARK: - Private Function

    private func setupEventTableViewCell() {
        self.accessoryType  = .none
        self.selectionStyle = .none
    }
}
