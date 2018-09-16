//
//  SecondViewController.swift
//  JsonParsing
//
//  Created by Sonika on 16/9/18.
//  Copyright © 2018 Sonika. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var userIdSVC: UILabel!
    @IBOutlet weak var titleSVC: UILabel!
    @IBOutlet weak var descSVC: UILabel!
    
    var dictSVC : Dictionary<String, Any> = [:]
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dictSVC)
        
        self.userIdSVC.text = String.init("id")
        let userid = dictSVC["id"] as! Int
        self.userIdSVC.text = String(format:"id: %d" , userid)
        self.titleSVC.text = dictSVC["title"] as? String
        self.descSVC.text = dictSVC["body"] as? String
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
  
   

}
