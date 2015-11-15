//
//  TableViewController.swift
//  Rotten Tomatoes App
//
//  Created by USER on 11/15/15.
//  Copyright © 2015 JadeLe. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    var movies = [NSDictionary]()
    let urlString = "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214"
    
    var refreshControls: UIRefreshControl!
    
    @IBOutlet weak var viewError: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewError.hidden = true
        title = "Movies"
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControls = UIRefreshControl()
        refreshControls.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControls, atIndex: 0)
        
        
        // fetch Movive from server
        self.fetchMovie()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        self.fetchMovie()
        delay(4, closure: {
            self.refreshControls.endRefreshing()
        })
    }
    func fetchMovie() {
        
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        
        CozyLoadingActivity.show("Loading...", disableUI: true)
        // create a block to handle data from the web
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard error == nil else  {
                CozyLoadingActivity.hide(success: false, animated: true)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.viewError.hidden = false
                })
                
                print("error loading from URL", error!)
                return
            }
            
            CozyLoadingActivity.hide(success: true, animated: true)
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            self.movies = json["movies"] as! [NSDictionary]
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            });
            
            
        }
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        
        let poster = movies[indexPath.row].valueForKeyPath("posters")?.valueForKeyPath("thumbnail")
        print(poster)
        let posterString =  poster as! String
        let url = NSURL(string: posterString)
        let data = NSData(contentsOfURL: url!)
        cell.posterView.image = UIImage(data: data!)
        return cell
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    // MARK: - Navigation
    
    //    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! MovieDetailsViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        vc.movieDetail = movies[(indexPath?.row)!]
        
    }
    
    
}
