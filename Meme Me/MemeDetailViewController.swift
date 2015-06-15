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
    //@IBOutlet weak var memeTopLine: UILabel!

    
    var meme: Meme!


    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.memeImage.image = meme.memeImage
        //self.memeTopLine.text = (meme.topLine + " " + meme.bottomLine)
        println(meme.topLine + " " + meme.bottomLine)
        
    }


}