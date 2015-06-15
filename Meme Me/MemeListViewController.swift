//
//  MemeListViewController.swift
//  Meme Me
//
//  Created by Enrico Montana on 5/10/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import Foundation
import UIKit

class MemeListViewController: UIViewController, UITableViewDataSource {

    var memeList = [Meme]()
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        memeList = appDelegate.memeList
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println(self.memeList.count)
        return self.memeList.count
    }
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseIndentifier = "MemeCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIndentifier) as? UITableViewCell
        var memeRow = self.memeList[indexPath.row]
        
        if (cell != nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIndentifier)
            cell?.textLabel?.text = memeRow.topLine
            cell?.detailTextLabel?.text = memeRow.bottomLine
            cell?.imageView?.image = memeRow.memeImage
            
            println(memeRow.topLine)
            println(memeRow.bottomLine)
        }
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let memeDetailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
        memeDetailVC.meme = self.memeList[indexPath.row]
        self.navigationController!.pushViewController(memeDetailVC, animated: true)
        
    }
    

}