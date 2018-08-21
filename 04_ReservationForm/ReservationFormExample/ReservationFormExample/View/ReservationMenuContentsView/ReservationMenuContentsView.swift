//
//  ReservationMenuContentsView.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/21.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class ReservationMenuContentsView: CustomViewBase {
    
    var addReservationButtonTappedHandler: (() -> ())?
    var showGithubButtonTappedHandler: (() -> ())?

    @IBOutlet weak private var addReservationButton: UIButton!
    @IBOutlet weak private var showGithubButton: UIButton!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupReservationMenuContentsView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupReservationMenuContentsView()
    }

    // MARK: - Private Function

    @objc private func addReservationButtonTapped(sender: UIButton) {

        // ViewController側でクロージャー内にセットした処理を実行する
        addReservationButtonTappedHandler?()
    }

    @objc private func showGithubButtonTapped(sender: UIButton) {

        // ViewController側でクロージャー内にセットした処理を実行する
        showGithubButtonTappedHandler?()
    }

    private func setupReservationMenuContentsView() {

        // ボタン押下時のアクションの設定
        addReservationButton.addTarget(self, action:  #selector(self.addReservationButtonTapped(sender:)), for: .touchUpInside)
        showGithubButton.addTarget(self, action:  #selector(self.showGithubButtonTapped(sender:)), for: .touchUpInside)
    }
}
