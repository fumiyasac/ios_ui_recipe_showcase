//
//  DetailHeaderView.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/10.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class DetailHeaderView: UIView {

    private var imageView = UIImageView()
    private var imageViewHeightLayoutConstraint = NSLayoutConstraint()
    private var imageViewBottomLayoutConstraint = NSLayoutConstraint()

    private var wrappedView = UIView()
    private var wrappedViewHeightLayoutConstraint = NSLayoutConstraint()

    // MARK: - Initializer

    required override init(frame: CGRect) {
        super.init(frame: frame)

        setupDetailHeaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupDetailHeaderView()
    }
    
    // MARK: - Function

    // バウンス効果のあるUIImageViewに表示する画像をセットする
    func setHeaderImage(_ targetImage: UIImage) {
        imageView.image         = targetImage
        imageView.contentMode   = .scaleAspectFill
        imageView.clipsToBounds = true
    }

    // UIScrollViewの変化量に応じてAutoLayoutの制約を動的に変更する
    func setParallaxEffectToHeaderView(_ scrollView: UIScrollView) {

        // UIScrollViewの上方向の余白の変化量をwrappedViewの高さに加算する
        // 参考：http://blogios.stack3.net/archives/1663
        wrappedViewHeightLayoutConstraint.constant = scrollView.contentInset.top

        // Y軸方向オフセット値を算出する
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)

        // Y軸方向オフセット値に応じた値をそれぞれの制約に加算する
        wrappedView.clipsToBounds = (offsetY <= 0)
        imageViewBottomLayoutConstraint.constant = (offsetY >= 0) ? 0 : -offsetY / 2
        imageViewHeightLayoutConstraint.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }

    // MARK: - Private Function

    private func setupDetailHeaderView() {

        self.backgroundColor = UIColor.white

        /**
         * ・コードでAutoLayoutを張る場合の注意点等の参考
         *
         * (1) Auto Layoutをコードから使おう
         * http://blog.personal-factory.com/2016/01/11/make-auto-layout-via-code/
         *
         * (2) Visual Format Languageを使う【Swift3.0】
         * http://qiita.com/fromage-blanc/items/7540c6c58bf9d2f7454f
         *
         * (3) コードでAutolayout
         * http://qiita.com/bonegollira/items/5c973206b82f6c4d55ea
         */

        // Autosizing → AutoLayoutに変換する設定をオフにする
        wrappedView.translatesAutoresizingMaskIntoConstraints = false
        wrappedView.backgroundColor = UIColor.white
        self.addSubview(wrappedView)
        
        // このViewに対してwrappedViewに張るConstraint（横方向 → 左：0, 右：0）
        let wrappedViewConstarintH = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[wrappedView]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: ["wrappedView" : wrappedView]
        )

        // このViewに対してwrappedViewに張るConstraint（縦方向 → 上：なし, 下：0）
        let wrappedViewConstarintV = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[wrappedView]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: ["wrappedView" : wrappedView]
        )

        self.addConstraints(wrappedViewConstarintH)
        self.addConstraints(wrappedViewConstarintV)

        // wrappedViewの縦幅をいっぱいにする
        wrappedViewHeightLayoutConstraint = NSLayoutConstraint(
            item: wrappedView,
            attribute: .height,
            relatedBy: .equal,
            toItem: self,
            attribute: .height,
            multiplier: 1.0,
            constant: 0.0
        )
        self.addConstraint(wrappedViewHeightLayoutConstraint)

        // wrappedViewの中にimageView入れる
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        wrappedView.addSubview(imageView)

        // wrappedViewに対してimageViewに張るConstraint（横方向 → 左：0, 右：0）
        let imageViewConstarintH = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[imageView]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: ["imageView" : imageView]
        )

        // wrappedViewの下から0pxの位置に配置する
        imageViewBottomLayoutConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: wrappedView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0
        )

        // imageViewの縦幅をいっぱいにする
        imageViewHeightLayoutConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: .height,
            relatedBy: .equal,
            toItem: wrappedView,
            attribute: .height,
            multiplier: 1.0,
            constant: 0.0
        )

        wrappedView.addConstraints(imageViewConstarintH)
        wrappedView.addConstraint(imageViewBottomLayoutConstraint)
        wrappedView.addConstraint(imageViewHeightLayoutConstraint)
    }
}
