import Alamofire

//TODO: Maybe separate to different requests classes
extension PSAPI {
    
    enum Request: RequestConvertible {
        
        //MARK: Auth
        case refreshToken()
        case registerTrainer(parameters: Parameters)
        case registerClient(parameters: Parameters)
        case login(parameters: Parameters)
        case forgotPassword(parameters: Parameters)
        case setPassword(parameters: Parameters)
        case getTrainers()
        
        //MARK: Settings
        case changePassword(parameters: Parameters)
        case uploadAvatar()
        case getUserInfo()
        
        //MARK: Trainer
        case createTemplate(parameters: Parameters)
        case getAllTemplates()
        case getTemplateWithExercise(templateId: String)
        case editTemplate(templateId: String, parameters: Parameters)
        case deleteTemplate(templateId: String, parameters: Parameters)
        case getAllClients()
        case getTrainerEvents(startDate: String, endDate: String)
        case getClientEvents(startDate: String, endDate: String)
        case createEvent(parameters: Parameters)
        case getWorkouts()
        case getWorkoutById(workoutId: String)
        case assignTemplate(clientId: String, templateId: String, parameters: Parameters)
        case submitWorkout(workoutId: String)
        
        case getClientTemplates(clientId: String)
        case getDetailsForClient(workoutId: Int)
        case submitExcersise(workoutId: Int, excersiseId: Int)
        
        case getDetailedTemplate(clietnId: String, templateId: String)
        
        case getCategories()
        
        case getExercisesByCategoryId(categoryId: String)
        
        //MARK: RequestConvertible
        
        var baseURLString: String {
            //return "https://pursuithealthtech.com/v1/"
            return "https://dev.nerdzlab.com/v1/"
        }
        
        var method: HTTPMethod {
            switch self {
            case .registerClient, .registerTrainer, .login, .forgotPassword, .uploadAvatar, .setPassword, .createTemplate, .createEvent, .assignTemplate, .submitWorkout, .submitExcersise:
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
            case .refreshToken:
                return "auth/refresh"
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
            case .getUserInfo:
                return "settings/info"
                
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
            case .getTrainerEvents:
                return "trainer/events"
            case .getClientEvents:
                return "client/events"
            case .createEvent:
                return "trainer/events"
            case .getWorkouts:
                return "client/templates"
            case .getWorkoutById(let workoutId):
                return "client/workouts/" + workoutId
            case .assignTemplate(let clientId, let templateId, _):
                return "trainer/clients/" + clientId + "/assign/" + templateId
            case .submitWorkout(let workoutId):
                return "client/workouts/" + workoutId + "/submit"
                
            case .getClientTemplates(let clientId):
                return "trainer/clients/" + clientId + "/templates"
            case .getDetailsForClient(let workoutId):
                return "client/templates/\(workoutId)"
            case .submitExcersise(let workoutId, let excersiseId):
                return "client/templates/\(workoutId)/exercises/\(excersiseId)/submit"
                
            case .getDetailedTemplate(let clietnId, let templateId):
                return "trainer/clients/" +  clietnId + "/templates/" + templateId
            case .getCategories:
                return "trainer/categories"
            case .getExercisesByCategoryId(let categoryId):
                return "trainer/categories/" + categoryId + "/exercises"
                
            }
        }
        
        var headers: Headers? {
            return ["Content-Type"  : self.contentType,
                    "Authorization" : self.tokenString]
        }
        
        var queryParams: Query? {
            switch self {
            case .getTrainerEvents(let startDate, let endDate):
                return ["start_date":startDate, "end_date": endDate]
            case .getClientEvents(let startDate, let endDate):
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
                 .createEvent(let parameters),
                 .assignTemplate(_ , _ , let parameters):
                return parameters
            default:
                return nil
            }
        }
        
        //MARK: Private
        
        private var tokenString: String {
            
            guard let token = User.shared.token else {return ""}
            
            switch self{
            case .changePassword, .uploadAvatar, .createTemplate, .deleteTemplate, . getAllTemplates, .editTemplate, .getTemplateWithExercise, .getAllClients, .getTrainerEvents, .getClientEvents, .createEvent, .refreshToken, .getWorkouts, .getWorkoutById, .assignTemplate, .submitWorkout, .getUserInfo, .getClientTemplates, .getDetailedTemplate, .getCategories, .getExercisesByCategoryId:
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
