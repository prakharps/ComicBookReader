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
import AdsNativeSDK

class TableViewController: UIViewController,ANTableViewAdPlacerDelegate{
    
    @IBOutlet weak var fullScreenView: UIView!
    @IBOutlet weak var comicTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicAlternateText: UILabel!
    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var comicDate: UILabel!
    @IBOutlet weak var close: UIView!
    
    var positions:ANClientAdPositions! = ANClientAdPositions()
    var targeting:ANAdRequestTargeting! = ANAdRequestTargeting()
    var placer:ANTableViewAdPlacer! = ANTableViewAdPlacer()
    let tableCellReuseIdentifier = "tableViewCell"
    let tableCellReuseIdentifier_ad = "nativeAdTable"
    var statusBarHidden = false
    var indicator: UIActivityIndicatorView!
    var currentElement = 0
    var direction = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullScreenView.isHidden = true
        comicTableView.delegate = self
        //comicTableView.setDelegate(self)
        comicTableView.dataSource = self
        //comicTableView.setDataSource(self)
        comicTableView.rowHeight = 100
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        headerView.layer.shadowOpacity = 0.2
        headerView.layer.shadowRadius = 20
        
        initializeLoader()
        indicator.startAnimating()
        Utils.getComics(direction: 0,isList: true)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTable),
                                               name: NSNotification.Name(rawValue: Globals.tableLoadNotificationKey),
                                               object: nil)
        
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(disableFullScreen(closeTapGesture:)))
        close.addGestureRecognizer(closeTapGesture)
        
        let imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(hideImage(imageViewTapGesture:)))
        comicImage.isUserInteractionEnabled = true
        comicImage.addGestureRecognizer(imageViewTapGesture)
        
        let alternateTextTapGesture = UITapGestureRecognizer(target: self, action: #selector(showImage(alternateTextTapGesture:)))
        comicAlternateText.isUserInteractionEnabled = true
        comicAlternateText.addGestureRecognizer(alternateTextTapGesture)
        
        
        //Ads Native Code
        positions.addFixedIndexPath(IndexPath(item: 1, section: 0))
        positions.enableRepeatingPositions(withInterval: 5)
        
        
        
        var keywords = NSMutableArray()
        keywords.add("social")
        keywords.add("music")
        targeting.keywords = keywords as! [Any]
        
        self.placer = ANTableViewAdPlacer.init(tableView: comicTableView, viewController: self, adPositions: positions, defaultAdRenderingClass: SampleAdView.self)
        self.placer.delegate = self
        self.placer.loadAds(forAdUnitID: "2Pwo1otj1C5T8y6Uuz9v-xbY1aB09x8rWKvsJ-HI")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func disableFullScreen(closeTapGesture:UITapGestureRecognizer){
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
    
    @objc func reloadTable() {
        if(Globals.listItems.count == 10){
            comicTableView.reloadData()
            indicator.stopAnimating()
            comicTableView.isUserInteractionEnabled = true
            Globals.isFetchingList = false
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    func initializeLoader(){
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubview(toFront: indicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= Globals.listItems.count
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = comicTableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
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

//extension TableViewController{
extension TableViewController:UITableViewDataSource,UITableViewDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return Globals.listItems.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.comicTableView){
            let cell:CustomTableViewCell = self.comicTableView.an_dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! CustomTableViewCell
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
            currentElement = index
            return cell
        }
        var cell:UITableViewCell? = nil
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if(tableView == self.comicTableView){
//            let cell:CustomTableViewCell = self.comicTableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! CustomTableViewCell
//            let index = indexPath.row
//            let comic = Globals.listItems[index]
//            Alamofire.request(comic.img).responseImage{ response in
//                guard let image = response.result.value else {
//                    return
//                }
//                cell.comicImageView.image = image
//            }
//            cell.comicTitle.text = comic.title
//            cell.comicAlternateText.text = comic.alt
//            currentElement = index
//            return cell
//        }
//        var cell:UITableViewCell? = nil
//        return cell!
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                if(tableView == self.comicTableView){
                    let cell:CustomTableViewCell = self.comicTableView.an_dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! CustomTableViewCell
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if(tableView == self.comicTableView){
//            let cell:CustomTableViewCell = self.comicTableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! CustomTableViewCell
//            var index = indexPath.row
//            let comic = Globals.listItems[index]
//            comicImage.image = cell.comicImageView.image
//            Alamofire.request(comic.img).responseImage{ response in
//                guard let image = response.result.value else {
//                    return
//                }
//                self.comicImage.image = image
//            }
//            comicTitle.text = comic.title
//            let date = "\(comic.day!)/\(comic.month!)/\(comic.year!)"
//            comicDate.text = date
//            comicAlternateText.text = comic.alt
//            fullScreenView.isHidden = false
//            self.tabBarController?.tabBar.isHidden = true
//            statusBarHidden = true
//            setNeedsStatusBarAppearanceUpdate()
//        }
//    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        var difference = (contentHeight - scrollViewHeight)
        if(difference < 0 ){
            difference *= -1
        }
        difference += 50.0
        if(offsetY > difference){
            if(!Globals.isFetchingList){
                Globals.isFetchingList = true
                comicTableView.isUserInteractionEnabled = false
                let index = IndexPath(item: 1, section: 0)
                comicTableView.scrollToRow(at: index, at: .top, animated: false)
                comicTableView.scrollRectToVisible(CGRect(x:0.0, y:0.0, width:1.0, height:1.0), animated: false)
                self.indicator.startAnimating()
                Utils.getComics(direction: 1, isList: true)
            }
        }else if((offsetY + 50) < 0 && Globals.listStartNumber > 10){
            if(!Globals.isFetchingList){
                Globals.isFetchingList = true
                comicTableView.isUserInteractionEnabled = false
                let index = IndexPath(item: 1, section: 0)
                comicTableView.scrollToRow(at: index, at: .top, animated: false)
                comicTableView.scrollRectToVisible(CGRect(x:0.0, y:0.0, width:1.0, height:1.0), animated: false)
                self.indicator.startAnimating()
                Utils.getComics(direction: -1, isList: true)
            }
        }
        
    }
 
}
