//
//  FormInputTextFieldView.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/22.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

protocol FormInputTextFieldDelegate: NSObjectProtocol {

    // テキストフィールドの入力を変更した際の処理
    func getInputTextByTextFieldType(_ text: String, type: TextFieldType)
}

//@IBDesignable
class FormInputTextFieldView: CustomViewBase {

    weak var delegate: FormInputTextFieldDelegate?

    private var textFieldType: TextFieldType!

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var remarkLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var inputTextField: UITextField!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)
        
        setupFormInputTextFieldView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupFormInputTextFieldView()
    }

    // MARK: - Function

    func setType(_ type: TextFieldType) {
        textFieldType = type

        var keyboardType: UIKeyboardType
        var contentType: UITextContentType
        switch textFieldType {
        case .inputName?:
            contentType  = .name
            keyboardType = .default
        case .inputAddress?:
            contentType  = .fullStreetAddress
            keyboardType = .default
        case .inputTelephone?:
            contentType  = .telephoneNumber
            keyboardType = .numberPad
        case .inputMailaddress?:
            contentType  = .emailAddress
            keyboardType = .emailAddress
        default:
            fatalError()
        }
        inputTextField.textContentType = contentType
        inputTextField.keyboardType    = keyboardType
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

    func setDescription(_ text: String) {
        descriptionLabel.text = text
    }

    func setPlaceholder(_ text: String) {
        inputTextField.placeholder = text
    }

    // MARK: - Private Function

    @objc func textFieldDidChange(sender: UITextField) {
        if let targetText = inputTextField.text {
            self.delegate?.getInputTextByTextFieldType(targetText, type: textFieldType)
        }
    }

    private func setupFormInputTextFieldView() {
        inputTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
    }
}
