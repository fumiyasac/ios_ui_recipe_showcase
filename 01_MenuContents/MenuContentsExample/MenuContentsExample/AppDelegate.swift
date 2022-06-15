//
//  AppDelegate.swift
//  MenuContentsExample
//
//  Created by 酒井文也 on 2018/08/07.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

// 本サンプルにおいて現状非対応にしている、または最低限の対応だけに留めている部分は下記の通り
// 1. DarkMode: 現状ではDarkModeをキャンセルしています。
// 2. UISceneAPI: 現状挙動への問題はないがiOS13以降では非推奨となっています。

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // MEMO: DarkModeのキャンセル
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        // MEMO: iOS15に関する配色に関する調整対応
        setupNavigationBarAppearance()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}

    // MARK: - Private Function

    private func setupNavigationBarAppearance() {

        // iOS15以降ではUINavigationBarの配色指定方法が変化する点に注意する
        // https://shtnkgm.com/blog/2021-08-18-ios15.html

        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()

            // MEMO: UINavigationBar内部におけるタイトル文字の装飾設定
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 14.0)!,
                NSAttributedString.Key.foregroundColor : UIColor.black
            ]

            // MEMO: UINavigationBar背景色の装飾設定
            navigationBarAppearance.backgroundColor = UIColor.clear

            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }
}

