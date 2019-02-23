//
//  PPInfoCell.swift
//  mpe
//
//  Created by 北村 真二 on 2019/02/23.
//  Copyright © 2019 北村 真二. All rights reserved.
//

import UIKit

class PPInfoCell: UITableViewCell {

	class func ppInfoCell() -> PPInfoCell {
		
		let vc = UIViewController(nibName: "PPInfoCell", bundle: nil)
		let cell = vc.view as! PPInfoCell
		
		return cell
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
	@IBOutlet weak var ppLabel: UILabel!
	@IBOutlet weak var infoLabel: UILabel!
}
