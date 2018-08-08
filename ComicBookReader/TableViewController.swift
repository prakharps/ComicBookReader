//
//  TableViewController.swift
//  ComicBookReader
//
//  Created by Prakhar Srivastava on 07/08/18.
//  Copyright © 2018 Prakhar Srivastava. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var fullScreenView: UIView!
    @IBOutlet weak var comicTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicAlternateText: UILabel!
    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var comicDate: UILabel!
    
    let tableCellReuseIdentifier = "tableViewCell"
    var statusBarHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenView.isHidden = true
        comicTableView.delegate = self
        comicTableView.dataSource = self
        comicTableView.rowHeight = 100
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        headerView.layer.shadowOpacity = 0.2
        headerView.layer.shadowRadius = 20
        Utils.getComics(direction: 1,isList: true)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTable),
                                               name: NSNotification.Name(rawValue: Globals.tableLoadNotificationKey),
                                               object: nil)
        
        let blurViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(disableFullScreen(blurViewTapGesture:)))
        blurView.addGestureRecognizer(blurViewTapGesture)
        
        let imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(hideImage(imageViewTapGesture:)))
        comicImage.addGestureRecognizer(imageViewTapGesture)
        
        let alternateTextTapGesture = UITapGestureRecognizer(target: self, action: #selector(showImage(alternateTextTapGesture:)))
        comicAlternateText.addGestureRecognizer(alternateTextTapGesture)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func disableFullScreen(blurViewTapGesture:UITapGestureRecognizer){
        fullScreenView.isHidden = true
        statusBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc func hideImage(imageViewTapGesture:UITapGestureRecognizer){
        comicImage.isHidden = true
    }
    
    @objc func showImage(alternateTextTapGesture:UITapGestureRecognizer){
        comicImage.isHidden = false
    }
    
    @objc func reloadTable() { comicTableView.reloadData() }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.comicTableView){
            let cell:CustomTableViewCell = self.comicTableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! CustomTableViewCell
            let index = indexPath.row
            let comic = Globals.listItems[index]
            Alamofire.request(comic.img).responseImage{ response in
                guard let image = response.result.value else {
                    return
                }
                cell.comicImageView.image = image
            }
            cell.comicTitle.text = comic.title
            cell.comicAlternateText.text = comic.alt
            return cell
        }
        var cell:UITableViewCell? = nil
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.comicTableView){
            let cell:CustomTableViewCell = self.comicTableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! CustomTableViewCell
            var index = indexPath.row
            let comic = Globals.listItems[index]
            comicImage.image = cell.comicImageView.image
            Alamofire.request(comic.img).responseImage{ response in
                guard let image = response.result.value else {
                    return
                }
                self.comicImage.image = image
            }
            comicTitle.text = comic.title
            let date = "\(comic.day!)/\(comic.month!)/\(comic.year!)"
            comicDate.text = date
            comicAlternateText.text = comic.alt
            fullScreenView.isHidden = false
            self.tabBarController?.tabBar.isHidden = true
            statusBarHidden = true
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
