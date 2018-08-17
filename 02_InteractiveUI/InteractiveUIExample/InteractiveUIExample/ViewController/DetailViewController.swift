//
//  DetailViewController.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/10.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // ダミーのヘッダー用のViewのY軸方向の位置（iPhoneX用に補正あり）
    private let animationHeaderViewPositionY: CGFloat = {
        return DeviceSize.iPhoneXCompatible() ? -44.0 : -20.0
    }()

    // ナビゲーションバーの高さ（iPhoneX用に補正あり）
    private let navigationBarHeight: CGFloat = {
        return DeviceSize.iPhoneXCompatible() ? 88.5 : 64.0
    }()

    // NavigationBarの中に配置するダミーのヘッダー
    private var animationDetailHeaderView: AnimationDetailHeaderView = AnimationDetailHeaderView()

    // この画面の表示で使用するデータ
    private var targetFood: Food!

    // カスタムトランジションと紐づけるUIImageView
    /**
     * ポイント:
     * tag値をInterfaceBuilderで「99」にセットする
     * → DetailTransitionクラスのcustomAnimatorTagと同じ値
     * ※ 注意:
     * このUIImageViewはカスタムトランジションを行う際に動くUIImageViewの基準位置をとるためのもの。
     * 位置は画面の一番上(Superview.top)に左右をぴったりと合わせて、detailHeaderViewと同じ縦横比で制約を付与する
     */
    @IBOutlet weak private var transitionTargetImageView: UIImageView!

    // 画像のパララックス効果付きのView(縦横比はMainCollectionViewCellの画像と同じに配置する)
    @IBOutlet weak private var detailHeaderView: DetailHeaderView!

    // 表示に必要なUI部品の配置
    @IBOutlet weak private var detailScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // NavigationControllerのカスタマイズを行う(ナビゲーションを透明にする)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationItem.hidesBackButton = true

        // ダミーのヘッダー用のViewをStatusBarの高さ分Y軸方向位置を減算＆ナビゲーションバーの高さを設定してnavigationBarの中に配置する
        animationDetailHeaderView.frame = CGRect(x: 0, y: animationHeaderViewPositionY, width: self.view.bounds.width, height: navigationBarHeight)
        self.navigationController?.navigationBar.addSubview(animationDetailHeaderView)

        // ダミーのヘッダー用のViewへ必要な値などをセットする(画面表示が完了するまでは非表示にする)
        animationDetailHeaderView.setTitle("選んだお寿司: " + targetFood.name)
        animationDetailHeaderView.headerBackButtonTappedHandler = {
            self.navigationController?.popViewController(animated: true)
        }
        animationDetailHeaderView.setHeaderBackgroundViewAlpha(0)
        animationDetailHeaderView.isHidden = true

        // NavigationBar分のスクロール位置がずれてしまうのでその考慮を行う
        if #available(iOS 11.0, *) {
            detailScrollView.contentInsetAdjustmentBehavior = .never
        }
        detailScrollView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 画面表示が完了したらダミーのヘッダー用のViewを表示する
        animationDetailHeaderView.isHidden = false

        // 画面表示が完了したら画像のパララックス効果付きのViewに画像をセットする
        detailHeaderView.setHeaderImage(targetFood.imageFile!)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // 遷移元へ戻る遷移が完了したらダミーのヘッダー用のViewを削除する
        animationDetailHeaderView.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Function

    // この画面の表示で使用するデータを遷移先からセットする
    func setTargetFood(_ food: Food) {
        targetFood = food
    }
}

// MARK - UIScrollViewDelegate

extension DetailViewController: UIScrollViewDelegate {

    // スクロールが検知された時に実行される処理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // 画像のパララックス効果付きのViewに付与されているAutoLayout制約を変更してパララックス効果を出す
        detailHeaderView.setParallaxEffectToHeaderView(scrollView)

        // ダミーのヘッダー用のViewのアルファ値を上方向のスクロール量に応じて変化させる
        /**
         * それぞれの変数の意味と変化量と伴って変わる値に関する補足：
         * [変数: navigationInvisibleHeight] = (画像のパララックス効果付きのViewの高さ) - (NavigationBarの高さを引いたもの)
         * ダミーのヘッダー用のViewのアルファの値 = 上方向のスクロール量 ÷ navigationInvisibleHeightとする
         * アルファの値域：(0 ≦ gradientHeaderView.alpha ≦ 1)
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

        // ダミーのヘッダー用のViewの中身の戻るボタンとタイトルを包んだViewの上方向の制約を更新する
        let targetTopConstraint = navigationInvisibleHeight - scrollContentOffsetY
        animationDetailHeaderView.setHeaderNavigationTopConstraint(targetTopConstraint)
    }
}
