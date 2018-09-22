//
//  MainViewController.swift
//  LikeTinderExample
//
//  Created by 酒井文也 on 2018/08/18.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // カード表示用のViewを格納するための配列
    private var itemCardViewList: [ItemCardView] = []

    // TravelPresenterに設定したプロトコルを適用するための変数
    private var presenter: TravelPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        setupTravelPresenter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    // カードの内容をボタン押下時に実行されるアクションに関する設定を行う
    @objc private func refreshButtonTapped() {
        presenter.getTravelModels()
    }

    private func setupNavigationController() {
        setupNavigationBarTitle("気になる旅行")

        var attributes = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.font]             = UIFont(name: "HiraKakuProN-W3", size: 13.0)
        attributes[NSAttributedString.Key.foregroundColor]  = UIColor.white

        let rightButton = UIBarButtonItem(title: "✨再追加✨", style: .done, target: self, action: #selector(self.refreshButtonTapped))
        rightButton.setTitleTextAttributes(attributes, for: .normal)
        rightButton.setTitleTextAttributes(attributes, for: .highlighted)
        self.navigationItem.rightBarButtonItem = rightButton
    }

    // Presenterとの接続に関する設定を行う
    private func setupTravelPresenter() {
        presenter = TravelPresenter(presenter: self)
        presenter.getTravelModels()
    }

    // UIAlertViewControllerのポップアップ共通化を行う
    private func showAlertControllerWith(title: String, message: String) {
        let singleAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        singleAlert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: nil)
        )
        self.present(singleAlert, animated: true, completion: nil)
    }

    // 画面上にカード表示用のViewを追加 ＆ 付随した処理を行う
    private func addItemCardViews(_ travelModels: [TravelModel]) {

        for index in 0..<travelModels.count {
            
            // Debug.
            //print(travelModels[index])

            // ItemCardViewのインスタンスを作成してプロトコル宣言やタッチイベント等の初期設定を行う
            let itemCardView = ItemCardView()
            itemCardView.delegate = self
            itemCardView.setModelData(travelModels[index])
            itemCardView.largeImageButtonTappedHandler = {

                // 画像の拡大縮小が可能な画面へ遷移する
                let storyboard = UIStoryboard(name: "Photo", bundle: nil)
                let controller = storyboard.instantiateInitialViewController() as! PhotoViewController

                controller.setTargetTravelModel(travelModels[index])
                controller.modalPresentationStyle = .overFullScreen
                controller.modalTransitionStyle   = .crossDissolve

                self.present(controller, animated: true, completion: nil)
            }
            itemCardView.isUserInteractionEnabled = false

            // カード表示用のViewを格納するための配列に追加する
            itemCardViewList.append(itemCardView)

            // 現在表示されているカードの背面へ新たに作成したカードを追加する
            view.addSubview(itemCardView)
            view.sendSubviewToBack(itemCardView)
        }
        
        // MEMO: 配列(itemCardViewList)に格納されているViewのうち、先頭にあるViewのみを操作可能にする
        enableUserInteractionToFirstItemCardView()

        // 画面上にあるカードの山の拡大縮小比を調節する
        changeScaleToItemCardViews(skipSelectedView: false)
    }

    // 画面上にあるカードの山のうち、一番上にあるViewのみを操作できるようにする
    private func enableUserInteractionToFirstItemCardView() {
        if !itemCardViewList.isEmpty {
            if let firstItemCardView = itemCardViewList.first {
                firstItemCardView.isUserInteractionEnabled = true
            }
        }
    }

    // 現在配列に格納されている(画面上にカードの山として表示されている)Viewの拡大縮小を調節する
    private func changeScaleToItemCardViews(skipSelectedView: Bool = false) {

        // アニメーション関連の定数値
        let duration: TimeInterval = 0.26
        let reduceRatio: CGFloat   = 0.03

        var itemCount: CGFloat = 0
        for (itemIndex, itemCardView) in itemCardViewList.enumerated() {

            // 現在操作中のViewの縮小比を変更しない場合は、以降の処理をスキップする
            if skipSelectedView && itemIndex == 0 { continue }

            // 後ろに配置されているViewほど小さく見えるように縮小比を調節する
            let itemScale: CGFloat = 1 - reduceRatio * itemCount
            UIView.animate(withDuration: duration, animations: {
                itemCardView.transform = CGAffineTransform(scaleX: itemScale, y: itemScale)
            })
            itemCount += 1
        }
    }
}

// MARK: - TravelPresenterProtocol

extension MainViewController: TravelPresenterProtocol {

    // Presenterでデータ取得処理を実行した際に行われる処理
    func bindTravelModels(_ travelModels: [TravelModel]) {

        // 表示用のViewを格納するための配列「itemCardViewList」が空なら追加する
        if itemCardViewList.count > 0 {
            showAlertControllerWith(title: "まだカードが残っています", message: "画面からカードがなくなったら、\n再度追加をお願いします。\n※サンプルデータ計8件")
            return
        } else {
            addItemCardViews(travelModels)
        }
    }
}

// MARK: - ItemCardDelegate

extension MainViewController: ItemCardDelegate {
    
    // ドラッグ処理が開始された際にViewController側で実行する処理
    func beganDragging() {

        // Debug.
        //print("ドラッグ処理が開始されました。")

        changeScaleToItemCardViews(skipSelectedView: true)
    }

    // ドラッグ処理中に位置情報が更新された際にViewController側で実行する処理
    func updatePosition(_ itemCardView: ItemCardView, centerX: CGFloat, centerY: CGFloat) {

        // Debug.
        //print("該当View: \(itemCardView) 移動した座標点(X,Y): (\(centerX),\(centerY))")
    }

    // 左方向へのスワイプが完了した際にViewController側で実行する処理
    func swipedLeftPosition() {

        // Debug.
        //print("左方向へのスワイプ完了しました。")

        itemCardViewList.removeFirst()
        enableUserInteractionToFirstItemCardView()
        changeScaleToItemCardViews(skipSelectedView: false)
    }

    // 右方向へのスワイプが完了した際にViewController側で実行する処理
    func swipedRightPosition() {

        // Debug.
        //print("右方向へのスワイプ完了しました。")

        itemCardViewList.removeFirst()
        enableUserInteractionToFirstItemCardView()
        changeScaleToItemCardViews(skipSelectedView: false)
    }

    // 元の位置へ戻った際にViewController側で実行する処理
    func returnToOriginalPosition() {

        // Debug.
        //print("元の位置へ戻りました。")

        changeScaleToItemCardViews(skipSelectedView: false)
    }
}
