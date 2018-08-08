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
    
    @IBOutlet weak var comicTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    let tableCellReuseIdentifier = "tableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // Do any additional setup after loading the view.
    }
    
    @objc func reloadTable() { comicTableView.reloadData() }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.comicTableView){
            let cell:CustomTableViewCell = self.comicTableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! CustomTableViewCell
            var index = indexPath.row
            var comic = Globals.listItems[index]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
