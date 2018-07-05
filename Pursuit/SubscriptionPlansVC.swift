//
//  SubscriptionPlansVC.swift
//  Pursuit
//
//  Created by ігор on 7/3/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SubscriptionPlansVC: UIViewController {
    
    //MARK: Enums
    
    enum TierType: Int {
        case one        = 1
        case two        = 2
        case three      = 3
        case four       = 4
        case five       = 5
        
        var rate: String {
            switch self {
            case .one:
                return "$20/month"
            case .two:
                return "$35/month"
            case .three:
                return "$48/month"
            case .four:
                return "$72/month"
            case .five:
                return "$130/month"
            }
        }
        
        var clients: String {
            switch self {
            case .one:
                return "up to 5 clients"
            case .two:
                return "up to 10 clients"
            case .three:
                return "up to 15 clients"
            case .four:
                return "up to 25 clients"
            case .five:
                return "up to 50 clients"
            }
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var clientsCountLabel: UILabel!
    @IBOutlet weak var tierLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var tierSlider: PaymentsTierSlider!
    
    //MARK: Variables
    
    var tierType: TierType = .one {
        didSet {
            tierLabel.text         = "TIER \(tierType.rawValue)"
            rateLabel.text         = tierType.rate
            clientsCountLabel.text = tierType.clients
        }
    }
    
    //MARK: IBActions
    
    @IBAction func tierSliderValueChanged(_ sender: PaymentsTierSlider) {
        tierType = TierType(rawValue: Int(sender.value)) ?? .one
    }
    
    @IBAction func subscribeButtonPressed(_ sender: Any) {
       //subscribe
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCodeImage()
        
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    private func setUpCodeImage() {
        if let image = UIImage(named: "gift")?.withRenderingMode(.alwaysTemplate) {
            giftImageView.image = image
            giftImageView.tintColor = UIColor.lightGray
        }
    }
}
