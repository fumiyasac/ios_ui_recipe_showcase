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

    // メニューボタン押下時のポップアップ開始位置
    private let startPopoverPoint: CGPoint = {
        let centerX = UIScreen.main.bounds.width / 2
        let centerY = DeviceSize.iPhoneXCompatible() ? UIScreen.main.bounds.height - 68.0 : UIScreen.main.bounds.height - 24.0
        return CGPoint(x: centerX, y: centerY)
    }()

    @IBOutlet weak private var reservationMenuButtonView: ReservationMenuButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("現在の予約一覧")
        setupReservationMenuButtonView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    private func setupReservationMenuButtonView() {
        reservationMenuButtonView.menuButtonTappedHandler = {
            self.showMenuPopover()
        }
    }

    private func showMenuPopover() {

        // Popover内で表示する内容を作成する(矢印の下部分のサイズを考慮)
        let withArrowView = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 196))
        let reservationMenuContentsView = ReservationMenuContentsView(frame: CGRect(x: 0, y: 0, width: 260, height: 180))
        withArrowView.addSubview(reservationMenuContentsView)

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
