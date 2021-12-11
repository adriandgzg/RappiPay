//
//  MenuCategoryTableViewCell.swift
//  WongCencosud
//
//  Created by Eduardo Quispe Machaca on 22/7/21.
//

import UIKit

class MenuCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    
    func setNameCatecory(_ name: String)  {
        self.lbName.text = name
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
