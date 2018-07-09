//
//  UIStoryboard+Create.swift
//  Pursuit
//
//  Created by ігор on 10/26/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

fileprivate var cache: [String : UIStoryboard] = [:]
fileprivate class BaseStoryboardBuilder<T> where T: UIStoryboard {
    
    class func create() -> T {
        let name    = T.name
        if let storyboard = cache[name] as? T {
            return storyboard
        }
        let bundle      = T.bundle
        let storyboard  = T(name: name, bundle: bundle)
        cache[name]     = storyboard
        
        return storyboard
    }
}

fileprivate extension UIStoryboard {
    static var name: String {
        return String(describing: self)
    }
    static var bundle: Bundle {
        return .main
    }
}

extension UIStoryboard {
    
    //MARK: Variables
    
    static var login: Login {
        return BaseStoryboardBuilder<UIStoryboard.Login>.create()
    }
    
    static var trainer: TrainerMain {
        return BaseStoryboardBuilder<UIStoryboard.TrainerMain>.create()
    }
    
    static var client: ClientMain {
        return BaseStoryboardBuilder<UIStoryboard.ClientMain>.create()
    }
    
    static var sideMenu: Settings {
        return BaseStoryboardBuilder<UIStoryboard.Settings>.create()
    }
    
    //MARK: LoginStoryboard
    
    class Login: UIStoryboard {
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
        
        var preloadNavigation: PreloadNavigation? {
            return self.instantiate(type: PreloadNavigation.self)
        }
    }
    
    //MARK: TrainerStoryboard
    
    class TrainerMain: UIStoryboard {
        var Schedule: ScheduleVC? {
            return self.instantiate(type: ScheduleVC.self)
        }
        
        var TrainerTabBar: TrainerTabBarVC? {
            return self.instantiate(type: TrainerTabBarVC.self)
        }
        
        var AddExercises: AddExerceiseVC? {
            return self.instantiate(type: AddExerceiseVC.self)
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
        
        var ClientInfo: ClientInfoVC? {
            return self.instantiate(type: ClientInfoVC.self)
        }
        
        var ExerciseCategory: ExerciseCategoryVC? {
            return self.instantiate(type: ExerciseCategoryVC.self)
        }
        
        var MainExercises: MainExercisesVC? {
            return self.instantiate(type: MainExercisesVC.self)
        }
        
        var ExercisesSearch: ExercisesSearchVC? {
            return self.instantiate(type: ExercisesSearchVC.self)
        }
        
        var ExerciseDetails: ExerciseDetailsVC? {
            return self.instantiate(type: ExerciseDetailsVC.self)
        }
        var TrainerClients: ClientsVC? {
            return self.instantiate(type: ClientsVC.self)
        }
        var SavedTemplatesList: SavedTemplatesVC? {
            return self.instantiate(type: SavedTemplatesVC.self)
        }
        var SavedTemplate: SavedTemplateVC? {
            return self.instantiate(type: SavedTemplateVC.self)
        }
        var CreateNewTemplate: CreateNewTemplateVC? {
            return self.instantiate(type: CreateNewTemplateVC.self)
        }
        var ChatsList: ChatsListVC? {
            return self.instantiate(type: ChatsListVC.self)
        }
        
        var Chat: ChatVC? {
            return self.instantiate(type: ChatVC.self)
        }
        
        var ContainerChat: ContainerChatVC? {
            return self.instantiate(type: ContainerChatVC.self)
        }
        
        var ClientsRequests: ClientsRequestsVC? {
            return self.instantiate(type: ClientsRequestsVC.self)
        }
        
        var SubscriptionPlans: SubscriptionPlansVC? {
            return self.instantiate(type: SubscriptionPlansVC.self)
        }
    }
    
    //MARK: ClientStoryboard
    
    class ClientMain: UIStoryboard {
        var ClientTabBar: ClientTabBarVC? {
            return self.instantiate(type: ClientTabBarVC.self)
        }
        
        var Training: TrainingVC? {
            return self.instantiate(type: TrainingVC.self)
        }
        
        var PaymentStatus: PaymentStatusVC? {
            return self.instantiate(type: PaymentStatusVC.self)
        }
    }
    
    //MARK: SideMenuStoryboard
    
    class Settings: UIStoryboard {
        var SideMenuNavigation: SWRevealViewController? {
            return self.instantiate(type: SWRevealViewController.self)
        }
    }
    
    //MARK: Instatiate
    
    fileprivate func instantiate<T: UIViewController>(type: T.Type) -> T? {
        return self.instantiateViewController(withIdentifier: String(describing: T.self)) as? T
    }
}

