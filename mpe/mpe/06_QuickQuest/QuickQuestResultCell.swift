//
//  QuickQuestResultCell.swift
//  mpe
//
//  Created by 北村 真二 on 2019/01/29.
//  Copyright © 2019 北村 真二. All rights reserved.
//

import UIKit

class QuickQuestResultCell: UITableViewCell {

	class func quickQuestResultCell() -> QuickQuestResultCell {
		
		let vc = UIViewController(nibName: "QuickQuestResultCell", bundle: nil)
		let cell = vc.view as! QuickQuestResultCell
		return cell
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	@IBOutlet weak var backImageView: UIImageView!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var wordLabel: UILabel!
	@IBOutlet weak var infoLabel: UILabel!
	
}
