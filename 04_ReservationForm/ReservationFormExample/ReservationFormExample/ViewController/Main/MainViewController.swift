//
//  MainViewController.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/20.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import SafariServices
import Popover

class MainViewController: UIViewController {

    // セクションごとに分けられたイベントデータを格納する変数
    private var sectionEventLists: [(extended: Bool, event: EventEntity)] = []

    @IBOutlet weak private var eventTableView: UITableView!
    @IBOutlet weak private var reservationMenuButtonView: ReservationMenuButtonView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("現在の募集イベント一覧")
        setupReservationMenuButtonView()
        setupEventTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    // TapGestureRecognizerが発動した際に実行されるアクション
    @objc private func eventHeaderViewTapped(sender: UITapGestureRecognizer) {

        guard let headerView = sender.view as? EventHeaderView else {
            return
        }

        // 該当セクションの値をタグから取得する
        let section = Int(headerView.tag)

        // 該当セクションの開閉状態を更新する
        let changedStatus = !sectionEventLists[section].extended
        sectionEventLists[section].extended = changedStatus

        // 該当セクション番号のUITableViewを更新する
        eventTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }

    // MEMO: Interface Builder上で「StyleをGrouped」にすることを忘れずに！
    private func setupEventTableView() {
        eventTableView.delegate           = self
        eventTableView.dataSource         = self
        eventTableView.estimatedRowHeight = 260.0
        eventTableView.rowHeight = UITableViewAutomaticDimension
        eventTableView.delaysContentTouches = false
        eventTableView.registerCustomCell(EventTableViewCell.self)

        // 表示したいイベントデータを反映する
        let events = EventModel.getAllEvents()
        sectionEventLists = events.map{ (extended: false, event: $0) }
        eventTableView.reloadData()
    }

    // メニューボタンに関する設定をする
    private func setupReservationMenuButtonView() {
        reservationMenuButtonView.menuButtonTappedHandler = {
            self.showMenuPopover()
        }
    }

    // Popover内で表示する内容を作成する(矢印の下部分のサイズを考慮)
    private func showMenuPopover() {
        let withArrowView = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 196))
        let reservationMenuContentsView = ReservationMenuContentsView(frame: CGRect(x: 0, y: 0, width: 260, height: 180))
        withArrowView.addSubview(reservationMenuContentsView)

        // メニューボタン押下時のポップアップ開始位置を算出する
        let safeAreaBottom = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom ?? 0
        let centerX = UIScreen.main.bounds.width / 2
        let centerY = UIScreen.main.bounds.height - reservationMenuButtonView.frame.height / 2 - safeAreaBottom
        let startPopoverPoint = CGPoint(x: centerX, y: centerY)

        // Popover表示のオプションを設定し表示する
        let options: [PopoverOption] = [
            .type(.up), .arrowSize(CGSize(width: 16, height: 12))
        ]
        let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.show(withArrowView, point: startPopoverPoint)

        // Popover内で展開されているViewのボタン押下時の処理
        reservationMenuContentsView.addReservationButtonTappedHandler = {
            popover.dismiss()

            // フォーム画面へ遷移する
            self.performSegue(withIdentifier: "goForm", sender: nil)
        }
        reservationMenuContentsView.showGithubButtonTappedHandler = {
            popover.dismiss()

            // SFSafariViewControllerで該当のリンク先を表示する
            if let url = URL(string: "https://github.com/fumiyasac/ios_ui_recipe_showcase") {
                let vc = SFSafariViewController(url: url)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    // セクションの個数を設定する（※今回の仕様は「1section = 1cell」の関係）
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionEventLists.count
    }

    // セクションのヘッダーに関する設定をする
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EventHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: EventHeaderView.viewHeight))

        // ヘッダーに表示するデータ等の設定をする
        let extended = sectionEventLists[section].extended
        let event = sectionEventLists[section].event
        headerView.tag = section
        headerView.shouldExtended(extended)
        headerView.setHeader(event)

        // UITapGestureRecognizerを付与する
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.eventHeaderViewTapped(sender:)))
        headerView.addGestureRecognizer(tapGestureRecognizer)
        return headerView
    }

    // セクションのヘッダーの高さを設定する
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return EventHeaderView.viewHeight
    }

    // MEMO: UITableViewの「StyleをGrouped」にした場合にフッターの隙間ができる現象の回避用
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    // セクションに配置するセルの個数を設定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // 変数:extendedの状態に応じて表示する個数を決める
        if sectionEventLists.count > 0 {
            return sectionEventLists[section].extended ? 1 : 0
        } else {
            return 0
        }
    }

    // セルに関する設定をする
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: EventTableViewCell.self)
        let event = sectionEventLists[indexPath.section].event
        cell.setCell(event)
        return cell
    }
}
