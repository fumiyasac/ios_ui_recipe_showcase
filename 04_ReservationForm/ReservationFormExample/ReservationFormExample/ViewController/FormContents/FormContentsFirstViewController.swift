//
//  FormContentsFirstViewController.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/22.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class FormContentsFirstViewController: UIViewController {

    @IBOutlet weak private var formScrollView: UIScrollView!
    @IBOutlet weak private var inputNameView: FormInputTextFieldView!
    @IBOutlet weak private var addTicketView: FormInputCounterView!
    @IBOutlet weak private var selectEventView: FormSelectTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFormScrollView()
        setupInputNameView()
        setupAddTicketView()
        setupSelectEventView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeShown(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeHidden(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
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
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
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
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        UIView.animate(withDuration: duration, animations: {
            self.formScrollView.contentInset = .zero
            self.formScrollView.scrollIndicatorInsets = .zero
            self.view.layoutIfNeeded()
        })
    }

    @objc private func formScrollViewTapped(sender: UITapGestureRecognizer) {
        
        // MEMO: UIScrollViewにキーボードを引っ込めたいのでUITapGestureRecognizerを付与したが、
        // FormInputSelectTableView内のUITableViewCell(FormInputSelectTableViewCell)のタップが呼ばれない
        // → UITableViewCell(FormInputSelectTableViewCell)にUIButtonを配置して対処する

        // キーボードを閉じる処理
        self.view.endEditing(true)
    }

    private func setupFormScrollView() {
        formScrollView.delaysContentTouches = false

        // MEMO: UIScrollViewとFirstResponderの処理を共存させる場合の処理
        let tapGestureForScrollView = UITapGestureRecognizer(target: self, action: #selector(self.formScrollViewTapped(sender:)))
        formScrollView.addGestureRecognizer(tapGestureForScrollView)
    }

    private func setupInputNameView() {
        inputNameView.delegate = self
        inputNameView.setType(.inputName)
        inputNameView.setTitle("お名前:")
        inputNameView.setRemark("※必須", isRequired: true)
        inputNameView.setDescription("イベント参加者もしくは団体の代表者のお名前を入力")
        inputNameView.setPlaceholder("例) さかい ふみや")
    }

    private func setupAddTicketView() {
        addTicketView.delegate = self
        addTicketView.setTitle("必要なチケットの枚数:")
        addTicketView.setRemark("※必須", isRequired: true)
        addTicketView.setDescription("お申し込みをする人数を入力 ※最大50枚まで可能")
        addTicketView.setCountLimit(minimum: 0, maximum: 50)
    }

    private func setupSelectEventView() {
        selectEventView.delegate = self
        selectEventView.setTitle("参加イベントの選択:")
        selectEventView.setRemark("※必須", isRequired: true)
        selectEventView.setDescription("参加予定のイベントを下記より1つ選択")
        selectEventView.setEventList(EventModel.getAllEvents())
    }
}

// MARK: - FormInputTextFieldDelegate

extension FormContentsFirstViewController: FormInputTextFieldDelegate {

    func getInputTextByTextFieldType(_ text: String, type: TextFieldType) {
        if type == TextFieldType.inputName {
            FormDataStore.shared.name = text

            // Debug.
            //print("入力された名前:", FormDataStore.shared.name)
        }
    }
}

// MARK: - FormInputCounterDelegate

extension FormContentsFirstViewController: FormInputCounterDelegate {

    func getCounterValue(_ counter: Int) {
        FormDataStore.shared.ticketCount = counter

        // Debug.
        //print("チケットの枚数:", FormDataStore.shared.ticketCount)
    }
}

// MARK: - FormSelectTableViewDelegate

extension FormContentsFirstViewController: FormSelectTableDelegate {

    func getSelectedId(_ targetId: Int) {
        FormDataStore.shared.eventId = targetId

        // Debug.
        //print("選択したイベントのID:", FormDataStore.shared.eventId)
    }
}

