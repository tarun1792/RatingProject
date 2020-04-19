//
//  ViewController.swift
//  Rating Assignment
//
//  Created by Tarun Kaushik on 18/04/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var historyTransaction = CustomTransition()

    @IBOutlet weak var ratingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RatingViewController{
            vc.delegate = self
        }
    }
    
    @IBAction func historyButtonTapped(_ sender: Any) {
        if let historyVC = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController{
            
            if #available(iOS 13.0, *){
                historyVC.modalPresentationStyle = .fullScreen
                historyVC.transitioningDelegate = self
            }else{
                historyVC.transitioningDelegate = self
            }
            
            self.present(historyVC, animated: true, completion: nil)
        }
       
    }
    
}

extension ViewController:RatingVCDelegate{
    func didChangeRatingValue(title: String) {
        ratingButton.setTitle(title, for: .normal)
    }
}

extension ViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        historyTransaction.mode = .present
        historyTransaction.animationStyle = .bottomUp
        historyTransaction.duration = 0.5
        
        return historyTransaction
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        historyTransaction.mode = .dismiss
        historyTransaction.animationStyle = .topDown
        historyTransaction.duration = 0.5
        
        return historyTransaction
    }

}

