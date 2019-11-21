//
//  AQICell.swift
//  AQIDemo
//
//  Created by BenKu on 2019/7/31.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit

class AQICircleCell: UITableViewCell {

    @IBOutlet weak var aqiView: CircleView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
