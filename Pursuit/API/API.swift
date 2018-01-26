import Alamofire
import SVProgressHUD
import MBProgressHUD

protocol APIHandable: Taskable {
    var service: ServiceProtocol { get }
    
    func simple(request: RequestConvertible, completion: ((_ error: ErrorProtocol?) -> Void)?) -> DataRequest?
    func perform(_ request: RequestConvertible) -> DataRequest?
    
    func isValid<T>(response: DataResponse<T>) -> Bool
    func handle<T>(response: DataResponse<T>?) -> ErrorProtocol?
    func error<T>(response: DataResponse<T>) -> ErrorProtocol?
}

extension APIHandable {
    
    func simple(request: RequestConvertible, completion: ((_ error: ErrorProtocol?) -> Void)?) -> DataRequest? {
        return self.perform(request)?.responseJSON { (response) in
            var error: ErrorProtocol?
            if let errorResponse = self.handle(response: response) {
                error = errorResponse
            }
            completion?(error)
        }
    }
    
    func perform(_ request: RequestConvertible) -> DataRequest? {
        let shouldStart = self.tasks.isEmpty
        
        var window :UIWindow = UIApplication.shared.keyWindow!
        
        if shouldStart {
            MBProgressHUD.showAdded(to: window, animated: true)
            UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
        }
        
        let task = self.addTask()
        
        if shouldStart {
            self.notify {
                
            MBProgressHUD.hide(for: window, animated: true)
                UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
            }
        }
        
        return self.service.request(request: request).validate().response { response in
            task.end()
        }
    }
    
    func error<T>(response: DataResponse<T>) -> ErrorProtocol? {
        return nil
    }
    
    func isValid<T>(response: DataResponse<T>) -> Bool {
        return 200...299 ~= (response.response?.statusCode ?? 0)
    }
    
    func handle<T>(response: DataResponse<T>?) -> ErrorProtocol? {
        var error: ErrorProtocol?
        
        if let  response = response {
            if !self.isValid(response: response) {
                if let responseError = self.error(response: response) {
                    error = responseError
                } else {
                    error = PSError.somethingWentWrong
                   
                }
            }
        } else {
            if let result = response?.result, case .failure(let serverError) = result {
                error = serverError.psError
            } else {
                error = PSError.somethingWentWrong
            }
        }
        
        if error?.description == "The Internet connection appears to be offline." {
            error = PSError.internetConnection
        }
        
        return error
    }
}
