//
//  ReservationMenuButtonView.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/21.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

//@IBDesignable
class ReservationMenuButtonView: CustomViewBase {

    var menuButtonTappedHandler: (() -> ())?

    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var menuButton: UIButton!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupReservationMenuButtonView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupReservationMenuButtonView()
    }

    // MARK: - Private Function

    @objc private func menuButtonTapped(sender: UIButton) {
        
        // ViewController側でクロージャー内にセットした処理を実行する
        menuButtonTappedHandler?()
    }

    private func setupReservationMenuButtonView() {

        // FontAwesome_Swiftで表示するイメージの設定
        iconImageView.image = UIImage.fontAwesomeIcon(name: .clipboardList, style: .solid, textColor: UIColor.white, size: CGSize(width: 24, height: 24))

        // ボタン押下時のアクションの設定
        menuButton.addTarget(self, action:  #selector(self.menuButtonTapped(sender:)), for: .touchUpInside)
    }
}
