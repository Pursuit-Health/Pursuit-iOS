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

extension WeightsType {
    func getWeightsFrom(weight: Double) -> String {
        let unit: UnitMass = (self.rawValue == 0) ? UnitMass.pounds : UnitMass.kilograms
        let convertedWeight = Measurement(value: weight, unit: UnitMass.pounds).converted(to: unit)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        let messurementFormatter = MeasurementFormatter()
        messurementFormatter.unitOptions = .providedUnit
        messurementFormatter.numberFormatter = numberFormatter
        return messurementFormatter.string(from: convertedWeight)
    }
}

class WeightsTableViewCell: UITableViewCell {

    weak var delegate: WeightsTableViewCellDelegate?
    
    @IBOutlet weak var weigntsSegmentedControl: RoundedSegmentedControl! {
        didSet {
            weigntsSegmentedControl.items = ["Lbs", "Kgs"]
            weigntsSegmentedControl.selectedSegmentIndex = UserSettings.shared.weightsType.rawValue
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
