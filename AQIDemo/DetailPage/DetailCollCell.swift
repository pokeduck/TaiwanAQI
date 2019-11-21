//
//  DetailCollCell.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/2.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit

class DetailCollCell: CollBaseCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        valueLabel.drawShadow()
        unitLabel.drawShadow()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
