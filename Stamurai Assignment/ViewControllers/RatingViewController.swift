//
//  RatingViewController.swift
//  Stamurai Assignment
//
//  Created by Tarun Kaushik on 18/04/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//

import UIKit
import CoreData

protocol RatingVCDelegate:class{
    func didChangeRatingValue(title:String)
}

class RatingViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var viewBottomContrains: NSLayoutConstraint!
    @IBOutlet weak var ratingButton: UIButton!
    
    let ratingSlider = RatingView(frame: .zero)
    let presentedBottomContraint:CGFloat = -10
    let dimissedBottomContraint:CGFloat = -400
    
    weak var delegate:RatingVCDelegate?
    var managedContext:NSManagedObjectContext!
    
    
    
    override func loadView() {
        super.loadView()
        self.viewBottomContrains.constant = self.dimissedBottomContraint
        self.view.layoutSubviews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        setupView()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateViewPresent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.animateViewDismiss()
    }
    
    @objc func backgroundTapped(){
        animateViewDismiss()
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        animateViewDismiss()
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        saveData()
        delegate?.didChangeRatingValue(title: "Rating \(Int(ratingSlider.lowerValue * 10))-\(Int(ratingSlider.upperValue * 10))")
        animateViewDismiss()
    }
    
    func saveData(){
        let rating = Ratings(context: managedContext)
        rating.date = Date()
        rating.lowerRating = Int32(Int(ratingSlider.lowerValue * 10))
        rating.upperRating = Int32(Int(ratingSlider.upperValue * 10))
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Rating couldnt be save because : \(error.localizedDescription)")
        }
    }
}

extension RatingViewController{
    
    fileprivate func addRatingView() {
        ratingSlider.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundView.addSubview(ratingSlider)
        
        ratingSlider.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: 20).isActive = true
        ratingSlider.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor, constant: -20).isActive = true
        ratingSlider.centerYAnchor.constraint(equalTo: self.backgroundView.centerYAnchor, constant: -5).isActive = true
        ratingSlider.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        ratingSlider.addTarget(self, action: #selector(self.ratingViewValueChanged), for: UIControl.Event.valueChanged)
        
        self.backgroundView.layoutSubviews()
    }
    
    @objc func ratingViewValueChanged(){
        
        UIView.setAnimationsEnabled(false)
        ratingButton.setTitle("Rating \(Int(ratingSlider.lowerValue * 10))-\(Int(ratingSlider.upperValue * 10))", for: .normal)
        ratingButton.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
   
    }
    
    func setupView(){
        self.backgroundView.roundCorners([.topLeft,.topRight], radius: 15)
        self.backgroundView.addShadowWith(cornerRadius: 0, shadow: 3, color: UIColor.lightGray, offset: CGSize(width: 0, height: 3), opacity: 1)
        
        addRatingView()
    }
    
    func animateViewPresent(){
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.viewBottomContrains.constant = self.presentedBottomContraint
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
            self.view.layoutSubviews()
        }) { (success) in
            // do something here
        }
    }
    
    func animateViewDismiss(){
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.viewBottomContrains.constant = self.dimissedBottomContraint
            self.view.backgroundColor = UIColor.clear
            self.view.layoutSubviews()
        }) { (success) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}

extension RatingViewController:UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view?.isDescendant(of: self.backgroundView) == true){
            return false
        }else{
            return true
        }
    }
}
