//
//  MenuProfileView.swift
//  cencosud.supermercados
//
//  Created by edwin sierra on 28/07/2021.
//

import UIKit

class MenuProfileView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bonusPointsLabel: UILabel!
    @IBOutlet weak var cuponsLabel: UILabel!
    
    init() {
        super.init(frame: CGRect())
        self.loadViewFromNib()
    }
    
    deinit {
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.loadViewFromNib()
    }
    
    func loadViewFromNib() {
        Bundle.main.loadNibNamed("MenuProfileView", owner: self, options: nil)
        
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
}
