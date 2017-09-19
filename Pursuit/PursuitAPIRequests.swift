import Alamofire

//TODO: Maybe separate to different requests classes
extension PSAPI {
    
    enum Request: RequestConvertible {
        
        //MARK: Auth
        case registerTrainer(parameters: Parameters)
        case registerClient(parameters: Parameters)
        case login(parameters: Parameters)
        case forgotPassword(parameters: Parameters)
        case setPassword(parameters: Parameters)
        case getTrainers()
        
        //MARK: Settings
        case changePassword(parameters: Parameters)
        case uploadAvatar()
        
        //MARK: Trainer
        case createTemplate(parameters: Parameters)
        case getAllTemplates()
        case getTemplateWithExercise(templateId: String)
        case editTemplate(templateId: String, parameters: Parameters)
        case deleteTemplate(templateId: String, parameters: Parameters)
        case getAllClients()
        case getAllEventsInRange(startDate: String, endDate: String)
        case createEvent(parameters: Parameters)
        
        //MARK: RequestConvertible
        
        var baseURLString: String {
            return "http://dev.nerdzlab.com/v1/"
        }
        
        var method: HTTPMethod {
            switch self {
            case .registerClient, .registerTrainer, .login, .forgotPassword, .uploadAvatar, .setPassword, .createTemplate, .createEvent:
                return .post
            case .changePassword, .editTemplate:
                return .put
            case .deleteTemplate:
                return .delete
            default:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .registerTrainer:
                return "auth/register/trainer"
            case .registerClient:
                return "auth/register/client"
            case .login:
                return "auth/login"
            case .forgotPassword:
                return "auth/forgot-password"
            case .setPassword:
                return "auth/set-password"
            case .getTrainers:
                return "auth/register/trainers"
                
            case .changePassword:
                return "settings/password"
            case .uploadAvatar:
                return "settings/avatar"
                
            //Template
            case .createTemplate:
                return "trainer/templates"
            case .getAllTemplates:
                return "trainer/templates"
            case .getTemplateWithExercise(let templateId):
                return "trainer/templates/" + templateId
            case .editTemplate(let templateId, _):
                return "trainer/templates/" + templateId
            case .deleteTemplate(let templateId, _):
                return "trainer/templates/" + templateId
            case .getAllClients:
                return "trainer/clients"
            case .getAllEventsInRange:
                return "trainer/events"
            case .createEvent:
                return "trainer/events"
            }
        }
        
        var headers: Headers? {
            return ["Content-Type"  : self.contentType,
                    "Authorization" : self.tokenString]
        }
        
        var queryParams: Query? {
            switch self {
            case .getAllEventsInRange(let startDate, let endDate):
                return ["start_date":startDate, "end_date": endDate]
            default:
                return nil
            }
        }
        
        var parameters: Parameters? {
            switch self {
            case .registerClient(let parameters),
                 .registerTrainer(let parameters),
                 .login(let parameters),
                 .forgotPassword(let parameters),
                 .setPassword(let parameters),
                 .changePassword(let parameters),
                 .createTemplate(let parameters),
                 .editTemplate(_ , let parameters),
                 .deleteTemplate(_ , let parameters),
                 .createEvent(let parameters):
                return parameters
            default:
                return nil
            }
        }
        
        //MARK: Private
        
        private var tokenString: String {
            
            guard let token = User.token else {return ""}
            
            switch self{
            case .changePassword, .uploadAvatar, .createTemplate, .deleteTemplate, . getAllTemplates, .editTemplate, .getTemplateWithExercise, .getAllClients, .getAllEventsInRange, .createEvent:
                return "Bearer" + token
            default:
                return ""
            }
        }
        
        private var contentType: String {
            switch self {
            case .uploadAvatar:
                return ""
            default:
                return "application/json"
            }
        }
    }
}
