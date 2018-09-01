//
//  DetailViewController.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/10.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import Cosmos
import ActiveLabel
import FontAwesome_swift

/**
 * 補足: このViewControllerから更に画面遷移を行う場合
 *
 * この画面ではNavigationBarにカスタマイズを加えた故に従来通りの方法で、
 * 「self.navigationController?.pushViewController(controller, animated: true)」
 * としてもうまく遷移ができない。
 * このような場合には、Modalでの画面遷移を用いて更にカスタムトランジションでPush/Popに近い動きを実装する等
 * 遷移から戻った際の表示の考慮をする必要があります。
 * (例)この場合ではタイトルが動くダミーのヘッダー用のViewや戻るボタンの構成を変更する必要があります。
 */
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

    // 表示に必要なUI部品の配置(ベースのScrollView)
    @IBOutlet weak private var detailScrollView: UIScrollView!

    // 表示に必要なUI部品の配置(コンテンツに関する物)
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var nameTextLabel: UILabel!
    @IBOutlet weak private var englishNameTextLabel: UILabel!
    @IBOutlet weak private var ratingStarView: CosmosView!
    @IBOutlet weak private var ratingTextLabel: UILabel!
    @IBOutlet weak private var priceTextLabel: UILabel!
    @IBOutlet weak private var addtionalLinkLabel: ActiveLabel!

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

        // 変数: targetFoodを元に表示したい内容を反映する
        setContentsFromTargetFood()
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

    // MARK - Private Function

    // この画面の表示で使用するデータを画面へ表示する
    private func setContentsFromTargetFood() {

        // FontAwesome_Swiftで表示するイメージの設定を行う
        iconImageView.image = UIImage.fontAwesomeIcon(name: .fish, style: .solid, textColor: UIColor(code: "#7182ff"), size: CGSize(width: 20, height: 20))

        // データを表示させる
        nameTextLabel.text        = targetFood.name
        englishNameTextLabel.text = "英語名: " + targetFood.englishName
        ratingTextLabel.text      = String(targetFood.rate)
        priceTextLabel.text       = "お値段: ¥" + String(targetFood.price) + "（1貫）"

        // Cosmosによる星のレーティング表示
        ratingStarView.settings.updateOnTouch = false
        ratingStarView.settings.fillMode      = .precise
        ratingStarView.rating                 = Double(targetFood.rate)

        // リンク付きテキストの設定を行う
        let withUrlString = "【写真素材】写真AC様\nhttps://www.photo-ac.com/ \n\n【使用したライブラリ】\nFontAwesome.swift:\nhttp://bit.ly/2vUpV2V \nCosmos:\nhttp://bit.ly/2MWg6rA \nActiveLabel.swift:\nhttp://bit.ly/2vQd41U \n\n【参考リンク】その他カスタムトランジションを使った表現\nHow to Create a Navigation Transition Like the Apple News App:\nhttp://bit.ly/2vVMlRi \nMaking the App Store iOS 11 Custom Transitions:\nhttp://bit.ly/2vSiiKt \n\n"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        var attributes = [NSAttributedStringKey : Any]()
        attributes[NSAttributedStringKey.paragraphStyle] = paragraphStyle
        attributes[NSAttributedStringKey.font] = UIFont(name: "HiraKakuProN-W3", size: 12.0)
        attributes[NSAttributedStringKey.foregroundColor] = UIColor(code: "#777777")

        addtionalLinkLabel.enabledTypes  = [.url]
        addtionalLinkLabel.attributedText = NSAttributedString(string: withUrlString, attributes: attributes)
        addtionalLinkLabel.handleURLTap { url in
            UIApplication.shared.open(url, options: [:])
        }
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
