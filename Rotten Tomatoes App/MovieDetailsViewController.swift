//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes App
//
//  Created by USER on 11/15/15.
//  Copyright © 2015 JadeLe. All rights reserved.
//

import UIKit



class MovieDetailsViewController: UIViewController{
    
    @IBOutlet weak var posterViewLabel: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var synopsisLabel: UILabel!
    
    @IBOutlet weak var viewSynopsis: UIView!
    
    
    var movieDetail = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // init view
        viewSynopsis.backgroundColor = UIColor.grayColor()
        titleLabel.text = movieDetail["title"] as? String
        self.title = titleLabel.text
        synopsisLabel.text = movieDetail["synopsis"] as? String

        let poster = movieDetail.valueForKeyPath("posters")?.valueForKeyPath("detailed")
        print(poster)
        let posterString =  poster as! String
        let url = NSURL(string: posterString)
        let data = NSData(contentsOfURL: url!)
        posterViewLabel.image = UIImage(data: data!)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
