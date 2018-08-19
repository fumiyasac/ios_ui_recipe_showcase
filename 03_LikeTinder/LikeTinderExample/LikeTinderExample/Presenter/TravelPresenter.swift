//
//  TravelPresenter.swift
//  LikeTinderExample
//
//  Created by 酒井文也 on 2018/08/19.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

protocol TravelPresenterProtocol: class {
    func bindTravelModels(_ travelModels: [TravelModel])
}

class RecipePresenter {

    var presenter: TravelPresenterProtocol!
    
    // MARK: - Initializer

    init(presenter: TravelPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Functions

    // データの一覧を取得する
    func getTravelModels() {
        let travelModels = generateTravelModels()
        self.presenter.bindTravelModels(travelModels)
    }

    // MARK: - Private Functions

    // データの一覧を作成する
    private func generateTravelModels() -> [TravelModel] {
        return []
    }
}
