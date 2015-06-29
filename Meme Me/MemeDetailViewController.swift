//
//  MemeDetailViewController.swift
//  Meme Me
//
//  Created by Enrico Montana on 5/10/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!
    
    var meme: Meme!


    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        memeImage.image = meme.memeImage
        tabBarController?.tabBar.hidden = true

    }


}