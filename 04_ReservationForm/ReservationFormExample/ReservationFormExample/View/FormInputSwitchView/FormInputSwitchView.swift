//
//  FormInputSwitchView.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/22.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

protocol FormInputSwitchDelegate: NSObjectProtocol {

    // テキストフィールドの入力を変更した際の処理
    func getStatusBySwitchType(_ isOn: Bool, type: SwitchType)
}

//@IBDesignable
class FormInputSwitchView: CustomViewBase {

    weak var delegate: FormInputSwitchDelegate?

    private var switchType: SwitchType!

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var remarkLabel: UILabel!
    @IBOutlet weak private var inputSwitch: UISwitch!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupFormInputSwitchView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupFormInputSwitchView()
    }

    // MARK: - Function

    func setType(_ type: SwitchType) {
        switchType = type
    }

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

    // MARK: - Private Function

    @objc private func switchStateChanged(sender: UISwitch) {
        self.delegate?.getStatusBySwitchType(sender.isOn, type: switchType)
    }

    private func setupFormInputSwitchView() {
        inputSwitch.isOn = false
        inputSwitch.onTintColor = UIColor(code: "#6db5a9")
        inputSwitch.tintColor   = UIColor(code: "#eeeeee")
        inputSwitch.addTarget(self, action: #selector(self.switchStateChanged(sender:)), for: .valueChanged)
    }
}
