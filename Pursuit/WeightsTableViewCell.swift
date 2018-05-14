//
//  WeightsTableViewCell.swift
//  Pursuit
//
//  Created by Igor on 5/14/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
protocol WeightsTableViewCellDelegate: class {
    func userDidChangeWeightsType(type: WeightsType, on cell: WeightsTableViewCell)
}

enum WeightsType: Int {
    case lbs = 0
    case kgs = 1
}

class WeightsTableViewCell: UITableViewCell {

    weak var delegate: WeightsTableViewCellDelegate?
    
    @IBOutlet weak var weigntsSegmentedControl: RoundedSegmentedControl! {
        didSet {
            weigntsSegmentedControl.items = ["Lbs", "Kgs"]
            weigntsSegmentedControl.selectedSegmentIndex = User.shared.weightsType.rawValue
            weigntsSegmentedControl.addTarget(self, action: #selector(weightsSegmentControlChangedValue), for: .valueChanged)
        }
    }
    
    @objc func weightsSegmentControlChangedValue() {
        let selectedIndex = weigntsSegmentedControl.selectedSegmentIndex
        self.delegate?.userDidChangeWeightsType(type: WeightsType(rawValue: selectedIndex) ?? .lbs, on: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
