//
//  GraphCell.swift
//  Assignment
//
//  Created by Jitendra on 22/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import UIKit

class GraphCell: UITableViewCell {

    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var labelRelation: UILabel!
    @IBOutlet weak var buttonAddRelation: UIButton!
    @IBOutlet weak var contraintLeadInfoLabel: NSLayoutConstraint!
    
    private let kInitialPaddingPoint = 20
    
    var paddingMultiplier: Int = 1 {
        didSet {
            contraintLeadInfoLabel.constant = CGFloat(kInitialPaddingPoint * paddingMultiplier)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let view = UIView(frame: bounds)
        view.backgroundColor = UIColor.clear
        selectedBackgroundView = view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
