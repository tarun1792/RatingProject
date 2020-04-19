//
//  HistoryViewController.swift
//  Stamurai Assignment
//
//  Created by Tarun Kaushik on 18/04/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    var managedContext:NSManagedObjectContext!
    var ratings = [Ratings]()
    @IBOutlet weak var noRatingsMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.persistentContainer.viewContext
        loadDataFromContainer()
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func loadDataFromContainer() {
        
        do{
            let request = NSFetchRequest<Ratings>(entityName: "Ratings")
            // let request = TASK.fetchRequest()
            ratings = try self.managedContext.fetch(request)
            ratings = ratings.reversed()
            noRatingsMessageLabel.isHidden = ratings.count > 0
            
            self.historyTableView.reloadData()
            
        }catch let error as NSError{
            print("fetch error: \(error) , \(error.userInfo)")
        }
    }
    
}

extension HistoryViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ratings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let rating = ratings[indexPath.row]
        cell.textLabel?.text = "Rating \(rating.lowerRating)-\(rating.upperRating)"
        cell.detailTextLabel?.text = getFormatedDate(from: rating.date ?? Date())
        
        return cell
    }
    
    func getFormatedDate(from date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " h:mm a 'on' MMM dd,yyyy"
        return dateFormatter.string(from: date)
    }
}
