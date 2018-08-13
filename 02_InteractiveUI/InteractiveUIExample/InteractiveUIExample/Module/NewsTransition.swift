//
//  NewsTransition.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/12.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class NewsTransition: NSObject {

    // トランジションの秒数
    private let duration: TimeInterval = 0.36
}

// MARK: - UIViewControllerAnimatedTransitioning

extension NewsTransition: UIViewControllerAnimatedTransitioning {

    // アニメーションの時間を定義する
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    // アニメーションの実装を定義する
    // 画面遷移コンテキスト(UIViewControllerContextTransitioning)を利用する
    // → 遷移元や遷移先のViewControllerやそのほか関連する情報が格納されているもの
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    }
}
