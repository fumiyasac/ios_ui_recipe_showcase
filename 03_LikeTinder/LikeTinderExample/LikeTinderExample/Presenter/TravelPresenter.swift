//
//  TravelPresenter.swift
//  LikeTinderExample
//
//  Created by 酒井文也 on 2018/08/19.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

protocol TravelPresenterProtocol: AnyObject {
    func bindTravelModels(_ travelModels: [TravelModel])
}

class TravelPresenter {

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
        return [
            TravelModel(
                id: 1,
                title: "青森の自然風景",
                imageName: "aomori",
                published: "2018.08.20",
                access: "新幹線で約3時間",
                budget: "¥50,000程度",
                message: "自然に溢れたスポット満載"
            ),
            TravelModel(
                id: 2,
                title: "熱海の街並み",
                imageName: "atami",
                published: "2018.08.20",
                access: "特急電車で約1時間",
                budget: "¥65,000程度",
                message: "温暖で過ごしやすいリゾート"
            ),
            TravelModel(
                id: 3,
                title: "福岡の太宰府天満宮",
                imageName: "fukuoka",
                published: "2018.08.20",
                access: "飛行機で約3時間",
                budget: "¥58,000程度",
                message: "食べ物と観光地と盛りだくさん"
            ),
            TravelModel(
                id: 4,
                title: "函館の通りからの風景",
                imageName: "hakodate",
                published: "2018.08.20",
                access: "飛行機で約2時間",
                budget: "¥62,000程度",
                message: "ウニやイカ等海の幸が美味しい"
            ),
            TravelModel(
                id: 5,
                title: "リニューアルした金沢駅",
                imageName: "kanazawa",
                published: "2018.08.20",
                access: "新幹線で約2.5時間",
                budget: "¥48,000程度",
                message: "北陸新幹線でアクセスが簡単に"
            ),
            TravelModel(
                id: 6,
                title: "神戸市の海からの景色",
                imageName: "kobe",
                published: "2018.08.20",
                access: "飛行機で約1.5時間",
                budget: "¥40,000程度",
                message: "夜景が綺麗でモダンな街が特徴"
            ),
            TravelModel(
                id: 7,
                title: "京都の昔ながらの街",
                imageName: "kyoto",
                published: "2018.08.20",
                access: "新幹線で約1.5時間",
                budget: "¥50,000程度",
                message: "良き日本の風流を感じる古都"
            ),
            TravelModel(
                id: 8,
                title: "沖縄の青く綺麗なビーチ",
                imageName: "okinawa",
                published: "2018.08.20",
                access: "航空機で約4時間",
                budget: "¥38,000程度",
                message: "緩やかな時間の流れと自然を"
            )
        ]
    }
}
