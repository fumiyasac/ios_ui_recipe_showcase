//
//  DetailTransition.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/12.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class DetailTransition: NSObject {

    // アニメーション対象となる画像のtag番号(遷移先のUIImageViewに付与する)
    private let customAnimatorTag = 99

    // トランジションの秒数
    private let duration: TimeInterval = 0.28

    // トランジションの方向(push: true, pop: false)
    var presenting: Bool = true

    // アニメーション対象なるViewControllerの位置やサイズ情報を格納するメンバ変数
    var originFrame: CGRect = CGRect.zero

    // アニメーション対象なるサムネイル画像情報を格納するメンバ変数
    var originImage: UIImage = UIImage()
}

// MARK: - UIViewControllerAnimatedTransitioning

extension DetailTransition: UIViewControllerAnimatedTransitioning {

    // アニメーションの時間を定義する
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    // アニメーションの実装を定義する
    // 画面遷移コンテキスト(UIViewControllerContextTransitioning)を利用する
    // → 遷移元や遷移先のViewControllerやそのほか関連する情報が格納されているもの
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // コンテキストを元にViewのインスタンスを取得する（存在しない場合は処理を終了）
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }

        // アニメーションの実体となるContainerViewを作成する
        let container = transitionContext.containerView

        // 表示させるViewControllerを格納するための変数を定義する
        var detailView: UIView!

        // Case1: 進む場合
        if presenting {

            container.addSubview(toView)
            detailView = toView

        // Case2: 戻る場合
        } else {

            container.insertSubview(toView, belowSubview: fromView)
            detailView = fromView
        }

        // 遷移先のViewControllerに配置したUIImageViewのタグ値から、カスタムトランジション時に動かすUIImageViewの情報を取得する
        // ※ 今回はDetailViewController内に配置したtransitionTargetImageViewが該当する
        guard let targetImageView = detailView.viewWithTag(customAnimatorTag) as? UIImageView else {
            return
        }
        targetImageView.image = originImage
        targetImageView.alpha = 0

        // カスタムトランジションでViewControllerを表示させるViewの表示に関する値を格納する変数
        var toViewAlpha: CGFloat!
        var beforeTransitionImageViewFrame: CGRect!
        var afterTransitionImageViewFrame: CGRect!
        var afterTransitionViewAlpha: CGFloat!

        // Case1: 進む場合
        if presenting {

            toViewAlpha = 0
            beforeTransitionImageViewFrame = originFrame
            // MEMO: 詳細画面の初期配置位置に重なる様にframe値を設定する
            // targetImageView.frameを設定するとStoryboardの値が基準となる
            afterTransitionImageViewFrame  = CGRect(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.width * 0.75
            )
            afterTransitionViewAlpha = 1

        // Case2: 戻る場合
        } else {

            toViewAlpha = 1
            beforeTransitionImageViewFrame = targetImageView.frame
            afterTransitionImageViewFrame  = originFrame
            afterTransitionViewAlpha = 0
        }

        // 遷移時に動かすUIImageViewを追加する
        let transitionImageView = UIImageView(frame: beforeTransitionImageViewFrame)
        transitionImageView.image         = originImage
        transitionImageView.contentMode   = .scaleAspectFill
        transitionImageView.clipsToBounds = true
        container.addSubview(transitionImageView)

        // 遷移先のViewのアルファ値を反映する
        toView.alpha = toViewAlpha
        toView.layoutIfNeeded()

        UIView.animate(withDuration: duration, delay: 0.00, options: [.curveEaseInOut], animations: {
            transitionImageView.frame = afterTransitionImageViewFrame
            detailView.alpha = afterTransitionViewAlpha
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionImageView.removeFromSuperview()
            targetImageView.alpha = 1
        })
    }
}
