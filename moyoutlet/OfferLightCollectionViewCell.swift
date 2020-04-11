//
//  OfferLightCollectionViewCell.swift
//  moyOutlet
//
//  Created by Stepan Stepanov on 17.06.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

import Foundation

class OfferLightCollectionViewCell: UICollectionViewCell {
    var  offerItem = OfferItem()
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @objc func configure() -> Void {
        let model = OfferItemViewConfig.init(model: self.offerItem)
        
        self.priceLabel.text = model.price
        self.brandLabel.text = model.brand
        self.titleLabel.text = model.name
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.priceView.layer.cornerRadius = 5
        self.priceView.layer.masksToBounds = true
        self.priceView.clipsToBounds = true
        print("awakeFromNib")
    }
    
}
