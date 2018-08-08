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

class CollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var comicCollectionView: UICollectionView!
    
    let collectionCellReuseIdentifier = "collectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comicCollectionView.delegate = self
        comicCollectionView.dataSource = self
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        headerView.layer.shadowOpacity = 0.2
        headerView.layer.shadowRadius = 20
        
        Utils.getComics(direction: 1,isList: false)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadCollectionView),
                                               name: NSNotification.Name(rawValue: Globals.collectionLoadNotificationKey),
                                               object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func reloadCollectionView() { comicCollectionView.reloadData() }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
