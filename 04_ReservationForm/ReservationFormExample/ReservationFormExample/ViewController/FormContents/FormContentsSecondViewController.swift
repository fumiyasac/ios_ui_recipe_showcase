//
//  FormContentsSecondViewController.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/22.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class FormContentsSecondViewController: UIViewController {

    @IBOutlet weak private var formScrollView: UIScrollView!
    @IBOutlet weak private var inputAddressView: FormInputTextFieldView!
    @IBOutlet weak private var inputTelephoneView: FormInputTextFieldView!
    @IBOutlet weak private var inputMailaddressView: FormInputTextFieldView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFormScrollView()
        setupInputAddressView()
        setupInputTelephoneView()
        setupInputMailaddressView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeShown(_:)),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeHidden(_:)),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    // キーボードを開く際のObserver処理（キーボードの高さ分だけ中をずらす）
    // 参考: https://newfivefour.com/swift-ios-xcode-resizing-on-keyboard.html
    @objc private func keyboardWillBeShown(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String : Any] else {
            return
        }
        guard let keyboardInfo = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        UIView.animate(withDuration: duration, animations: {
            self.formScrollView.contentInset = contentInsets
            self.formScrollView.scrollIndicatorInsets = contentInsets
            self.view.layoutIfNeeded()
        })
    }

    // キーボードを閉じる際のObserver処理（中をずらしたのを戻す）
    @objc private func keyboardWillBeHidden(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String : Any] else {
            return
        }
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        UIView.animate(withDuration: duration, animations: {
            self.formScrollView.contentInset = .zero
            self.formScrollView.scrollIndicatorInsets = .zero
            self.view.layoutIfNeeded()
        })
    }

    @objc private func formScrollViewTapped(sender: UITapGestureRecognizer) {

        // キーボードを閉じる処理
        self.view.endEditing(true)
    }

    private func setupFormScrollView() {
        formScrollView.delaysContentTouches = false

        // MEMO: UIScrollViewとFiestResponderの処理を共存させる場合の処理
        let tapGestureForScrollView = UITapGestureRecognizer(target: self, action: #selector(self.formScrollViewTapped(sender:)))
        formScrollView.addGestureRecognizer(tapGestureForScrollView)
    }

    private func setupInputAddressView() {
        inputAddressView.delegate = self
        inputAddressView.setType(.inputAddress)
        inputAddressView.setTitle("住所または所在地:")
        inputAddressView.setRemark("※必須", isRequired: true)
        inputAddressView.setDescription("イベント参加者もしくは団体の代表者のお名前を入力")
        inputAddressView.setPlaceholder("例) 東京都○○区△△ xx-yy-zz")
    }

    private func setupInputTelephoneView() {
        inputTelephoneView.delegate = self
        inputTelephoneView.setType(.inputTelephone)
        inputTelephoneView.setTitle("ご連絡可能な電話番号:")
        inputTelephoneView.setRemark("※必須", isRequired: true)
        inputTelephoneView.setDescription("電話番号をハイフンなしの10~11桁で入力")
        inputTelephoneView.setPlaceholder("例) 09012341234")
    }

    private func setupInputMailaddressView() {
        inputMailaddressView.delegate = self
        inputMailaddressView.setType(.inputMailaddress)
        inputMailaddressView.setTitle("ご連絡可能なメールアドレス:")
        inputMailaddressView.setRemark("※必須", isRequired: true)
        inputMailaddressView.setDescription("メールアドレスを半角英数字で入力")
        inputMailaddressView.setPlaceholder("例) info@example.com")
    }
}

// MARK: - FormInputTextFieldDelegate

extension FormContentsSecondViewController: FormInputTextFieldDelegate {
    
    func getInputTextByTextFieldType(_ text: String, type: TextFieldType) {
        switch type {

        case TextFieldType.inputAddress:
            FormDataStore.shared.address = text

            // Debug.
            //print("入力された住所:", FormDataStore.shared.address)

        case TextFieldType.inputTelephone:
            FormDataStore.shared.telephone = text

            // Debug.
            //print("入力された電話番号:", FormDataStore.shared.telephone)

        case TextFieldType.inputMailaddress:
            FormDataStore.shared.mailaddress = text
            
            // Debug.
            //print("入力されたメールアドレス:", FormDataStore.shared.mailaddress)

        default:
            return
        }
    }
}
