//
//  UIImageExtension.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/21.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    // 元画像からサムネイル用の画像を書き出すメソッド
    func thumbnailOfSize(_ minLength: CGFloat) -> UIImage? {

        // 写真のオリジナルサイズの縦横の値を取得する
        let height = size.height
        let width = size.width

        // 写真のオリジナルサイズの縦横比を維持して引数が短辺になるようにリサイズする
        var imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: CGFloat(ceil(width * minLength / height)), height: minLength)))
        
        if height > width {
            imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: minLength, height: CGFloat(ceil(minLength * height / width)))))
        }

        // リサイズ処理を行って縮小した画像を生成する
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()

        return result
    }
}
