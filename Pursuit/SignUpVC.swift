//
//  SignUpVcViewController.swift
//  Pursuit
//
//  Created by Igor on 8/2/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

//IGOR: Check
class SignUpVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var birthDayTextField    : AnimatedTextField!
    @IBOutlet weak var emailTextField       : AnimatedTextField!
    @IBOutlet weak var passwordTextField    : AnimatedTextField!
    @IBOutlet weak var nameTextField        : AnimatedTextField!
    
    @IBOutlet weak var userTypeSwitch: UISwitch!
    
    //MARK: Variables
    
    var textFieldsArray: [AnimatedTextField] {
        return [self.nameTextField, self.birthDayTextField, self.passwordTextField, self.emailTextField]
    }
    
    var personalData = User.PersonalData()
    
    //MARK: IBActions
    
    @IBAction func signUpButtonPresseed(_ sender: Any) {
        userTypeSwitch.isOn ? presentSelectTrainerVC() : registerClient()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Private
    
    private func presentSelectTrainerVC() {
        
        let rootVC = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.first
        
        let storyboard = UIStoryboard(name: Storyboards.Login, bundle: nil)
        let controller = (storyboard.instantiateViewController(withIdentifier: Controllers.Identifiers.SelectTrainer) as? UINavigationController)?.visibleViewController as? SelectTrainerVC
        
        controller?.delegate = self
        
        rootVC?.show(controller!, sender: self)
    }
}

private extension SignUpVC {
    
    func setParametersForRequest() {
        personalData.name        = nameTextField.text
        personalData.email       = emailTextField.text
        personalData.password    = passwordTextField.text
        personalData.birthday    = birthDayTextField.text
    }
    
    func registerClient(){
        setParametersForRequest()
        registerClient { error in
            if error == nil {
                //go to login
            }
        }
    }
    
    func registerTrainer() {
        setParametersForRequest()
        registerTrainer { error in
            if error == nil {
                //go to login
            }
        }
    }
    
    private func registerClient(completion: @escaping (_ error: ErrorProtocol?) -> Void) {
        User.registerClient(personalData: personalData, completion: { signUpInfo, error in
            completion(error)
        })
    }
    
    private func registerTrainer(completion: @escaping (_ error: ErrorProtocol?) -> Void) {
        User.registerTrainer(personalData: personalData, completion: { signUpInfo, error in
            completion(error)
        })
    }
}

//TODO: think after MVP together beter organizatin. Do not fix it yet.
extension SignUpVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        makeTextFieldsFirstResponder(textFieldsArray, textField)
        return true
    }
}

extension SignUpVC: SelectTrainerVCDelegate {
    func trainerSelectedWithId(_ id: Int) {
        personalData.trainerId = id
        registerTrainer()
    }
}

