//
//  UIStoryboard+Create.swift
//  Pursuit
//
//  Created by ігор on 10/26/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

protocol StoryboardIndetifiers {
    static var name: String { get }
    static var bundle: Bundle { get }
}

extension StoryboardIndetifiers {
    static var bundle: Bundle { return .main }
}

extension UIStoryboard {
    
    //MARK: Variables
    
    static var Login: LoginStoryboard {
        return LoginBuilder.create()
    }
    
    static var Trainer: TrainerStoryboard {
        return TrainerBuilder.create()
    }
    
    static var Client: ClientStoryboard {
        return ClientBuilder.create()
    }
    
    //MARK: BASE
    
    class BaseStoryboardBuilder<T> where T: StoryboardIndetifiers, T: UIStoryboard {
        class func create() -> T {
            let name = T.name
            let bundle = T.bundle
            
            return T(name: name, bundle: bundle)
        }
    }
    
    //MARK: Builders
    
    class LoginBuilder: BaseStoryboardBuilder<UIStoryboard.LoginStoryboard> {
        
    }
    
    class TrainerBuilder: BaseStoryboardBuilder<UIStoryboard.TrainerStoryboard> {
        
    }
    
    class ClientBuilder: BaseStoryboardBuilder<UIStoryboard.ClientStoryboard> {
        
    }
    
    //MARK: LoginStoryboard
    
    class LoginStoryboard: UIStoryboard, StoryboardIndetifiers {
        static var name: String {
            return "Login"
        }
        
        var MainAuth: MainAuthVC? {
            return self.instantiate(type: MainAuthVC.self)
        }
        
        var SignIn: SignInVC? {
            return self.instantiate(type: SignInVC.self)
        }
        
        var SignUp: SignUpVC? {
            return self.instantiate(type: SignUpVC.self)
        }
        
        var SelectTrainer: SelectTrainerVC?  {
            return self.instantiate(type: SelectTrainerVC.self)
        }
        
        var ResetPassword: ResetPasswordVC? {
            return self.instantiate(type: ResetPasswordVC.self)
        }
        
        var ForgotPassword: ForgotPasswordVC? {
            return self.instantiate(type: ForgotPasswordVC.self)
        }
    }
    
    //MARK: TrainerStoryboard
    
    class TrainerStoryboard: UIStoryboard, StoryboardIndetifiers {
        static var name: String {
            return "TrainerMain"
        }
        
        var Schedule: ScheduleVC? {
            return self.instantiate(type: ScheduleVC.self)
        }
        
        var TrainerTabBar: TrainerTabBarVC? {
            return self.instantiate(type: TrainerTabBarVC.self)
        }
        
        var AddExercises: AddExerceiseVC? {
            return self.instantiate(type: AddExerceiseVC.self)
        }
        
        var CreateTemplate: CreateTemplateVC? {
            return self.instantiate(type: CreateTemplateVC.self)
        }
        
        var SelectClients: SelectClientsVC? {
            return self.instantiate(type: SelectClientsVC.self)
        }
        
        var AssignTemplate: AssignTemplateVC? {
            return self.instantiate(type: AssignTemplateVC.self)
        }
        
        var ScheduleClient: ScheduleClientVC? {
            return self.instantiate(type: ScheduleClientVC.self)
        }
    }
    
    //MARK: ClientStoryboard
    
    class ClientStoryboard: UIStoryboard, StoryboardIndetifiers {
        static var name: String {
            return "ClientMain"
        }
        
        var ClientTabBar: ClientTabBarVC? {
            return self.instantiate(type: ClientTabBarVC.self)
        }
        
        var Training: TrainingVC? {
            return self.instantiate(type: TrainingVC.self)
        }
        
        
    }
    
    //MARK: Instatiate
    
    func instantiate<T: UIViewController>(type: T.Type) -> T? {
        return self.instantiateViewController(withIdentifier: String(describing: T.self)) as? T
    }
}

