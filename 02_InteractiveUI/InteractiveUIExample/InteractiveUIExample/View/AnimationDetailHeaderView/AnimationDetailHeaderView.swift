//
//  AnimationDetailHeaderView.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/17.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class AnimationDetailHeaderView: CustomViewBase {

    // 初期状態のheaderWrappedViewTopConstraintのマージン値（iPhoneX用に補正あり）
    private let defaultHeaderMargin: CGFloat = {
        return DeviceSize.iPhoneXCompatible() ? 44 : 20
    }()

    @IBOutlet weak private var headerBackgroundView: UIView!
    @IBOutlet weak private var headerWrappedViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var headerTitle: UILabel!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Function

    func setHeaderBackgroundViewAlpha(_ alpha: CGFloat) {
        headerBackgroundView.alpha = alpha
    }

    //ダミーのヘッダー内にあるタイトルをセットする
    func setTitle(_ title: String?) {
        headerTitle.text = title
    }

    //ダミーのヘッダーの上方向の制約を更新する
    //[変数] constarint = (テーブルビューのヘッダー画像の高さ) - (NavigationBarの高さを引いたもの) - (テーブルビュー側の縦方向のスクロール量)
    func setHeaderNavigationTopConstraint(_ constant: CGFloat) {
        if constant > 0 {
            headerWrappedViewTopConstraint.constant = defaultHeaderMargin + constant
        } else {
            headerWrappedViewTopConstraint.constant = defaultHeaderMargin
        }
        self.layoutIfNeeded()
    }
}
