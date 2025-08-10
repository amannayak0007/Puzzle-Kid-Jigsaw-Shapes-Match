//
//  MathSectionVC.swift
// Lil Artist
//
//  Created by Aman Jain on 04/03/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import UIKit

class PuzzleSectionVC: UIViewController, PuzzleSectionCollectionViewCellDelegate {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    let cellScaling: CGFloat = 0.6
    var vc: UIViewController? = nil
    var interests = PuzzleCategories.fetchHomeCategories()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width/2 * cellScaling + 50)
        let cellHeight = floor(screenSize.height * cellScaling + 80)
        
        let insetX = (view.bounds.width/2 - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 4.0
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(PuzzleSectionVC.purchasedSuccess(notification:)), name: Notification.Name("isPurchased"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PuzzleSectionVC.purchasedFailed(notification:)), name: Notification.Name("isFailed"), object: nil)
    }
    
    @objc private func purchasedSuccess(notification: NSNotification) {
        collectionView.reloadData()
        let alert = UIAlertController(title: "Thank You", message: "Thank you for your purchase!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OKAction)
        dismiss(animated: false, completion: nil)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func purchasedFailed(notification: NSNotification) {
        dismiss(animated: false, completion: nil)
    }
    
    func didSelectLockedCell() {
//        HYParentalGate.sharedGate.show(successHandler: { [weak self] in
//            self?.showPurchasePopUp()
//        }, cancelHandler: {
//            print("parental gate dismissed")
//        })
    }
    
    func didSelectCell(withCategory category: PuzzleCategories) {
        if (vc != nil){
            return
        }
        
        switch category.categoryType {
        case .Animal:
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PuzzleGameViewController") as? PuzzleGameViewController
            vc?.screenName = "HomeScene"
            self.navigationController?.pushViewController(vc!, animated: false)
          
        case .Fruit:
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PuzzleGameViewController") as? PuzzleGameViewController
            vc?.screenName = "FruitPuzzleScene"
            self.navigationController?.pushViewController(vc!, animated: false)
            
        case .Object:
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PuzzleGameViewController") as? PuzzleGameViewController
            vc?.screenName = "ObjectPuzzleScene"
            self.navigationController?.pushViewController(vc!, animated: false)
            
        case .ShapeMatch:
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChoiceViewController") as? ChoiceViewController
            self.navigationController?.pushViewController(vc!, animated: false)
        }
        
        SoundManager.shared.addHapticFeedbackWithStyle(style: .medium)
        SoundManager.shared.playOnlyOnce(sound: .Tap)
    }
    
    
    @IBAction func didTapHome(_ sender : UIButton) {
        sender.animateLabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.navigationController?.popViewController(animated: true)
        }
        SoundManager.shared.addHapticFeedbackWithStyle(style: .rigid)
        SoundManager.shared.playOnlyOnce(sound: .Tap)
    }
    
}

extension PuzzleSectionVC : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleSectionCollectionViewCell", for: indexPath) as! PuzzleSectionCollectionViewCell
        cell.delegate = self
        cell.interest = interests[indexPath.item]
        return cell
    }
    
    

    
}

extension PuzzleSectionVC : UIScrollViewDelegate, UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}


protocol PuzzleSectionCollectionViewCellDelegate: AnyObject {
    func didSelectCell(withCategory category: PuzzleCategories)
    func didSelectLockedCell()
}

class PuzzleSectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sectionImage: UIImageView!
    weak var delegate: PuzzleSectionCollectionViewCellDelegate?
    @IBOutlet weak var overLayView: UIView!
    
    var interest: PuzzleCategories? {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI() {
        if let interest = interest {
            contentView.layer.cornerRadius = 50
            contentView.layer.borderWidth = 10
            contentView.layer.borderColor = UIColor.white.cgColor
            contentView.layer.masksToBounds = true
            contentView.backgroundColor = interest.color
            sectionImage.image = interest.featuredImage
        } else {
            sectionImage.image = nil
            sectionImage.backgroundColor = .clear
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(
        withDuration: 0.3,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0.9,
        options: [.allowUserInteraction, .beginFromCurrentState],
        animations: { self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)},
        completion: nil)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0.9,
        options: [.allowUserInteraction, .beginFromCurrentState],
        animations: { self.transform = .identity },
        completion: { success in
            if let interest = self.interest {
                self.delegate?.didSelectCell(withCategory: interest)
            }
        })
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(
        withDuration: 0.8,
        delay: 0,
        usingSpringWithDamping: 0.4,
        initialSpringVelocity: 0.8,
        options: [.allowUserInteraction, .beginFromCurrentState],
        animations: { self.transform = .identity },
        completion: nil)
    }
        
}

enum PuzzleCategoryType: Int {
    case Animal = 0, Fruit, Object, ShapeMatch
}

class PuzzleCategories {

    var title: String
    var featuredImage: UIImage
    var color: UIColor
    var categoryType: PuzzleCategoryType
    
    init(title: String, featuredImage: UIImage, color: UIColor, categoryType: PuzzleCategoryType) {
        self.title = title
        self.featuredImage = featuredImage
        self.color = color
        self.categoryType = categoryType
    }
    
    // dummy data
    static func fetchHomeCategories() -> [PuzzleCategories] {
        return [
            PuzzleCategories(title: "", featuredImage: UIImage(named: "animalBG")!, color: UIColor(red: 0.57, green: 1.00, blue: 0.67, alpha: 1.00), categoryType: .Animal),
            PuzzleCategories(title: "", featuredImage: UIImage(named: "fruitBG")!, color: UIColor(red: 0.44, green: 1.00, blue: 0.98, alpha: 1.00), categoryType: .Fruit),
            PuzzleCategories(title: "", featuredImage: UIImage(named: "objectBG")!, color: UIColor(red: 1.00, green: 0.43, blue: 0.47, alpha: 1.00), categoryType: .Object),
            PuzzleCategories(title: "", featuredImage: UIImage(named: "shapMatch")!, color: UIColor(red: 0.84, green: 0.82, blue: 0.96, alpha: 1.00), categoryType: .ShapeMatch),
        ]
    }
    
}
