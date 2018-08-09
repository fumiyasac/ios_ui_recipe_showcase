//
//  SideNavigationViewController.swift
//  MenuContentsExample
//
//  Created by 酒井文也 on 2018/08/09.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

protocol SideNavigationButtonDelegate: NSObjectProtocol {
    func changeMainContentsContainer(_ buttonType: Int)
}

class SideNavigationViewController: UIViewController {

    // SideNavigationButtonDelegateの宣言
    weak var delegate: SideNavigationButtonDelegate?
    
    @IBOutlet weak private var mainContentsButton: UIButton!
    @IBOutlet weak private var informationContentsButton: UIButton!
    @IBOutlet weak private var qiitaWebPageButton: UIButton!
    @IBOutlet weak private var slideshareWebPageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // それぞれのボタンに関する設定を行う
        mainContentsButton.tag = SideNavigationButtonType.mainContents.rawValue
        mainContentsButton.addTarget(self, action: #selector(self.sideNavigationButtonTapped(sender:)), for: .touchUpInside)
        
        informationContentsButton.tag = SideNavigationButtonType.informationContents.rawValue
        informationContentsButton.addTarget(self, action: #selector(self.sideNavigationButtonTapped(sender:)), for: .touchUpInside)

        qiitaWebPageButton.tag = SideNavigationButtonType.qiitaWebPage.rawValue
        qiitaWebPageButton.addTarget(self, action: #selector(self.sideNavigationButtonTapped(sender:)), for: .touchUpInside)

        slideshareWebPageButton.tag = SideNavigationButtonType.slideshareWebPage.rawValue
        slideshareWebPageButton.addTarget(self, action: #selector(self.sideNavigationButtonTapped(sender:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    // サイドナビゲーションが閉じた状態から左隅のドラッグを行ってコンテンツを開く際の処理
    @objc private func sideNavigationButtonTapped(sender: UIButton) {

        //
        let selectedButtonType = sender.tag
        self.delegate?.changeMainContentsContainer(selectedButtonType)
    }
}
