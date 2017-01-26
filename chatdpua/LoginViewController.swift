/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Firebase
import FirebaseAuth
import PCLBlurEffectAlert

// A delay function
func delay(seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

// MARK: SHOW ALERT
//show alert view if error
func showAlert(title: String, msg: String) {
    let alert = PCLBlurEffectAlert.Controller(title: "\(title)", message: "\(msg)", effect: UIBlurEffect(style: .dark), style: .actionSheet)
    let action = PCLBlurEffectAlert.AlertAction(title: "Cancel", style: .cancel, handler: { (act) in
        //cancel button on alertview, setLogin button to initial state
    })
    
    alert.addAction(action)
    alert.configure(cornerRadius: 10)
    alert.configure(overlayBackgroundColor: UIColor(colorLiteralRed: 0, green: 0, blue: 30, alpha: 0.4))
    alert.configure(messageFont: UIFont(name: "HelveticaNeue", size: 18.0)!, messageColor: UIColor.white)
    alert.show()
}

class LoginViewController: UIViewController {
    
    // MARK: IB outlets
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var heading: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var cloud1: UIImageView!
    @IBOutlet var cloud2: UIImageView!
    @IBOutlet var cloud3: UIImageView!
    @IBOutlet var cloud4: UIImageView!
    
    // MARK: further UI
    
    var particleEmitter: CAEmitterLayer!
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
    
    // MARK: view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTheUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        password.text = ""
        password.placeholder = "password"
        spinner.alpha = 0.0
        signUpButton.alpha = 1.0
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.particleEmitter.removeAllAnimations()
        print("animations removed (particles)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        particles()
        spinner.startAnimating()
    }
    
    // MARK: further methods
    
    @IBAction func login() {
        
        guard self.username.text != "", self.password.text != "" else { return }
        ///auth here
        setLoginButtonToProcessingAuthState()
        
    }
    
    
    
    //try to auth and processing indicator show
    func setLoginButtonToProcessingAuthState() {
        ///signUp button ALPHA
        self.signUpButton.alpha = 0.0
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.bounds.size.width += 80.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.center.y += 60.0
            self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
            self.spinner.alpha = 1.0
            ///auth here
            self.authAndIfSucceedOpenMainVC()
            
        }, completion: nil)
    }
    
    //set login button back to inital state
    func setLoginButtonToInitalState() {
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.bounds.size.width -= 80.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.center.y -= 60.0
            self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
            self.spinner.alpha = 0.0
        }, completion: nil)
        ///sign up button is alpha 0
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseOut], animations: {
            self.signUpButton.alpha = 1.0
        }, completion: nil)
    }
    
    ///auth
    //try of auth and if succeed open main vc
    func authAndIfSucceedOpenMainVC() {
        
        FIRAuth.auth()?.signIn(withEmail: self.username.text!, password: self.password.text!, completion: { (user, error) in
            if error != nil {
                /// alert view
                self.setLoginButtonToInitalState()
                showAlert(title: "Error", msg: error!.localizedDescription)
            }
            if let _ = user {       //login succeed\
                self.spinner.stopAnimating()
                self.spinner.alpha = 0.0
                let usersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC")
                self.present(usersViewController, animated: true, completion: nil)
            }
        })
    }
    
    //set up the UI
    func setUpTheUi() {
        signUpButton.layer.cornerRadius = 8.0
        signUpButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 8.0
        loginButton.layer.masksToBounds = true
        spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
        spinner.alpha = 0.0
        loginButton.addSubview(spinner)
        status.isHidden = true
        status.center = loginButton.center
        view.addSubview(status)
        label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
        label.textAlignment = .center
        status.addSubview(label)
    }
    

    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
    }
    
    
    func particles() {
        //v samom nizu
        let rect = CGRect(x: 0.0, y: view.bounds.height, width: view.bounds.width, height: 50.0)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        view.layer.addSublayer(emitter)
        
        emitter.emitterShape = kCAEmitterLayerRectangle
        emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
        emitter.emitterSize = rect.size
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "snowflake1")!.cgImage
        
        emitterCell.birthRate = 50
        emitterCell.lifetime = 3.5
        emitter.emitterCells = [emitterCell]
        
        emitterCell.yAcceleration = -70.0
        emitterCell.xAcceleration = 10.0
        emitterCell.velocity = 20.0
        emitterCell.emissionLongitude = CGFloat(-M_PI)
        emitterCell.velocityRange = 200.0
        emitterCell.emissionRange = CGFloat(M_PI_2)
        emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        emitterCell.redRange   = 0.1
        emitterCell.greenRange = 0.1
        emitterCell.blueRange  = 0.1
        emitterCell.scale = 0.4
        emitterCell.scaleRange = 0.4
        emitterCell.scaleSpeed = -0.15
        emitterCell.alphaRange = 0.75
        emitterCell.alphaSpeed = -0.15
        emitterCell.lifetimeRange = 3.5
        self.particleEmitter = emitter
    }
    
    
    
    
    
}

