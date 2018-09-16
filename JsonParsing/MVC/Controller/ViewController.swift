//
//  ViewController.swift
//  JsonParsing
//
//  Created by Sonika on 9/9/18.
//  Copyright © 2018 Sonika. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
    
    let strUrl = "https://jsonplaceholder.typicode.com/posts" //
    @IBOutlet weak var tableViewOutlet: UITableView!
    var arrList:Array<Dictionary<String,Any?>?>? = nil

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
  
       // activityIndicatorOutlet.startAnimating()
        //self.perform(#selector(callPostApi), with: nil, afterDelay: 10)
        callPostApi() //3rd call the api
        
    }
    //2nd part
    @objc private func callPostApi(){
        let url = URL.init(string: strUrl)
        //optinal binding --main thread start
        guard let _ = url else { //guard statement is used  when we dont have to do anhy execution after nil.
            return
        }
        activityIndicatorOutlet.startAnimating()
    
        if let _ = url {
            let req = URLRequest.init(url: url!)
            let session = URLSession.shared //singleton class
            let dataTask = session.dataTask(with: req, completionHandler: { (data, response, error) in
                
                DispatchQueue.main.async {
                    self.activityIndicatorOutlet.stopAnimating()
                    self.activityIndicatorOutlet.isHidden = true
                }
                
                if let _ = error {
                    DispatchQueue.main.async {
                        self.alert(msg: (error?.localizedDescription)!)
                    }
                    
                    print(error!)
                    return 
                }
                
                if let value = data {
                    do {
                        self.arrList = try JSONSerialization.jsonObject(with: value, options: .allowFragments) as? Array<Dictionary<String, Any>>
                        //writing options and reading options
                        
                        print(self.arrList!)
                       // self.view.backgroundColor = UIColor.red // the ui related work should not be called in asynchronous task
                        //UIView.backgroundColor must be used from main thread only
                        
                        if let _ = self.arrList , self.arrList!.count > 0
                            
                            //The value is set here because it is depndent on the values coming from url.//avoid crash
                        {
                            DispatchQueue.main.async { //concept of GCD 
                            self.tableViewOutlet.dataSource = self
                            self.tableViewOutlet.delegate = self
                            self.tableViewOutlet.reloadData()
                            }
                        }
                        
                    } catch let err {
                        print(err.localizedDescription)
                    }
                }
                
            })
            //when we get response , bring the asynchronous task on main thread.. GCD - operational queue and dispatch.
            //system will not wait for the data to come .. so it will be asynchronous task other tasks will get srated.
            //request starts getting sent to the server.. asynchronous block
            dataTask.resume()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = arrList {
            return (arrList?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postcell") as! PostTableViewCell
        if let _ = arrList {
            let dict = arrList![indexPath.row]
            if dict != nil {
                cell.lblTitle.text = dict!["title"] as? String
                let userid = dict!["id"] as! Int
                cell.lblUserId.text = String(format:"id: %d" , userid)
                cell.lblDesc.text = dict!["body"] as? String
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let secondVC:SecondViewController = story.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
         let dict = arrList![indexPath.row]
        secondVC.dictSVC = dict!
        
        self.navigationController?.pushViewController(secondVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Mark : AlertViewController
    private func alert (msg: String){
    //alert function
    let alert = UIAlertController.init(title: "Error", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (_) in
            print("ButtonClicked")
        }
        let retry = UIAlertAction.init(title: "retry", style: .default) { (_) in
            print("retry Button Clicked")
            self.callPostApi()
        }
        
        alert.addAction(retry)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

}

