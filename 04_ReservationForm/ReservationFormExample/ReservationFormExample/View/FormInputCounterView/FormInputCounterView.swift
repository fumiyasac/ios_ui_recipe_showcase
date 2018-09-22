//
//  FormInputCounterView.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/22.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

protocol FormInputCounterDelegate: NSObjectProtocol {

    // カウンターを押した際の処理
    func getCounterValue(_ counter: Int)
}

//@IBDesignable
class FormInputCounterView: CustomViewBase {

    // FormInputCounterDelegateの宣言
    weak var delegate: FormInputCounterDelegate?

    private var counter: Int = 0
    private var minimunCount: Int = 0
    private var maximunCount: Int = 100

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var remarkLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!

    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var decrementButton: UIButton!
    @IBOutlet weak private var incrementButton: UIButton!
    
    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupFormInputCounterView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupFormInputCounterView()
    }

    // MARK: - Function

    func setTitle(_ text: String) {
        titleLabel.text = text
    }

    func setRemark(_ text: String, isRequired: Bool = false) {
        if isRequired {
            remarkLabel.textColor = UIColor(code: "#ff0000")
        } else {
            remarkLabel.textColor = UIColor(code: "#666666")
        }
        remarkLabel.text = text
    }

    func setDescription(_ text: String) {
        descriptionLabel.text = text
    }

    func setCountLimit(minimum: Int, maximum: Int) {
        minimunCount = minimum
        maximunCount = maximum
    }

    // MARK: - Private Function

    @objc private func incrementButtonTapped(sender: UIButton) {
        if counter >= maximunCount {
            return
        }
        counter = counter + 1
        setCounterLabelWithAnimation(isIncrement: true)
        self.delegate?.getCounterValue(counter)
    }

    @objc private func decrementButtonTapped(sender: UIButton) {
        if counter <= minimunCount {
            return
        }
        counter = counter - 1
        setCounterLabelWithAnimation(isIncrement: false)
        self.delegate?.getCounterValue(counter)
    }

    private func setupFormInputCounterView() {

        // ボタン押下時のアクションの設定
        decrementButton.layer.masksToBounds = true
        decrementButton.layer.cornerRadius  = 19.0
        decrementButton.addTarget(self, action:  #selector(self.decrementButtonTapped(sender:)), for: .touchUpInside)

        incrementButton.layer.masksToBounds = true
        incrementButton.layer.cornerRadius  = 19.0
        incrementButton.addTarget(self, action:  #selector(self.incrementButtonTapped(sender:)), for: .touchUpInside)
    }

    private func setCounterLabelWithAnimation(isIncrement: Bool = true) {

        // アニメーション対象のViewの親にあたるViewをマスクにする
        counterLabel.superview?.layer.masksToBounds = true

        // カウント数を反映する
        counterLabel.text = String(counter)

        // アニメーションの設定を行う
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.duration = 0.16
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        var key: String
        if isIncrement {
            transition.subtype = CATransitionSubtype.fromRight
            key = "next"
        } else {
            transition.subtype = CATransitionSubtype.fromLeft
            key = "previous"
        }

        counterLabel.layer.removeAllAnimations()
        counterLabel.layer.add(transition, forKey: key)
    }
}
