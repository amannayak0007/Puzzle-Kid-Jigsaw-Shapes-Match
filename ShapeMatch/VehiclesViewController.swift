
import UIKit
import AVFoundation

class VehiclesViewController: UIViewController {
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    
    @IBOutlet var wrapperView: UIView!
    @IBOutlet weak var greatJobImg: UIImageView!
    
    @IBOutlet weak var chicken: UIImageView!
    @IBOutlet weak var crocodile: UIImageView!
    @IBOutlet weak var cuala: UIImageView!
    @IBOutlet weak var raccoon: UIImageView!
    
    @IBOutlet weak var chickenShadow: UIImageView!
    @IBOutlet weak var raccoonShadow: UIImageView!
    @IBOutlet weak var cualaShadow: UIImageView!
    @IBOutlet weak var crocodileShadow: UIImageView!
    
    var isChickenMoving: Bool = false
    var isCualaMoving: Bool = false
    var isRaccoonMoving: Bool = false
    var isCrocodileMoving: Bool = false
    
    var isChickenMatch: Bool = false
    var isCrocodileMatch: Bool = false
    var isCualaMatch: Bool = false
    var isRaccoonMatch: Bool = false
    
    var isSoundPlayed1 = true
    var isSoundPlayed2 = true
    var isSoundPlayed3 = true
    var isSoundPlayed4 = true
    
    
    var isAnimationGoing: Bool = false
    
    let maxIndexZ: CGFloat = 5
    var backgroundColor: UIColor = UIColor.white
    
    var cualaPositionX: CGFloat = 0
    var cualaPositionY: CGFloat = 0
    var chickenPositionX: CGFloat = 0
    var chickenPositionY: CGFloat = 0
    var crocodilePositionX: CGFloat = 0
    var crocodilePositionY: CGFloat = 0
    var raccoonPositionX: CGFloat = 0
    var raccoonPositionY: CGFloat = 0
    var height : CGFloat = 0
    var width : CGFloat = 0
    var heightOfGameArea: CGFloat = 0
    
    let showEmitterCell: CAEmitterCell = {
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "Star")?.cgImage
        emitterCell.scale = 0.01
        emitterCell.scaleRange = 0.1
        emitterCell.emissionRange = .pi
        emitterCell.lifetime = 20.0
        emitterCell.birthRate = 20
        emitterCell.velocity = -30
        emitterCell.velocityRange = -20
        emitterCell.yAcceleration = 30
        emitterCell.xAcceleration = 5
        emitterCell.spin = -0.5
        emitterCell.spinRange = 1.0
        return emitterCell
    }()
    
    lazy var snowEmitterLayer:CAEmitterLayer = {
        let emitterLayer =  CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2.0, y: -50)
        emitterLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        emitterLayer.emitterShape = CAEmitterLayerEmitterShape.cuboid
        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.timeOffset = 10
        emitterLayer.emitterCells = [self.showEmitterCell]
        
        return emitterLayer
    }()
    
    @IBOutlet weak var backButton: UIButton!
    
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConstraints()
        self.setInitialTriggers()
        self.backgroundColor = self.wrapperView.backgroundColor!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setDefaultPositions()
    }
    
    func setConstraints() {
        
        if DeviceType.IS_IPAD || (UIScreen.main.bounds.size.height == 1366 || UIScreen.main.bounds.size.width == 1366 || UIScreen.main.bounds.size.height == 1112) {
             height = 130
             width = 130
         } else if  UIScreen.main.bounds.size.width >= 1024{
             height = 125
             width = 125
         } else if DeviceType.IS_IPHONE_5{
             height = 48
              width = 48
         }else if DeviceType.IS_IPHONE_6 {
             height = 60
             width = 60
         }else{
             height = 74
             width = 74
         }
        
        heightOfGameArea = self.wrapperView.frame.height
        
        //reset storyboard constraints
        self.view.removeConstraints(self.view.constraints)
        
        // kuala
        self.cuala.removeConstraints(self.cuala.constraints)
        self.cuala.translatesAutoresizingMaskIntoConstraints = false
        self.cuala.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: heightOfGameArea * 0.8 * -1).isActive = true
        self.cuala.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 150).isActive = true
        self.cuala.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.cuala.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        // chicken
        self.chicken.removeConstraints(self.chicken.constraints)
        self.chicken.translatesAutoresizingMaskIntoConstraints = false
        self.chicken.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: heightOfGameArea * 0.6 * -1).isActive = true
        self.chicken.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 150).isActive = true
        self.chicken.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.chicken.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        // crocodile
        self.crocodile.removeConstraints(self.crocodile.constraints)
        self.crocodile.translatesAutoresizingMaskIntoConstraints = false
        self.crocodile.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: heightOfGameArea * 0.4 * -1).isActive = true
        self.crocodile.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 150).isActive = true
        self.crocodile.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.crocodile.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        // raccoon
        self.raccoon.removeConstraints(self.raccoon.constraints)
        self.raccoon.translatesAutoresizingMaskIntoConstraints = false
        self.raccoon.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: heightOfGameArea * 0.2 * -1).isActive = true
        self.raccoon.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 150).isActive = true
        self.raccoon.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.raccoon.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        // kuala shadow
        self.cualaShadow.removeConstraints(self.cualaShadow.constraints)
        self.cualaShadow.translatesAutoresizingMaskIntoConstraints = false
        self.cualaShadow.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: heightOfGameArea * 0.2 * -1).isActive = true
        self.cualaShadow.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -150).isActive = true
        self.cualaShadow.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.cualaShadow.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        //chicken shadow
        self.chickenShadow.removeConstraints(self.chickenShadow.constraints)
        self.chickenShadow.translatesAutoresizingMaskIntoConstraints = false
        self.chickenShadow.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: heightOfGameArea * 0.4 * -1).isActive = true
        self.chickenShadow.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -150).isActive = true
        self.chickenShadow.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.chickenShadow.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        // crocodile shadow
        self.crocodileShadow.removeConstraints(self.crocodileShadow.constraints)
        self.crocodileShadow.translatesAutoresizingMaskIntoConstraints = false
        self.crocodileShadow.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: heightOfGameArea * 0.8 * -1).isActive = true
        self.crocodileShadow.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -150).isActive = true
        self.crocodileShadow.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.crocodileShadow.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        // raccoon shadow
        self.raccoonShadow.removeConstraints(self.raccoonShadow.constraints)
        self.raccoonShadow.translatesAutoresizingMaskIntoConstraints = false
        self.raccoonShadow.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: heightOfGameArea * 0.6 * -1).isActive = true
        self.raccoonShadow.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -150).isActive = true
        self.raccoonShadow.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.raccoonShadow.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        //  great Job Star
        self.greatJobImg.removeConstraints(greatJobImg.constraints)
        self.greatJobImg.translatesAutoresizingMaskIntoConstraints = false
        self.greatJobImg.centerXAnchor.constraint(equalTo: self.wrapperView.centerXAnchor).isActive = true
        self.greatJobImg.centerYAnchor.constraint(equalTo: self.wrapperView.centerYAnchor).isActive = true
        self.greatJobImg.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.greatJobImg.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        // backButton
        self.backButton.removeConstraints(self.backButton.constraints)
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        self.backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
    }
    
    func setDefaultPositions() {
        // track respond position of an image
        // called after all constraints are set
        self.cualaPositionX = self.cuala.frame.origin.x
        self.cualaPositionY = self.cuala.frame.origin.y
        self.chickenPositionX = self.chicken.frame.origin.x
        self.chickenPositionY = self.chicken.frame.origin.y
        self.crocodilePositionX = self.crocodile.frame.origin.x
        self.crocodilePositionY = self.crocodile.frame.origin.y
        self.raccoonPositionX = self.raccoon.frame.origin.x
        self.raccoonPositionY = self.raccoon.frame.origin.y
    }
    
    func setInitialTriggers() {
        // showing images and hidding "Great Job" star
        self.greatJobImg.isHidden = true
        self.cualaShadow.isHidden = false
        self.crocodileShadow.isHidden = false
        self.raccoonShadow.isHidden = false
        self.chickenShadow.isHidden = false
        self.cuala.isHidden = false
        self.crocodile.isHidden = false
        self.chicken.isHidden = false
        self.raccoon.isHidden = false
        
        self.isCualaMoving = false
        self.isChickenMoving = false
        self.isCrocodileMoving = false
        self.isRaccoonMoving = false
        
        // reset matching triggers
        self.isCualaMatch = false
        self.isCrocodileMatch = false
        self.isRaccoonMatch = false
        self.isChickenMatch = false
        
        self.isAnimationGoing = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        SoundManager.shared.playOnlyOnce(sound: .move)
        for touch in touches {
            
            let location = touch.location(in: self.view)
            
            if self.cuala.frame.contains(location) && !isCualaMatch {
                self.cuala.center = location
                self.cuala.layer.zPosition = self.maxIndexZ
                self.isCualaMoving = true
                return
            }
            
            if self.chicken.frame.contains(location) && !isChickenMatch {
                self.chicken.center = location
                self.chicken.layer.zPosition = self.maxIndexZ
                self.isChickenMoving = true
                return
            }
            
            if self.crocodile.frame.contains(location) && !isCrocodileMatch {
                self.crocodile.center = location
                self.crocodile.layer.zPosition = self.maxIndexZ
                self.isCrocodileMoving = true
                return
            }
            
            if self.raccoon.frame.contains(location) && !isRaccoonMatch {
                self.raccoon.center = location
                self.raccoon.layer.zPosition = self.maxIndexZ
                self.isRaccoonMoving = true
                return
            }
            
            if self.view.frame.contains(location) && !self.greatJobImg.isHidden {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self.view)
            
            if self.isCualaMoving {
                self.cuala.center = location
            }
            
            if self.isCrocodileMoving {
                self.crocodile.center = location
            }
            
            if self.isRaccoonMoving {
                self.raccoon.center = location
            }
            
            if self.isChickenMoving {
                self.chicken.center = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.checkCollisions()
        
        // reset move activity triggers
        self.isChickenMoving = false
        self.isCrocodileMoving = false
        self.isRaccoonMoving = false
        self.isCualaMoving = false
        
        //set Z-index for image position
        self.cuala.layer.zPosition = 4
        self.chicken.layer.zPosition = 3
        self.crocodile.layer.zPosition = 2
        self.raccoon.layer.zPosition = 1
    }
    
    func spellShape(name : String) {
        let utterance = AVSpeechUtterance(string: name)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5  // Slow down the speaking rate
        utterance.pitchMultiplier = 1.5  // Increase the pitch      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.synthesizer.speak(utterance)
        }
    }
    
    func checkCollisions() {
        
        // checking collistions between animals images and shadows
        // called after touches ended
        
        // if animal image matchs with it's shadow
        if chicken.frame.intersects(chickenShadow.frame) {
            self.chicken.center = self.chickenShadow.center
            self.chickenShadow.isHidden = true
            self.isChickenMatch = true
            self.matchValidation()
            
            if isSoundPlayed1 {
                isSoundPlayed1 = false
                SoundManager.shared.playOnlyOnce(sound: .Correct)
                SoundManager.shared.addHapticFeedback(feedbackType: .success)
                chicken.layer.addSublayer(snowEmitterLayer)
                chicken.animateLabel()
                spellShape(name: "Taxi")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.snowEmitterLayer.removeFromSuperlayer()
                }
                
            }
        }
        
        if cuala.frame.intersects(cualaShadow.frame) {
            self.cuala.center = self.cualaShadow.center
            self.cualaShadow.isHidden = true
            self.isCualaMatch = true
            self.matchValidation()
            
            if isSoundPlayed2 {
                isSoundPlayed2 = false
                SoundManager.shared.playOnlyOnce(sound: .Correct)
                SoundManager.shared.addHapticFeedback(feedbackType: .success)
                
                cuala.layer.addSublayer(snowEmitterLayer)
                cuala.animateLabel()
                spellShape(name: "ambulance")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.snowEmitterLayer.removeFromSuperlayer()
                }
            }
        }
        
        if crocodile.frame.intersects(crocodileShadow.frame) {
            self.crocodile.center = self.crocodileShadow.center
            self.crocodileShadow.isHidden = true
            self.isCrocodileMatch = true
            self.matchValidation()
            if isSoundPlayed3 {
                isSoundPlayed3 = false
                SoundManager.shared.playOnlyOnce(sound: .Correct)
                SoundManager.shared.addHapticFeedback(feedbackType: .success)
                
                crocodile.layer.addSublayer(snowEmitterLayer)
                crocodile.animateLabel()
                spellShape(name: "Scooter")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.snowEmitterLayer.removeFromSuperlayer()
                }
            }
        }
        
        if raccoon.frame.intersects(raccoonShadow.frame) {
            self.raccoon.center = self.raccoonShadow.center
            self.raccoonShadow.isHidden = true
            self.isRaccoonMatch = true
            self.matchValidation()
            if isSoundPlayed4 {
                isSoundPlayed4 = false
                SoundManager.shared.playOnlyOnce(sound: .Correct)
                SoundManager.shared.addHapticFeedback(feedbackType: .success)
                
                
                raccoon.layer.addSublayer(snowEmitterLayer)
                raccoon.animateLabel()
                spellShape(name: "bicycle")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.snowEmitterLayer.removeFromSuperlayer()
                }
            }
        }
        
        
        // if animal image does not match with shadow, push image back to it's respond place
        if cuala.frame.intersects(crocodileShadow.frame) || cuala.frame.intersects(raccoonShadow.frame) || cuala.frame.intersects(chickenShadow.frame) {
            print("!! \(cuala.frame.origin.x) \(cuala.frame.origin.y)")
            
            self.cuala.frame.origin.x = self.cualaPositionX
            self.cuala.frame.origin.y = self.cualaPositionY
            
            print("!! \(cuala.frame.origin.x) \(cuala.frame.origin.y)")
            SoundManager.shared.addHapticFeedback(feedbackType: .error)
            SoundManager.shared.playOnlyOnce(sound: .InCorrect)
        }
        
        if crocodile.frame.intersects(cualaShadow.frame) || crocodile.frame.intersects(raccoonShadow.frame) || crocodile.frame.intersects(chickenShadow.frame) {
            self.crocodile.frame.origin.x = self.crocodilePositionX
            self.crocodile.frame.origin.y = self.crocodilePositionY
            SoundManager.shared.addHapticFeedback(feedbackType: .error)
            SoundManager.shared.playOnlyOnce(sound: .InCorrect)
        }
        
        if raccoon.frame.intersects(cualaShadow.frame) || raccoon.frame.intersects(crocodileShadow.frame) || raccoon.frame.intersects(chickenShadow.frame) {
            self.raccoon.frame.origin.x = self.raccoonPositionX
            self.raccoon.frame.origin.y = self.raccoonPositionY
            SoundManager.shared.addHapticFeedback(feedbackType: .error)
            SoundManager.shared.playOnlyOnce(sound: .InCorrect)
        }
        
        if chicken.frame.intersects(cualaShadow.frame) || chicken.frame.intersects(crocodileShadow.frame) || chicken.frame.intersects(raccoonShadow.frame) {
            self.chicken.frame.origin.x = self.chickenPositionX
            self.chicken.frame.origin.y = self.chickenPositionY
            SoundManager.shared.addHapticFeedback(feedbackType: .error)
            SoundManager.shared.playOnlyOnce(sound: .InCorrect)
        }
    }
    
    func matchValidation() {
        // checking are all animals matching with their shadows
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if !self.isAnimationGoing {
            
            if self.isCualaMatch && self.isChickenMatch && self.isCrocodileMatch && self.isRaccoonMatch {
                // animating screen background when all images match shadows
                self.isAnimationGoing = true
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.wrapperView.backgroundColor = UIColor.init(red: 1, green: 0.4, blue: 0.4, alpha: 1)
                }, completion: { (Bool) -> Void in
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.wrapperView.backgroundColor = self.backgroundColor
                    }, completion: { (Bool) -> Void in
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.wrapperView.backgroundColor = UIColor.init(red: 1, green: 0.4, blue: 0.4, alpha: 1)
                        }, completion: { (Bool) -> Void in
                            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                                self.wrapperView.backgroundColor = self.backgroundColor
                            }, completion:nil)
                            self.isAnimationGoing = false
                        })
                    })
                    
                    
                }) 
                
                // hide all images
                self.cuala.isHidden = true
                self.crocodile.isHidden = true
                self.raccoon.isHidden = true
                self.chicken.isHidden = true
                self.chickenShadow.isHidden = true
                self.raccoonShadow.isHidden = true
                self.crocodileShadow.isHidden = true
                self.cualaShadow.isHidden = true
                
                // show the star
                self.greatJobImg.isHidden = false
                self.greatJobImg.animateLabel()
                DispatchQueue.main.async {
                    SoundManager.shared.playOnlyOnce(sound: .GreatJob)
                }
            }
            }}
    }
    
    @IBAction func didTapHome(_ sender : UIButton) {
        sender.animateLabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.dismiss(animated: true, completion: nil)
        }
        SoundManager.shared.addHapticFeedbackWithStyle(style: .medium)
        SoundManager.shared.playOnlyOnce(sound: .Tap)
    }
}
