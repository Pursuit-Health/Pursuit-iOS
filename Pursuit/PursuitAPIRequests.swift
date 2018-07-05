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
        
        case getInvitationCode()
        
        //MARK: Settings
        case changePassword(parameters: Parameters)
        case uploadAvatar()
        case getUserInfo()
        
        //MARK: Trainer
        case createWorkout(clientId: String, parameters: Parameters)
        case getAllTemplates()
        case getTemplateWithExercise(templateId: String)
        case editTemplate(clientId: String, templateId: String, parameters: Parameters)
        case deleteTemplate(clientId: String, templateId: String)
        case deleteTemplateExercise(clientId: String, templateId: String, exerciseId: String)
        case searchExercises(parameters: Parameters)
        case getAllClients()
        case getTrainerEvents(startDate: String, endDate: String)
        case getClientEvents(startDate: String, endDate: String)
        case createEvent(parameters: Parameters)
        case getWorkouts()
        case getWorkoutById(workoutId: String)
        case assignTemplate(clientId: String, templateId: String, parameters: Parameters)
        case submitWorkout(workoutId: String)
        
        case getClientTemplates(clientId: Int)
        case getDetailsForClient(workoutId: Int)
        case submitExcersise(workoutId: Int, excersiseId: Int)
        
        case getDetailedTemplate(clietnId: String, templateId: String)
        
        case getCategories()
        
        case getExercisesByCategoryId(categoryId: String)
        
        case getSavedTemlates(templateNamePhrase: String, page: Int)
        
        case saveSavedTemplate(parameters: Parameters)
        
        case editSavedTemplate(templateId: String, parameters: Parameters)
        
        case deleteSavedTemplate(templateId: String)
        
        case getFireBaseToken()
        
        //Payments
        
        case acceptClient(clientId: String)
        case rejectClient(clientId: String)
        case getPengingClients()
        
        //MARK: RequestConvertible
        
        var baseURLString: String {
            return PSURL.BaseURL
        }
        
        var method: HTTPMethod {
            switch self {
        case .registerClient, .registerTrainer, .login, .forgotPassword, .uploadAvatar, .setPassword, .createWorkout, .createEvent, .assignTemplate, .submitWorkout, .submitExcersise, .searchExercises, .saveSavedTemplate, .acceptClient, .rejectClient:
                return .post
            case .changePassword, .editTemplate, .editSavedTemplate:
                return .put
            case .deleteTemplate, .deleteTemplateExercise, .deleteSavedTemplate:
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
            case .createWorkout(let clietnId, _):
                return "trainer/clients/" + clietnId + "/templates"
            case .getAllTemplates:
                return "trainer/templates"
            case .getTemplateWithExercise(let templateId):
                return "trainer/templates/" + templateId
            case .editTemplate(let clientId, let templateId, _):
                return "trainer/clients/" + clientId + "/templates/" + templateId
            case .deleteTemplate(let clientId, let templateId):
                return "trainer/clients/\(clientId)/templates/\(templateId)"
            case .deleteTemplateExercise(let clientId,let templateId,let exerciseId):
                return "trainer/clients/\(clientId)/templates/\(templateId)/exercises/\(exerciseId)"
            case .searchExercises(_):
                return "trainer/exercises/search"
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
                return "trainer/clients/\(clientId)/templates"
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
                
            case .getSavedTemlates(_, _):
                return "trainer/saved-templates"
            case .saveSavedTemplate:
                return "trainer/saved-templates"
            case .editSavedTemplate(let templateId, _):
                return "trainer/saved-templates/" + templateId
            case .deleteSavedTemplate(let templateId):
                return "trainer/saved-templates/" + templateId
                
            case .getFireBaseToken():
                return "auth/firebase/token"
            case .getInvitationCode():
                return "trainer/clients/invitation-code"
            case .acceptClient(let clientId):
                return "trainer/clients/pending/\(clientId)/accept"
            case .rejectClient(let clientId):
                return "trainer/clients/pending/\(clientId)/reject"
            case .getPengingClients():
                return "trainer/clients/pending"
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
            case .getSavedTemlates(let templateNamePhrase, let page):
                return ["search" : templateNamePhrase, "page" : "\(page)"]
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
                 .createWorkout(_ , let parameters),
                 .editTemplate(_, _ , let parameters),
                 .createEvent(let parameters),
                 .assignTemplate(_ , _ , let parameters),
                 .searchExercises(let parameters),
                 .saveSavedTemplate(let parameters),
                 .editSavedTemplate(_, let parameters):
                return parameters
            default:
                return nil
            }
        }
        
        //MARK: Private
        
        private var tokenString: String {
            
            guard let token = User.shared.token else {return ""}
            
            switch self{
            case .changePassword, .uploadAvatar, .createWorkout, .deleteTemplate, .deleteTemplateExercise, . getAllTemplates, .editTemplate, .getTemplateWithExercise, .getAllClients, .getTrainerEvents, .getClientEvents, .createEvent, .refreshToken, .getWorkouts, .getWorkoutById, .assignTemplate, .submitWorkout, .getUserInfo, .getClientTemplates, .getDetailedTemplate, .getCategories, .getExercisesByCategoryId, .searchExercises, .getSavedTemlates, .getFireBaseToken, .getInvitationCode, .acceptClient, .rejectClient, .getPengingClients:
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
