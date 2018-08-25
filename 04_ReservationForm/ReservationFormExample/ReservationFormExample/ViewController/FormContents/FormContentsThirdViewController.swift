//
//  FormContentsThirdViewController.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/22.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class FormContentsThirdViewController: UIViewController {

    @IBOutlet weak private var inputAgreementView: FormInputSwitchView!
    @IBOutlet weak private var inputAllowTelephoneView: FormInputSwitchView!
    @IBOutlet weak private var inputAllowMailMagazineView: FormInputSwitchView!
    @IBOutlet weak private var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInputAgreementView()
        setupInputAllowTelephoneView()
        setupInputAllowMailMagazineView()
        setupSubmitButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    @objc private func submitButtonTapped(sender: UIButton) {

        var title: String
        var message: String
        var completionHandler: (() -> ())? = nil

        // バリデーション結果を表示し、結果に応じたコールバック処理を設定する
        if FormDataStore.validate() {
            title   = "予約情報を受け付けました"
            message = "確認メールを入力して頂きましたメールアドレスへ送信しておりますので不備や誤りがないかをご確認下さい。\n※サンプルなので実際の動作は行われません。"
            completionHandler = {

                // MEMO: サンプルなのでこれまでの内容を削除しているが、ここでデータを送信する処理を本来は行う
                FormDataStore.deleteAll()

                // MEMO: 現在のViewController → UIPageViewController → FormViewControllerと辿る
                let parentVC = self.parent?.parent as! FormViewController
                parentVC.dismiss(animated: true, completion: nil)
            }
        } else {
            title   = "入力項目に不足があります"
            message = "必須項目が入力ないしは選択されていない可能性がございます。再度入力内容をご確認の上修正をお願い致します。"
        }
        showAlertWith(title: title, message: message, completionHandler: completionHandler)
    }

    private func setupInputAgreementView() {
        inputAgreementView.delegate = self
        inputAgreementView.setType(.agreement)
        inputAgreementView.setTitle("個人情報の取り扱いへの同意:")
        inputAgreementView.setRemark("※必須", isRequired: true)
    }

    private func setupInputAllowTelephoneView() {
        inputAllowTelephoneView.delegate = self
        inputAllowTelephoneView.setType(.allowTelephone)
        inputAllowTelephoneView.setTitle("前日の確認電話の希望:")
        inputAllowTelephoneView.setRemark("※任意", isRequired: false)
    }

    private func setupInputAllowMailMagazineView() {
        inputAllowMailMagazineView.delegate = self
        inputAllowMailMagazineView.setType(.allowMailMagazine)
        inputAllowMailMagazineView.setTitle("ニュースレターの希望:")
        inputAllowMailMagazineView.setRemark("※任意", isRequired: false)
    }

    private func setupSubmitButton() {
        submitButton.addTarget(self, action: #selector(self.submitButtonTapped), for: .touchUpInside)
    }

    // データ送信ボタンを押下した際のアラート表示を共通化したメソッド
    private func showAlertWith(title: String, message: String, completionHandler: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler?()
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - FormInputSwitchDelegate

extension FormContentsThirdViewController: FormInputSwitchDelegate {

    func getStatusBySwitchType(_ isOn: Bool, type: SwitchType) {
        switch type {

        case SwitchType.agreement:
            FormDataStore.shared.agreement = isOn

            // Debug.
            //print("個人情報の取り扱いへの同意:", FormDataStore.shared.agreement)

        case SwitchType.allowTelephone:
            FormDataStore.shared.allowTelephone = isOn

            // Debug.
            //print("前日の確認電話の希望:", FormDataStore.shared.telephone)

        case SwitchType.allowMailMagazine:
            FormDataStore.shared.allowMailMagazine = isOn

            // Debug.
            //print("ニュースレターの希望:", FormDataStore.shared.allowMailMagazine)
        }
    }
}
