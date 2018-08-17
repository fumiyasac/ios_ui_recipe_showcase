//
//  MainViewController.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/10.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // サンプル用の食べ物(寿司)データを格納するための変数
    private var foodList: [Food] = []

    // FoodPresenterに設定したプロトコルを適用するための変数
    private var presenter: FoodPresenter!

    // カスタムトランジションを実行するためのインスタンス
    private let newsTransition   = NewsTransition()
//    private let detailTransition = DetailTransition()

    @IBOutlet weak private var foodListCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        setupFoodCollectionView()
        setupFoodPresenter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    private func setupNavigationController() {

        // UINavigationControllerDelegateの宣言
//        self.navigationController?.delegate = self

        // NavigationBarのデザイン調整を行う
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        // タイトルを表示する
        setupNavigationBarTitle("お寿司の一覧")

        // NavigationBarの下に配置するUIViewの幅と高さを算出する
        let statusBarHeight     = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0

        let headerWidth  = UIScreen.main.bounds.width
        let headerHeight = CGFloat(statusBarHeight + navigationBarHeight)

        // NavigationBarの下にUIViewを配置する
        let headerBackgroundView = UIView()
        headerBackgroundView.frame = CGRect(x: 0, y: 0, width: headerWidth, height: headerHeight)
        headerBackgroundView.backgroundColor = UIColor(code: "#333333")

        self.view.backgroundColor = UIColor(code: "#ececec")
        self.view.addSubview(headerBackgroundView)
    }

    private func setupFoodCollectionView() {
        foodListCollectionView.delegate   = self
        foodListCollectionView.dataSource = self
        foodListCollectionView.registerCustomCell(MainCollectionViewCell.self)
        foodListCollectionView.registerCustomReusableHeaderView(MainCollectionReusableHeaderView.self)
        foodListCollectionView.backgroundColor = UIColor(code: "#ececec")
    }

    private func setupFoodPresenter() {
        presenter = FoodPresenter(presenter: self)
        presenter.getAllFoods()
    }
}

// MARK: - FoodPresenterProtocol

extension MainViewController: FoodPresenterProtocol {

    // FoodPresenterのgetAllFoods()実行時にこの画面で実行される処理
    func getFoodList(_ foods: [Food]) {
        foodList = foods
        foodListCollectionView.reloadData()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension MainViewController: UIViewControllerTransitioningDelegate {

    // 進む場合のアニメーションの設定を行う
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        // 現在の画面サイズを引き渡して画面が縮むトランジションにする
        newsTransition.originalFrame = self.view.frame
        newsTransition.presenting = true
        return newsTransition
    }
    
    // 戻る場合のアニメーションの設定を行う
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        // 縮んだ状態から画面が戻るトランジションにする
        newsTransition.presenting = false
        return newsTransition
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: MainCollectionViewCell.self, indexPath: indexPath)
        let food = foodList[indexPath.row]
        cell.setCell(food)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {

    // 配置するUICollectionReusableViewのサイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        if section == 0 {
            return MainCollectionReusableHeaderView.viewSize
        } else {
            return CGSize.zero
        }
    }

    // 配置するUICollectionReusableViewの設定する
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let shouldDisplayHeader = (indexPath.section == 0 && kind == UICollectionElementKindSectionHeader)
        if shouldDisplayHeader {
            let header = collectionView.dequeueReusableCustomHeaderView(with: MainCollectionReusableHeaderView.self, indexPath: indexPath)
            header.newsButtonTappedHandler = {
                
                // ニュース画面へカスタムトランジションのプロトコルを適用させて遷移する
                let storyboard = UIStoryboard(name: "News", bundle: nil)
                let newsViewController = storyboard.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController

                let navigationController = UINavigationController(rootViewController: newsViewController)
                navigationController.transitioningDelegate = self
                self.present(navigationController, animated: true, completion: nil)
            }
            return header
        } else {
            return UICollectionReusableView()
        }
    }

    // セルのサイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return MainCollectionViewCell.getCellSize()
    }

    // セルの垂直方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return MainCollectionViewCell.cellMargin
    }

    // セルの水平方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return MainCollectionViewCell.cellMargin
    }

    // セル内のアイテム間の余白(margin)調整を行う
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin = MainCollectionViewCell.cellMargin
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
}
