//
//  EventModel.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/25.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class EventModel {

    // MARK: - Static Function

    static func getAllEvents() -> [EventEntity] {

        // MEMO: 表示用のダミーデータの作成
        return [
            EventEntity(
                id: 1,
                imageName: "sample1",
                category: "体験教室",
                term: "2018年9月18日 10:00~18:00",
                place: "◯◯県◯◯市◯◯ 施設名△△",
                title: "陶芸1日体験コーナー(家族参加OK)",
                summary: "日本の伝統工芸でもある陶芸にお子様と一緒に触れられるとても貴重な機会です。ここで作成した陶器はお持ち帰りできます。"
            ),
            EventEntity(
                id: 2,
                imageName: "sample2",
                category: "体験教室",
                term: "2018年9月18日 18:00~22:00",
                place: "◯◯県◯◯市◯◯ レストラン△△",
                title: "ワインのある食卓と献立を考える会",
                summary: "家庭でも飲めるワインとそれに合わせる献立についてシェフをお招きしてお話しを聞くことができます。月1回開催予定です。"
            ),
            EventEntity(
                id: 3,
                imageName: "sample3",
                category: "体験教室",
                term: "2018年9月18日 7:00~16:00",
                place: "◯◯県◯◯市◯◯ △△",
                title: "農業体験イベント(家族参加OK)",
                summary: "夏野菜の収穫を通して自然や農業について触れ合ったり、これから家庭菜園を始める方向けの意見交換会も行う予定です。"
            ),
            EventEntity(
                id: 4,
                imageName: "sample4",
                category: "体験教室",
                term: "2018年9月18日 9:00~12:00",
                place: "◯◯県◯◯市◯◯ △△",
                title: "お茶室で本格的な茶道のお稽古",
                summary: "茶道の経験が全くない方でもお楽しみ頂くことができる会になっています。月1~2の開催の中で「日本の精神」に触れ合う機会を！"
            ),
            EventEntity(
                id: 5,
                imageName: "sample5",
                category: "体験教室",
                term: "2018年9月18日~2018年9月19日",
                place: "◯◯県◯◯市◯◯ △△",
                title: "初めての方歓迎！屋外キャンプで野外体験",
                summary: "自然や動物との触れ合いの中で共同生活を通して貴重な体験ができます。協調・連帯性を楽しく学んでいきましょう。"
            ),
            EventEntity(
                id: 6,
                imageName: "sample6",
                category: "体験教室",
                term: "2018年9月18日 11:00~20:00",
                place: "◯◯県◯◯市◯◯ △△",
                title: "フラワーアレンジメント体験教室",
                summary: "プリザーブドフラワーを利用したブーケやリースを作る体験ができます。お部屋や玄関に飾るものからギフトまで幅広く活用ができます。"
            )
        ]
    }
}
