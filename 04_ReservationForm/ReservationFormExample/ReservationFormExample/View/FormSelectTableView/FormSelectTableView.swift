//
//  FormSelectTableView.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/22.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

protocol FormSelectTableDelegate: NSObjectProtocol {

    // セルをタップした際の処理
    func getSelectedId(_ targetId: Int)
}

//@IBDesignable
class FormSelectTableView: CustomViewBase {

    weak var delegate: FormSelectTableDelegate?

    private var selectedId: Int = 0

    private var eventList: [EventEntity] = [] {
        didSet {
            self.selectTableView.reloadData()
        }
    }

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var remarkLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var selectTableView: UITableView!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupFormInputSelectTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupFormInputSelectTableView()
    }

    // MARK: - Function

    func setTitle(_ text: String) {
        titleLabel.text = text
    }

    func setRemark(_ text: String, isRequired: Bool = false) {
        if isRequired {
            remarkLabel.textColor = UIColor(code: "#ff0000")
        } else {
            remarkLabel.textColor = UIColor(code: "#666666")
        }
        remarkLabel.text = text
    }

    func setDescription(_ text: String) {
        descriptionLabel.text = text
    }

    func setEventList(_ events: [EventEntity]) {
        eventList = events
    }

    // MARK: - Private Function

    private func setupFormInputSelectTableView() {
        selectTableView.delegate = self
        selectTableView.dataSource = self
        selectTableView.registerCustomCell(FormSelectTableViewCell.self)
    }
}

extension FormSelectTableView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: FormSelectTableViewCell.self)
        let event = eventList[indexPath.row]
        let selectedResult = (selectedId == event.id)

        cell.setCell(event, selected: selectedResult)
        cell.selectButtonTappedhandler = {
            self.selectedId = event.id
            self.selectTableView.reloadData()
            self.delegate?.getSelectedId(self.selectedId)
        }
        return cell
    }
}
