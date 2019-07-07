//
//  FormViewController.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/20.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import KYNavigationProgress

class FormViewController: UIViewController {

    // 現在表示しているViewControllerのタグ番号
    private var selectedTag: Int = 0

    // ページングして表示させるViewControllerを保持する配列
    private var targetViewControllerLists = [UIViewController]()

    // ContainerViewにEmbedしたUIPageViewControllerのインスタンスを保持する
    private var pageViewController: UIPageViewController?

    private var closeButton: UIBarButtonItem!
    private var nextButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("予約情報の入力")
        setupKYNavigationProgress()
        setupNavigationCloseButton()
        setupNavigationNextButton()
        setupPageViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    @objc private func closeButtonTapped(_ sender: UIButton) {

        // キーボードを閉じる処理
        self.view.endEditing(true)

        // ポップアップで戻る前の確認表示を行う
        let title = "フォームから移動しますか？"
        let message = "現在入力中のデータは削除されます。\n本当に移動しますか？"
        let completionHandler: (() -> ())? = {
            FormDataStore.deleteAll()
            self.dismiss(animated: true, completion: nil)
        }

        // 入力途中のデータを消去して画面へ戻る
        showCloseAlertWith(title: title, message: message, completionHandler: completionHandler)
    }

    @objc private func nextButtonTapped(_ sender: UIButton) {

        // 加算したインデックス値を元にコンテンツ表示を更新する
        selectedTag = selectedTag + 1
        setKYNavigationProgressRatio()
        setNextButtonVisibility()

        if selectedTag <= targetViewControllerLists.count - 1 {
            pageViewController!.setViewControllers([targetViewControllerLists[selectedTag]], direction: .forward, animated: true, completion: nil)
        }
    }

    // KYNavigationProgressの動かす位置を設定する
    private func setKYNavigationProgressRatio() {
        let ratio = Float(selectedTag) / Float(targetViewControllerLists.count - 1)
        self.navigationController?.setProgress(ratio, animated: true)
    }

    // 右上の次へボタンの表示状態を設定する
    private func setNextButtonVisibility() {
        let view: UIView = nextButton.value(forKey: "view") as! UIView
        view.isHidden = (selectedTag == targetViewControllerLists.count - 1)
    }

    // ナビゲーションバーの右側にボタンを配置する
    private func setupNavigationNextButton() {
        let attributes = getAttributeForBarButtonItem()
        nextButton = UIBarButtonItem(title: "次へ ▶︎", style: .plain, target: self, action: #selector(self.nextButtonTapped(_:)))
        nextButton.tintColor = UIColor.white
        nextButton.setTitleTextAttributes(attributes, for: .normal)
        nextButton.setTitleTextAttributes(attributes, for: .highlighted)
        self.navigationItem.rightBarButtonItem = nextButton
    }

    // ナビゲーションバーの左側にボタンを配置する
    private func setupNavigationCloseButton() {
        let attributes = getAttributeForBarButtonItem()
        closeButton = UIBarButtonItem(title: "× 閉じる", style: .plain, target: self, action: #selector(self.closeButtonTapped(_:)))
        closeButton.tintColor = UIColor.white
        closeButton.setTitleTextAttributes(attributes, for: .normal)
        closeButton.setTitleTextAttributes(attributes, for: .highlighted)
        self.navigationItem.leftBarButtonItem = closeButton
    }

    // この画面のナビゲーションバー下アニメーションの設定
    private func setupKYNavigationProgress() {
        self.navigationController?.progress = 0.0
        self.navigationController?.progressTintColor = UIColor.init(code: "#44aeea", alpha: 1.0)
        self.navigationController?.trackTintColor    = UIColor.init(code: "#eeeeee", alpha: 1.0)
    }

    // 左右ナビゲーションバーに関するフォントや配色に関する設定
    private func getAttributeForBarButtonItem() -> [NSAttributedString.Key : Any] {
        var attributes = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.font]             = UIFont(name: "HiraKakuProN-W3", size: 13.0)
        attributes[NSAttributedString.Key.foregroundColor]  = UIColor.white
        return attributes
    }

    // 閉じる際のアラート表示に関する共通処理
    private func showCloseAlertWith(title: String, message: String, completionHandler: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "このページから戻る", style: .default, handler: { _ in
            completionHandler?()
        })
        alert.addAction(okAction)
        let ngAction = UIAlertAction(title: "入力を継続する", style: .default, handler: nil)
        alert.addAction(ngAction)
        self.present(alert, animated: true, completion: nil)
    }

    // UIPageViewControllerの設定
    private func setupPageViewController() {

        // UIPageViewControllerで表示したいViewControllerの一覧を取得する
        let sb = UIStoryboard(name: "FormContents", bundle: nil)
        let firstVC = sb.instantiateViewController(withIdentifier: "FormContentsFirstViewController") as! FormContentsFirstViewController
        let secondVC = sb.instantiateViewController(withIdentifier: "FormContentsSecondViewController") as! FormContentsSecondViewController
        let thirdVC = sb.instantiateViewController(withIdentifier: "FormContentsThirdViewController") as! FormContentsThirdViewController

        // 「タグ番号 = インデックスの値」でスワイプ完了時にどのViewControllerかを判別できるようにする ＆ 各ViewControllerの表示内容をセットする
        firstVC.view.tag  = 0
        secondVC.view.tag = 1
        thirdVC.view.tag  = 2

        // ページングして表示させるViewControllerを保持する配列へ追加する
        targetViewControllerLists.append(firstVC)
        targetViewControllerLists.append(secondVC)
        targetViewControllerLists.append(thirdVC)

        // ContainerViewにEmbedしたUIPageViewControllerを取得する
        for childViewController in children {
            if let targetPageViewController = childViewController as? UIPageViewController {
                pageViewController = targetPageViewController
            }
        }

        // UIPageViewControllerDelegate & UIPageViewControllerDataSourceの宣言
        pageViewController!.delegate = self
        pageViewController!.dataSource = self

        // 最初に表示する画面として配列の先頭のViewControllerを設定する
        pageViewController!.setViewControllers([targetViewControllerLists[0]], direction: .forward, animated: false, completion: nil)
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension FormViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // ページが動いたタイミング（この場合はスワイプアニメーションに該当）に発動する処理を記載するメソッド
    // （実装例）http://c-geru.com/as_blind_side/2014/09/uipageviewcontroller.html
    // （実装例に関する解説）http://chaoruko-tech.hatenablog.com/entry/2014/05/15/103811
    // （公式ドキュメント）https://developer.apple.com/reference/uikit/uipageviewcontrollerdelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        // スワイプアニメーションが完了していない時には処理をさせなくする
        if !completed { return }

        // ここから先はUIPageViewControllerのスワイプアニメーション完了時に発動する
        if let targetViewControllers = pageViewController.viewControllers {
            if let targetViewController = targetViewControllers.last {

                // 受け取ったインデックス値を元にコンテンツ表示を更新する
                selectedTag = targetViewController.view.tag
                setKYNavigationProgressRatio()
                setNextButtonVisibility()
            }
        }
    }

    // 逆方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        // インデックスを取得する
        guard let index = targetViewControllerLists.firstIndex(of: viewController) else {
            return nil
        }

        // インデックスの値に応じてコンテンツを動かす
        if index <= 0 {
            return nil
        } else {
            return targetViewControllerLists[index - 1]
        }
    }
    
    // 順方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        // インデックスを取得する
        guard let index = targetViewControllerLists.firstIndex(of: viewController) else {
            return nil
        }

        // インデックスの値に応じてコンテンツを動かす
        if index >= targetViewControllerLists.count - 1 {
            return nil
        } else {
            return targetViewControllerLists[index + 1]
        }
    }
}

