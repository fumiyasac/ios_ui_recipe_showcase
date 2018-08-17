//
//  DetailViewController.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/10.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // グラデーションヘッダー用のY軸方向の位置（iPhoneX用に補正あり）
    private let animationHeaderViewPositionY: CGFloat = {
        return DeviceSize.iPhoneXCompatible() ? -44.0 : -20.0
    }()

    // ナビゲーションバーの高さ（iPhoneX用に補正あり）
    private let navigationBarHeight: CGFloat = {
        return DeviceSize.iPhoneXCompatible() ? 88.5 : 64.0
    }()

    private var animationDetailHeaderView: AnimationDetailHeaderView = AnimationDetailHeaderView()

    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var detailHeaderView: DetailHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.hidesBackButton = true

        // StatusBarの高さ分をマイナス＆微調整してnavigationBarの中に配置する
        animationDetailHeaderView.frame = CGRect(x: 0, y: animationHeaderViewPositionY, width: self.view.bounds.width, height: navigationBarHeight)
        self.navigationController?.navigationBar.addSubview(animationDetailHeaderView)

        // サンプル実装
        detailScrollView.delegate = self
        detailHeaderView.setHeaderImage(UIImage(named: "detail_sample")!)
        animationDetailHeaderView.setHeaderBackgroundViewAlpha(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK - UIScrollViewDelegate

extension DetailViewController: UIScrollViewDelegate {

    // スクロールが検知された時に実行される処理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // テーブルビューのヘッダー画像に付与されているAutoLayout制約を変更してパララックス効果を出す
        //let articleHeaderView = articleTableView.tableHeaderView as! ArticleHeaderView
        detailHeaderView.setParallaxEffectToHeaderView(scrollView)
        
        //ダミーのヘッダービューのアルファ値を上方向のスクロール量に応じて変化させる
        /*
         それぞれの変数の意味と変化量と伴って変わる値に関する補足：
         [変数] navigationInvisibleHeight = (テーブルビューのヘッダー画像の高さ) - (NavigationBarの高さを引いたもの)
         gradientHeaderViewのアルファの値 = 上方向のスクロール量 ÷ navigationInvisibleHeightとする
         アルファの値域：(0 ≦ gradientHeaderView.alpha ≦ 1)
         */
        let navigationInvisibleHeight = detailHeaderView.frame.height - navigationBarHeight
        let scrollContentOffsetY = scrollView.contentOffset.y

        var changedAlpha: CGFloat
        if scrollContentOffsetY > 0 {
            changedAlpha = min(scrollContentOffsetY / navigationInvisibleHeight, 1)
        } else {
            changedAlpha = max(scrollContentOffsetY / navigationInvisibleHeight, 0)
        }
        animationDetailHeaderView.setHeaderBackgroundViewAlpha(changedAlpha)

        //ダミーのヘッダービューの中身の戻るボタンとタイトルを包んだViewの上方向の制約を更新する
        let targetTopConstraint = navigationInvisibleHeight - scrollContentOffsetY
        animationDetailHeaderView.setHeaderNavigationTopConstraint(targetTopConstraint)
    }
}
