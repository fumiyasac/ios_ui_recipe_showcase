//
//  EventHeaderView.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/25.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

class EventHeaderView: CustomViewBase {

    static let viewHeight: CGFloat = 82.0

    private let extendedText      = "詳細情報を展開する"
    private let notExtendedText   = "詳細情報を閉じる"

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var termLabel: UILabel!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var extendedStateLabel: UILabel!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupEventHeaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupEventHeaderView()
    }

    // MARK: - Function

    func setHeader(_ event: EventEntity) {
        titleLabel.text = event.title
        termLabel.text  = event.term
    }

    func shouldExtended(_ result: Bool) {
        var rotationEnd: CGFloat
        var currentStateText: String
        if result {
            rotationEnd = 180.0
            currentStateText = notExtendedText
        } else {
            rotationEnd = 0.0
            currentStateText = extendedText
        }

        extendedStateLabel.text = currentStateText
        UIView.animate(withDuration: 0.16, animations: {
            self.iconImageView.transform = CGAffineTransform(rotationAngle: (rotationEnd * CGFloat(Double.pi)) / 180.0)
        })
    }

    // MARK: - Private Function

    private func setupEventHeaderView() {

        //
        extendedStateLabel.text = extendedText
        
        //
        iconImageView.backgroundColor = UIColor.white
        iconImageView.image = UIImage.fontAwesomeIcon(name: .arrowAltCircleUp, style: .solid, textColor: UIColor(code: "#44aeea"), size: CGSize(width: 20, height: 20))
        iconImageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
    }
}
