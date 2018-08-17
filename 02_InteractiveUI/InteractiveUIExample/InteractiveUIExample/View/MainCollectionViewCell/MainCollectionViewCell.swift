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
    
    // 各々のセル間につけるマージンの値
    static let cellMargin: CGFloat = 1.0

    // FontAwesome_Swiftで表示するイメージのサイズ
    private let iconImageSize: CGSize = CGSize(width: 15, height: 15)

    // 補足: この画像の配置位置が欲しいのでprivateにしていない
    @IBOutlet weak var foodImageView: UIImageView!

    // このクラスのみで使用する表示に関する部品
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var englishNameLabel: UILabel!

    // MARK: - Initializer

    override func awakeFromNib() {
        super.awakeFromNib()

        setupMainCollectionViewCell()
    }

    // MARK: - Static Function

    static func getCellSize() -> CGSize {

        // 縦方向の隙間・文字表示部分の高さ・画像の縦横比
        let numberOfMargin: CGFloat       = 3
        let descriptionHeight: CGFloat    = 65.0
        let foodImageAspectRatio: CGFloat = 0.75

        // セルのサイズを上記の値を利用して算出する
        let cellWidth  = (UIScreen.main.bounds.width - cellMargin * numberOfMargin) / 2
        let cellHeight = cellWidth * foodImageAspectRatio + descriptionHeight
        return CGSize(width: cellWidth, height: cellHeight)
    }

    // MARK: - Function

    func setCell(_ food: Food) {
        foodImageView.image   = food.imageFile
        nameLabel.text        = food.name
        priceLabel.text       = "お値段: ¥" + String(food.price) + "（1貫）"
        englishNameLabel.text = "英語名: " + food.englishName
    }

    // MARK: - Private Function

    private func setupMainCollectionViewCell() {
        iconImageView.image = UIImage.fontAwesomeIcon(name: .fish, style: .solid, textColor: UIColor(code: "#7182ff"), size: iconImageSize)
    }
}
