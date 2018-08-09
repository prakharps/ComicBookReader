//
//  CollectionViewController.swift
//  ComicBookReader
//
//  Created by Prakhar Srivastava on 07/08/18.
//  Copyright © 2018 Prakhar Srivastava. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CollectionViewController: UIViewController {

    @IBOutlet weak var fullScreenView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var comicCollectionView: UICollectionView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicAlternateText: UILabel!
    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var comicDate: UILabel!
    @IBOutlet weak var close: UIView!
    
    let collectionCellReuseIdentifier = "collectionViewCell"
    var statusBarHidden = false
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenView.isHidden = true
        comicCollectionView.delegate = self
        comicCollectionView.dataSource = self
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        headerView.layer.shadowOpacity = 0.2
        headerView.layer.shadowRadius = 20
        
        initializeLoader()
        indicator.startAnimating()
        Utils.getComics(direction: 0,isList: false)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadCollectionView),
                                               name: NSNotification.Name(rawValue: Globals.collectionLoadNotificationKey),
                                               object: nil)
        
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(disableFullScreen(closeTapGesture:)))
        close.addGestureRecognizer(closeTapGesture)
        
        let imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(hideImage(imageViewTapGesture:)))
        comicImage.isUserInteractionEnabled = true
        comicImage.addGestureRecognizer(imageViewTapGesture)
        
        let alternateTextTapGesture = UITapGestureRecognizer(target: self, action: #selector(showImage(alternateTextTapGesture:)))
        comicAlternateText.isUserInteractionEnabled = true
        comicAlternateText.addGestureRecognizer(alternateTextTapGesture)
        // Do any additional setup after loading the view.
    }
    
    @objc func reloadCollectionView() {
        if(Globals.gridItems.count == 10){
            comicCollectionView.reloadData()
            indicator.stopAnimating()
            comicCollectionView.isHidden = false
            Globals.isFetchingGrid = false
        }
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
    
    func initializeLoader(){
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubview(toFront: indicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
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

extension CollectionViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Globals.gridItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.comicCollectionView){
            let cell:CustomCollectionViewCell = self.comicCollectionView.dequeueReusableCell(withReuseIdentifier: collectionCellReuseIdentifier, for: indexPath) as! CustomCollectionViewCell
            var index = indexPath.item
            var comic = Globals.gridItems[index]
            Alamofire.request(comic.img).responseImage{ response in
                guard let image = response.result.value else {
                    return
                }
                cell.comicImageView.image = image
            }
            cell.comicTitle.text = comic.title
            return cell
        }
        var cell:UICollectionViewCell? = nil
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell:CustomCollectionViewCell = self.comicCollectionView.dequeueReusableCell(withReuseIdentifier: collectionCellReuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        var index = indexPath.row
        let comic = Globals.gridItems[index]
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
            if(!Globals.isFetchingGrid){
                Globals.isFetchingGrid = true
                let index = IndexPath(item: 1, section: 0)
                comicCollectionView.scrollToItem(at: index, at: .top, animated: false)
                comicCollectionView.scrollRectToVisible(CGRect(x:0.0, y:0.0, width:1.0, height:1.0), animated: false)
                self.indicator.startAnimating()
                Utils.getComics(direction: 1, isList: false)
            }
        }else if((offsetY + 50)<0 && Globals.gridStartNumber > 10){
            if(!Globals.isFetchingGrid){
                Globals.isFetchingGrid = true
                let index = IndexPath(item: 1, section: 0)
                comicCollectionView.scrollToItem(at: index, at: .top, animated: false)
                comicCollectionView.scrollRectToVisible(CGRect(x:0.0, y:0.0, width:1.0, height:1.0), animated: false)
                self.indicator.startAnimating()
                Utils.getComics(direction: -1, isList: false)
            }
        }
        
    }
}
