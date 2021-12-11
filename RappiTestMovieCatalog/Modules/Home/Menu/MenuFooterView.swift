//
//  MenuFooterView.swift
//  cencosud.supermercados
//
//  Created by edwin sierra on 28/07/2021.
//

import UIKit

class MenuFooterView: UIView {
    
    var delegate:MenuViewControllerDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var helpNumberLabel: UILabel!
    
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
        Bundle.main.loadNibNamed("MenuFooterView", owner: self, options: nil)
        
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.setupUI()
    }
    
    func setupUI() {
        self.helpNumberLabel.text = Constants.phoneNumber
    }
    
    @IBAction func logOff(_ sender: Any) {
        self.delegate?.MenuViewControllerDidTapLogOff()
    }
    
    @IBAction func callToHelp(_ sender: Any) {
        self.delegate?.MenuViewControllerDidTapCallHelp()
    }
    
}
