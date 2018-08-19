//
//  ItemCardView.swift
//  LikeTinderExample
//
//  Created by 酒井文也 on 2018/08/19.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Protocol

protocol ItemCardDelegate: NSObjectProtocol {

    // ドラッグ開始時に実行されるアクション
    func beganDragging()

    // 位置の変化が生じた際に実行されるアクション
    func updatePosition(_ itemCardView: ItemCardView, centerX: CGFloat, centerY: CGFloat)

    // 左側へのスワイプ動作が完了した場合に実行されるアクション
    func swipedLeftPosition()

    // 右側へのスワイプ動作が完了した場合に実行されるアクション
    func swipedRightPosition()

    // 元の位置に戻る動作が完了したに実行されるアクション
    func returnToOriginalPosition()
}

// MEMO: ItemCardView.xib内の「Use Safe Area Layout Guides」のチェックを外しておく
class ItemCardView: CustomViewBase {

    weak var delegate: ItemCardDelegate?

    // インスタンス化されたView識別用のインデックス番号
    var index: Int = 0

    // 「拡大画像を見る」ボタンタップ時に実行されるクロージャー
    var largeImageButtonTappedHandler: (() -> ())?

    // このViewの初期状態の中心点を決める変数(意図的に揺らぎを与えてランダムで少しずらす)
    private var initialCenter: CGPoint = CGPoint(
        x: UIScreen.main.bounds.size.width / 2,
        y: UIScreen.main.bounds.size.height / 2
    )

    // このViewの初期状態の傾きを決める変数(意図的に揺らぎを与えてランダムで少しずらす)
    private var initialTransform: CGAffineTransform = .identity

    // ドラッグ処理開始時のViewがある位置を格納する変数
    private var originalPoint: CGPoint = CGPoint.zero
    
    // 中心位置からのX軸＆Y軸方向の位置を格納する変数
    private var xPositionFromCenter: CGFloat = 0.0
    private var yPositionFromCenter: CGFloat = 0.0
    
    // 中心位置からのX軸方向へ何パーセント移動したか（移動割合）を格納する変数
    // MEMO: 端部まで来た状態を1とする
    private var currentMoveXPercentFromCenter: CGFloat = 0.0
    private var currentMoveYPercentFromCenter: CGFloat = 0.0

    // 初期化される前と後の拡大縮小比
    private let beforeInitializeScale: CGFloat = 1.00
    private let afterInitializeScale: CGFloat  = 1.00

    // Presenterから取得したデータを反映させるUI部品
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var publishedLabel: UILabel!
    @IBOutlet weak private var accessLabel: UILabel!
    @IBOutlet weak private var budgetLabel: UILabel!
    @IBOutlet weak private var messageLabel: UILabel!

    // 「拡大画像を見る」ボタン
    @IBOutlet weak private var largeImageButton: UIButton!
    
    // MARK: - Initializer

    override func initWith() {
        setupItemCardView()
        setupSlopeAndIntercept()
        setupInitialPositionWithAnimation()
    }
    
    // MARK: - Function

    func setModelData(_ travel: TravelModel) {
        thumbnailImageView.image         = travel.image
        thumbnailImageView.contentMode   = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true

        titleLabel.text          = travel.title
        publishedLabel.text      = travel.published
        accessLabel.text         = travel.access
        budgetLabel.text         = travel.budget
        messageLabel.text        = travel.message
    }

    // MARK: - Private Function

    // 続きを読むボタンがタップされた際に実行される処理
    @objc private func largeImageButtonTapped(_ sender: UIButton) {
        largeImageButtonTappedHandler?()
    }

    // ドラッグが開始された際に実行される処理
    @objc private func startDragging(_ sender: UIPanGestureRecognizer) {

        // 中心位置からのX軸＆Y軸方向の位置の値を更新する
        xPositionFromCenter = sender.translation(in: self).x
        yPositionFromCenter = sender.translation(in: self).y

        // UIPangestureRecognizerの状態に応じた処理を行う
        switch sender.state {

        // ドラッグ開始時の処理
        case .began:

            // ドラッグ処理開始時のViewがある位置を取得する
            originalPoint = CGPoint(
                x: self.center.x - xPositionFromCenter,
                y: self.center.y - yPositionFromCenter
            )

            // ItemCardDelegateのbeganDraggingを実行する
            self.delegate?.beganDragging()

            // Debug.
            //print("beganCenterX:", originalPoint.x)
            //print("beganCenterY:", originalPoint.y)

            // ドラッグ処理開始時のViewのアルファ値を変更する
            UIView.animate(withDuration: 0.26, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.alpha = 0.96
            }, completion: nil)

            break
            
        // ドラッグ最中の処理
        case .changed:

            // 動かした位置の中心位置を取得する
            let newCenterX = originalPoint.x + xPositionFromCenter
            let newCenterY = originalPoint.y + yPositionFromCenter

            // Viewの中心位置を更新して動きをつける
            self.center = CGPoint(x: newCenterX, y: newCenterY)

            // ItemCardDelegateのupdatePositionを実行する
            self.delegate?.updatePosition(self, centerX: newCenterX, centerY: newCenterY)

            // 中心位置からのX軸方向へ何パーセント移動したか（移動割合）を計算する
            currentMoveXPercentFromCenter = min(xPositionFromCenter / UIScreen.main.bounds.size.width, 1)

            // 中心位置からのY軸方向へ何パーセント移動したか（移動割合）を計算する
            currentMoveYPercentFromCenter = min(yPositionFromCenter / UIScreen.main.bounds.size.height, 1)

            // Debug.
            //print("currentMoveXPercentFromCenter:", currentMoveXPercentFromCenter)
            //print("currentMoveYPercentFromCenter:", currentMoveYPercentFromCenter)

            // 上記で算出したX軸方向の移動割合から回転量を取得し、初期配置時の回転量へ加算した値でアファイン変換を適用する
            let initialRotationAngle = atan2(initialTransform.b, initialTransform.a)
            let whenDraggingRotationAngel = initialRotationAngle + CGFloat.pi / 14 * currentMoveXPercentFromCenter
            let transforms = CGAffineTransform(rotationAngle: whenDraggingRotationAngel)

            // 拡大縮小比を適用する
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: 1.00, y: 1.00)
            self.transform = scaleTransform

            break

        // ドラッグ終了時の処理
        case .ended, .cancelled:

            // ドラッグ終了時点での速度を算出する
            let whenEndedVelocity = sender.velocity(in: self)

            // Debug.
            //print("whenEndedVelocity:", whenEndedVelocity)

            // 移動割合のしきい値を超えていた場合には、画面外へ流れていくようにする（しきい値の範囲内の場合は元に戻る）
            let shouldMoveToLeft  = (currentMoveXPercentFromCenter < -0.38)
            let shouldMoveToRight = (currentMoveXPercentFromCenter > 0.38)

            if shouldMoveToLeft {
                moveInvisiblePosition(verocity: whenEndedVelocity, isLeft: true)
            } else if shouldMoveToRight {
                moveInvisiblePosition(verocity: whenEndedVelocity, isLeft: false)
            } else {
                moveOriginalPosition()
            }

            // ドラッグ開始時の座標位置の変数をリセットする
            originalPoint = CGPoint.zero
            xPositionFromCenter = 0.0
            yPositionFromCenter = 0.0
            currentMoveXPercentFromCenter = 0.0
            currentMoveYPercentFromCenter = 0.0

            break

        default:
            break
        }
    }

    // このViewに対する初期設定を行う
    private func setupItemCardView() {

        // このViewの基本的な設定
        self.clipsToBounds   = true
        self.backgroundColor = UIColor.white
        self.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 300, height: 360))

        // このViewの装飾に関する設定
        self.layer.masksToBounds = false
        self.layer.borderColor   = UIColor(code: "#dddddd").cgColor
        self.layer.borderWidth   = 0.75
        self.layer.cornerRadius  = 0.00
        self.layer.shadowRadius  = 3.00
        self.layer.shadowOpacity = 0.50
        self.layer.shadowOffset  = CGSize(width: 0.75, height: 1.75)
        self.layer.shadowColor   = UIColor(code: "#dddddd").cgColor
        
        // このViewの「拡大画像を見る」ボタンに対する初期設定を行う
        largeImageButton.addTarget(self, action: #selector(self.largeImageButtonTapped), for: .touchUpInside)

        // このViewのUIPanGestureRecognizerの付与を行う
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.startDragging))
        self.addGestureRecognizer(panGestureRecognizer)
    }

    // このViewの初期状態での傾きと切片の付与を行う
    private func setupSlopeAndIntercept() {

        // 中心位置のゆらぎを表現する値を設定する
        let fluctuationsPosX: CGFloat = CGFloat(Int.createRandom(range: Range(-12...12)))
        let fluctuationsPosY: CGFloat = CGFloat(Int.createRandom(range: Range(-12...12)))

        // 基準となる中心点のX座標を設定する（デフォルトではデバイスの中心点）
        let initialCenterPosX: CGFloat = UIScreen.main.bounds.size.width / 2
        let initialCenterPosY: CGFloat = UIScreen.main.bounds.size.height / 2

        // 配置したViewに関する中心位置を算出する
        initialCenter = CGPoint(
            x: initialCenterPosX + fluctuationsPosX,
            y: initialCenterPosY + fluctuationsPosY
        )

        // 傾きのゆらぎを表現する値を設定する
        let fluctuationsRotateAngle: CGFloat = CGFloat(Int.createRandom(range: Range(-6...6)))
        let angle = fluctuationsRotateAngle * .pi / 180.0 * 0.25
        initialTransform = CGAffineTransform(rotationAngle: angle)
        initialTransform.scaledBy(x: afterInitializeScale, y: afterInitializeScale)
    }

    // このViewを画面外から現れるアニメーションと共に初期配置する位置へ配置する
    private func setupInitialPositionWithAnimation() {

        // 表示前のカードの位置を設定する
        let beforeInitializePosX: CGFloat = CGFloat(Int.createRandom(range: Range(-300...300)))
        let beforeInitializePosY: CGFloat = CGFloat(-Int.createRandom(range: Range(300...600)))
        let beforeInitializeCenter = CGPoint(x: beforeInitializePosX, y: beforeInitializePosY)

        // 表示前のカードの傾きを設定する
        let beforeInitializeRotateAngle: CGFloat = CGFloat(Int.createRandom(range: Range(-90...90)))
        let angle = beforeInitializeRotateAngle * .pi / 180.0
        let beforeInitializeTransform = CGAffineTransform(rotationAngle: angle)
        beforeInitializeTransform.scaledBy(x: beforeInitializeScale, y: beforeInitializeScale)

        // 画面外からアニメーションを伴って現れる動きを設定する
        self.alpha = 0
        self.center = beforeInitializeCenter
        self.transform = beforeInitializeTransform

        UIView.animate(withDuration: 0.93, animations: {
            self.alpha = 1
            self.center = self.initialCenter
            self.transform = self.initialTransform
        })
    }

    // このViewを元の位置へ戻す
    private func moveOriginalPosition() {

        UIView.animate(withDuration: 0.26, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {

            // ドラッグ処理終了時はViewのアルファ値を元に戻す
            self.alpha = 1.00

            // このViewの配置を元の位置まで戻す
            self.center = self.initialCenter
            self.transform = self.initialTransform

        }, completion: nil)
        
        // ItemCardDelegateのreturnToOriginalPositionを実行する
        self.delegate?.returnToOriginalPosition()
    }

    // このViewを左側ないしは右側の領域外へ動かす
    private func moveInvisiblePosition(verocity: CGPoint, isLeft: Bool = true) {

        // 変化後の予定位置を算出する（Y軸方向の位置はverocityに基づいた値を採用する）
        let absPosX = UIScreen.main.bounds.size.width * 1.6
        let endCenterPosX = isLeft ? -absPosX : absPosX
        let endCenterPosY = verocity.y
        let endCenterPosition = CGPoint(x: endCenterPosX, y: endCenterPosY)

        UIView.animate(withDuration: 0.48, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {

            // ドラッグ処理終了時はViewのアルファ値を元に戻す
            self.alpha = 1.00

            // 変化後の予定位置までViewを移動する
            self.center = endCenterPosition

        }, completion: { _ in

            // ItemCardDelegateのswipedLeftPositionを実行する
            let _ = isLeft ? self.delegate?.swipedLeftPosition() : self.delegate?.swipedRightPosition()

            // 画面から該当のViewを削除する
            self.removeFromSuperview()
        })
    }
}
