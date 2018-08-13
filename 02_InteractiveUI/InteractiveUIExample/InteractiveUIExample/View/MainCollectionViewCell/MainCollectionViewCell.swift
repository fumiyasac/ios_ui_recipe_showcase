//
//  MainCollectionViewCell.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/12.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import FontAwesome_swift

class MainCollectionViewCell: UICollectionViewCell {

    // FontAwesome_Swiftで表示するイメージのサイズ
    private let iconImageSize: CGSize = CGSize(width: 13, height: 13)

    @IBOutlet weak private var foodImageView: UIImageView!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var englishNameLabel: UILabel!

    // MARK: - Initializer

    override func awakeFromNib() {
        super.awakeFromNib()

        setupMainCollectionViewCell()
    }

    // MARK: - Function

    func setCell(_ food: Food) {
        foodImageView.image   = food.imageFile
        nameLabel.text        = food.name
        priceLabel.text       = "お値段:" + String(food.price) + "（1貫）"
        englishNameLabel.text = "英語名:" + food.englishName
    }

    // MARK: - Private Function

    private func setupMainCollectionViewCell() {
        iconImageView.image = UIImage.fontAwesomeIcon(name: .fish, style: .brands, textColor: UIColor.init(code: "7182ff"), size: iconImageSize)
    }
}
