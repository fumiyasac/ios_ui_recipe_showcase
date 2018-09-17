//
//  BaseViewController.swift
//  MenuContentsExample
//
//  Created by 酒井文也 on 2018/08/07.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // 現在選択されたボタンの種別を持つ（この変数の初期値はSideNavigationButtonType: 0とする）
    private var selectedButtonType: Int = SideNavigationButtonType.mainContents.rawValue
    
    // サイドナビゲーションの状態
    private var sideNavigationStatus: SideNavigationStatus = .closed

    // このViewControllerのタッチイベント開始時のx座標（コンテンツが開いた状態で仕込まれる）
    private var touchBeganPositionX: CGFloat!

    // Storyboard上に配置した部品
    @IBOutlet weak private var sideNavigationContainer: UIView!
    @IBOutlet weak private var mainContentsContainer: UIView!
    @IBOutlet weak private var wrapperButton: UIButton!

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        // 一番最初に表示するViewControllerを決める
        displayMainContentsViewController()

        // 透明ボタンの初期状態を決定
        wrapperButton.backgroundColor = UIColor.black
        wrapperButton.alpha = 0
        wrapperButton.isUserInteractionEnabled = false

        // 左隅部分のGestureRecognizerを作成する
        let leftEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.edgeTapGesture(sender:)))
        leftEdgeGesture.edges = .left

        // 初期状態では左隅部分のGestureRecognizerを有効にしておく
        mainContentsContainer.addGestureRecognizer(leftEdgeGesture)
    }

    // 接続されている「Segue Identifier」から該当のViewControllerを取得します
    // MEMO: SideNavigationViewControllerの「Embed Segue: connectSideNavigationContainer」と名前をつける
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "connectSideNavigationContainer" {
            let sideNavigationViewController = segue.destination as! SideNavigationViewController
            sideNavigationViewController.delegate = self
        }
    }

    // サイドナビゲーションが開いた状態：タッチイベントの開始時の処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        // サイドナビゲーションが開いた際にタッチイベント開始位置のx座標を取得してメンバ変数に格納する
        let touchEvent = touches.first!

        // タッチイベント開始時のself.viewのx座標を取得する
        let beginPosition = touchEvent.previousLocation(in: self.view)
        touchBeganPositionX = beginPosition.x

        // Debug.
        //print("サイドナビゲーションが開いた状態でのドラッグ開始時のx座標:\(touchBeganPositionX)")
    }
    
    // サイドナビゲーションが開いた状態：タッチイベントの実行中の処理
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        // タッチイベント開始位置のx座標がサイドナビゲーション幅より大きい場合
        // → メインコンテンツと透明ボタンをドラッグで動かすことができるようにする
        if sideNavigationStatus == .opened && touchBeganPositionX >= 260 {

            // サイドナビゲーション及びメインコンテンツのタッチイベントを無効にする
            sideNavigationContainer.isUserInteractionEnabled = false
            mainContentsContainer.isUserInteractionEnabled = false

            let touchEvent = touches.first!

            // ドラッグ前の座標
            let preDx = touchEvent.previousLocation(in: self.view).x

            // ドラッグ後の座標
            let newDx = touchEvent.location(in: self.view).x

            // ドラッグしたx座標の移動距離
            let dx = newDx - preDx

            // ドラッグした移動分の値を反映させる
            var viewFrame: CGRect = wrapperButton.frame
            viewFrame.origin.x += dx
            mainContentsContainer.frame = viewFrame
            wrapperButton.frame = viewFrame

            // Debug.
            //print("サイドナビゲーションが開いた状態でのドラッグ中のx座標:\(viewFrame.origin.x)")

            // メインコンテンツのx座標が0〜260の間に収まるように補正
            if mainContentsContainer.frame.origin.x > 260 {

                mainContentsContainer.frame.origin.x = 260
                wrapperButton.frame.origin.x         = 260

            } else if mainContentsContainer.frame.origin.x < 0 {

                mainContentsContainer.frame.origin.x = 0
                wrapperButton.frame.origin.x         = 0
            }

            // サイドナビゲーションとボタンのアルファ値を変更する
            sideNavigationContainer.alpha = mainContentsContainer.frame.origin.x / 260
            wrapperButton.alpha           = mainContentsContainer.frame.origin.x / 260 * 0.36
        }
    }
    
    // サイドナビゲーションが開いた状態：タッチイベントの終了時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        // タッチイベント終了時はメインコンテンツと透明ボタンの位置で開くか閉じるかを決める
        /**
         * 境界値(x座標: 160)のところで開閉状態を決める
         * ボタンエリアが開いた時の位置から変わらない時(x座標: 260)または境界値より前ではコンテンツを閉じる
         */
        if touchBeganPositionX >= 260 && (mainContentsContainer.frame.origin.x == 260 || mainContentsContainer.frame.origin.x < 160) {
            changeContainerSettingWithAnimation(.closed)
        } else if touchBeganPositionX >= 260 && mainContentsContainer.frame.origin.x >= 160 {
            changeContainerSettingWithAnimation(.opened)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Function

    func openSideNavigation() {
        changeContainerSettingWithAnimation(.opened)
    }
    
    // MARK: - Private Function

    // サイドナビゲーションが閉じた状態から左隅のドラッグを行ってコンテンツを開く際の処理
    @objc private func edgeTapGesture(sender: UIScreenEdgePanGestureRecognizer) {
        
        // サイドナビゲーション及びメインコンテンツのタッチイベントを無効にする
        sideNavigationContainer.isUserInteractionEnabled = false
        mainContentsContainer.isUserInteractionEnabled = false

        // 移動量を取得する
        let move: CGPoint = sender.translation(in: mainContentsContainer)

        // メインコンテンツと透明ボタンのx座標に移動量を加算する
        wrapperButton.frame.origin.x         += move.x
        mainContentsContainer.frame.origin.x += move.x

        // Debug.
        //print("サイドナビゲーションが閉じた状態でのドラッグの加算量:\(move.x)")
        
        // サイドナビゲーションとボタンのアルファ値を変更する
        sideNavigationContainer.alpha = mainContentsContainer.frame.origin.x / 260
        wrapperButton.alpha           = mainContentsContainer.frame.origin.x / 260 * 0.36

        // メインコンテンツのx座標が0〜260の間に収まるように補正
        if mainContentsContainer.frame.origin.x > 260 {

            mainContentsContainer.frame.origin.x = 260
            wrapperButton.frame.origin.x         = 260

        } else if mainContentsContainer.frame.origin.x < 0 {

            mainContentsContainer.frame.origin.x = 0
            wrapperButton.frame.origin.x         = 0
        }

        // ドラッグ終了時の処理
        /**
         * 境界値(x座標: 160)のところで開閉状態を決める
         * ボタンエリアが開いた時の位置から変わらない時(x座標: 260)または境界値より前ではコンテンツを閉じる
         */
        if sender.state == UIGestureRecognizerState.ended {
            if mainContentsContainer.frame.origin.x < 160 {
                changeContainerSettingWithAnimation(.closed)
            } else {
                changeContainerSettingWithAnimation(.opened)
            }
        }

        // 移動量をリセットする
        sender.setTranslation(CGPoint.zero, in: self.view)
    }

    // コンテナの開閉状態を制御する
    private func changeContainerSettingWithAnimation(_ status: SideNavigationStatus) {
        
        // サイドナビゲーションが閉じている状態で押された → コンテンツを開く
        if status == .opened {

            sideNavigationStatus = status
            executeSideOpenAnimation()
            
        // サイドナビゲーションが開いている状態で押された → コンテンツを閉じる
        } else {

            sideNavigationStatus = .closed
            executeSideCloseAnimation()
        }
    }

    // サイドナビゲーションを開くアニメーションを実行する
    private func executeSideOpenAnimation(withCompletion: (() -> ())? = nil) {

        // サイドナビゲーションはタッチイベントを有効にする
        self.sideNavigationContainer.isUserInteractionEnabled = true

        // メインコンテンツはタッチイベントを無効にする
        self.mainContentsContainer.isUserInteractionEnabled = false

        UIView.animate(withDuration: 0.16, delay: 0, options: [.curveEaseOut], animations: {

            // メインコンテンツを移動させてサイドメニューを表示させる
            self.mainContentsContainer.frame = CGRect(
                x:      260,
                y:      self.mainContentsContainer.frame.origin.y,
                width:  self.mainContentsContainer.frame.width,
                height: self.mainContentsContainer.frame.height
            )
            self.wrapperButton.frame = CGRect(
                x:      260,
                y:      self.wrapperButton.frame.origin.y,
                width:  self.wrapperButton.frame.width,
                height: self.wrapperButton.frame.height
            )

            // メインコンテンツ以外のアルファを変更する
            self.wrapperButton.alpha           = 0.36
            self.sideNavigationContainer.alpha = 1

        }, completion: { _ in

            // 引数で受け取った完了時に行いたい処理を実行する
            withCompletion?()
        })
    }

    // サイドナビゲーションを開くアニメーションを実行する
    private func executeSideCloseAnimation(withCompletion: (() -> ())? = nil) {

        // サイドナビゲーションはタッチイベントを無効にする
        self.sideNavigationContainer.isUserInteractionEnabled = false

        // メインコンテンツはタッチイベントを有効にする
        self.mainContentsContainer.isUserInteractionEnabled = true

        UIView.animate(withDuration: 0.16, delay: 0, options: [.curveEaseOut], animations: {

            // メインコンテンツを移動させてサイドメニューを閉じる
            self.mainContentsContainer.frame = CGRect(
                x:      0,
                y:      self.mainContentsContainer.frame.origin.y,
                width:  self.mainContentsContainer.frame.width,
                height: self.mainContentsContainer.frame.height
            )
            self.wrapperButton.frame = CGRect(
                x:      0,
                y:      self.wrapperButton.frame.origin.y,
                width:  self.wrapperButton.frame.width,
                height: self.wrapperButton.frame.height
            )

            // メインコンテンツ以外のアルファを変更する
            self.wrapperButton.alpha           = 0
            self.sideNavigationContainer.alpha = 0

        }, completion: { _ in

            // 引数で受け取った完了時に行いたい処理を実行する
            withCompletion?()
        })
    }

    private func displayMainContentsViewController() {
        if let vc = UIStoryboard(name: "MainContents", bundle: nil).instantiateInitialViewController() {
            mainContentsContainer.addSubview(vc.view)
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
        }
    }

    private func displayInformationContentsViewController() {
        if let vc = UIStoryboard(name: "InformationContents", bundle: nil).instantiateInitialViewController() {
            mainContentsContainer.addSubview(vc.view)
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
        }
    }

    private func showQiitaWebPage() {
        if let qiitaUrl = URL(string: "https://qiita.com/fumiyasac@github/items/eb5b17ab90f5aa27b793") {
            UIApplication.shared.open(qiitaUrl, options: [:])
        }
    }

    private func showSlideshareWebPage() {
        if let slideshareNewsUrl = URL(string: "http://www.slideshare.net/fumiyasakai37/uikitdiypart1") {
            UIApplication.shared.open(slideshareNewsUrl, options: [:])
        }
    }
}

// MARK: - SideNavigationButtonDelegate

extension BaseViewController: SideNavigationButtonDelegate {

    // mainContentsContainerで表示するコンテンツないしはURLで表示するページを決める
    func changeMainContentsContainer(_ buttonType: Int) {

        // SideNavigationButtonDelegateで渡された値が現在表示されている値かどうかを判定する
        let isCurrentDisplay = (selectedButtonType == buttonType)

        // SideNavigationButtonDelegateで渡された値
        switch buttonType {

        // メインコンテンツの場合
        case SideNavigationButtonType.mainContents.rawValue:

            // 選択中コンテンツのメンバ変数を更新し、isCurrentDisplay = falseなら画面表示を変更する
            selectedButtonType = buttonType
            executeSideCloseAnimation(withCompletion: {
                if !isCurrentDisplay {
                    self.displayMainContentsViewController()
                }
            })
            break

        // お知らせコンテンツの場合
        case SideNavigationButtonType.informationContents.rawValue:

            // 選択中コンテンツのメンバ変数を更新し、isCurrentDisplay = falseなら画面表示を変更する
            selectedButtonType = buttonType
            executeSideCloseAnimation(withCompletion: {
                if !isCurrentDisplay {
                    self.displayInformationContentsViewController()
                }
            })
            break

        // Qiitaのページの場合
        case SideNavigationButtonType.qiitaWebPage.rawValue:

            // Qiitaのページを表示する
            executeSideCloseAnimation(withCompletion: {
                self.showQiitaWebPage()
            })
            break

        // Slideshareのページの場合
        case SideNavigationButtonType.slideshareWebPage.rawValue:

            // Slideshareのページを表示する
            executeSideCloseAnimation(withCompletion: {
                self.showSlideshareWebPage()
            })
            break

        default:
            break
        }
    }
}
