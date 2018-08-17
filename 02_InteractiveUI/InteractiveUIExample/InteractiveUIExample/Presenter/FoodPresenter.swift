//
//  FoodPresenter.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/10.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// FoodPresenterの処理を実行した際にViewController側で行う処理のプロトコル定義
protocol FoodPresenterProtocol: class {
    func getFoodList(_ foods: [Food])
}

class FoodPresenter {

    var presenter: FoodPresenterProtocol!

    // MARK: - Initializer

    init(presenter: FoodPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Functions

    // サンプル用の食べ物(寿司)データを取得する
    func getAllFoods() {
        let foods = generateFoodList()
        self.presenter.getFoodList(foods)
    }

    // MARK: - Private Functions

    // サンプル用の食べ物(寿司)データを作成する
    private func generateFoodList() -> [Food] {
        return [
            Food(id: 1, name: "あいなめ", englishName: "Greenling", price: 600, rate: 4.2, imageName: "sample1"),
            Food(id: 2, name: "あじ", englishName: "Horse mackerel", price: 350, rate: 4.0, imageName: "sample2"),
            Food(id: 3, name: "いか", englishName: "Squid", price: 250, rate: 3.6, imageName: "sample3"),
            Food(id: 4, name: "えび", englishName: "Shrimp", price: 300, rate: 3.8, imageName: "sample4"),
            Food(id: 5, name: "かつお", englishName: "Bonito", price: 200, rate: 3.7, imageName: "sample5"),
            Food(id: 6, name: "かに", englishName: "Crab", price: 350, rate: 4.0, imageName: "sample6"),
            Food(id: 7, name: "かんぱち", englishName: "Greater amberjack", price: 400, rate: 3.7, imageName: "sample7"),
            Food(id: 8, name: "こはだ", englishName: "Gizzard shad", price: 200, rate: 3.5, imageName: "sample8"),
            Food(id: 9, name: "さけ", englishName: "Salmon", price: 300, rate: 3.8, imageName: "sample9"),
            Food(id: 10, name: "さんま", englishName: "Pacific saury", price: 400, rate: 3.7, imageName: "sample10"),
            Food(id: 11, name: "はまち", englishName: "Young yellowtail tuna", price: 300, rate: 3.5, imageName: "sample11"),
            Food(id: 12, name: "ほたて", englishName: "Scallops", price: 350, rate: 3.8, imageName: "sample12"),
            Food(id: 13, name: "まぐろ", englishName: "Tuna", price: 300, rate: 4.4, imageName: "sample13"),
            Food(id: 14, name: "まだい", englishName: "Red sea bream", price: 500, rate: 4.2, imageName: "sample14"),
        ]
    }
}
