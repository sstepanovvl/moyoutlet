//
//  PhotoCollectionViewCell.swift
//  moyOutlet
//
//  Created by Stepan Stepanov on 18.06.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var offerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib PhotoCollectionViewCell %",self.frame.size)
        
    }

}
