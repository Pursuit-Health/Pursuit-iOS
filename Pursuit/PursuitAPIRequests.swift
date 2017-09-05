import Alamofire

//TODO: Maybe separate to different requests classes
extension PSAPI {
    
    enum Request: URLRequestConvertible {
        
        typealias Query = [String : String?]
        
        //MARK: Auth
        case registerTrainer(parameters: Parameters)
        case registerClient(parameters: Parameters)
        case login(parameters: Parameters)
        case forgotPassword(parameters: Parameters)
        
        //MARK: Settings
        case changePassword(parameters: Parameters)
        case uploadAvatar()
        
        
        
        //MARK: Private.Property
        
        private var baseURLString: String {
            return "http://dev.nerdzlab.com/v1/"
        }
        
        private var method: HTTPMethod {
            switch self {
            case .registerClient, .registerTrainer, .login, .forgotPassword, .uploadAvatar:
                return .post
            case .changePassword:
                return .put
            }
        }
        
        private var path: String {
            switch self {
            case .registerTrainer:
                return "auth/register/trainer"
            case .registerClient:
                return "auth/register/client"
            case .login:
                return "auth/login"
            case .forgotPassword:
                return "auth/forgot-password"
            
            case .changePassword:
                return "settings/password"
            case .uploadAvatar:
                return "settings/avatar"
            }
        }
        
        private var tokenString: String {
            
        guard let token = User.token else {return ""}
            switch self{
            case .changePassword, .uploadAvatar:
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
        
        private var queryParams: Query? {
            return nil
        }
        
        //MARK: Private.Methods
        
        private func addHeadersForRequest( request: inout URLRequest, signed signature: String?) {
            request.setValue(self.contentType, forHTTPHeaderField: "Content-Type")
            request.setValue(self.tokenString, forHTTPHeaderField: "Authorization")
        }
        
        private func addParametersAndHeadersForRequest(request: URLRequest) throws -> URLRequest {
            var request     = request
            
            switch self {
            case .registerClient(let parameters):
                request = try JSONEncoding.default.encode(request, with: parameters)
                
            case .registerTrainer(let parameters):
                request = try JSONEncoding.default.encode(request, with: parameters)
                
            case .login(let parameters):
                request = try JSONEncoding.default.encode(request, with: parameters)
                
            case .forgotPassword(let parameters):
                request = try JSONEncoding.default.encode(request, with: parameters)
                
            case .changePassword(let parameters):
                request = try JSONEncoding.default.encode(request, with: parameters)
                
            case .uploadAvatar():
                request = try URLEncoding.default.encode(request, with: [:])
                
            default: break
            }
            self.addHeadersForRequest(request: &request, signed: nil)
            return request
        }
        
        private func addQueryParams(url: URL) -> URL {
            var url = url
            if let queryParams = self.queryParams, let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) {
                var urlComponents = urlComponents
                var queryItems = [URLQueryItem]()
                for (name, value) in queryParams {
                    if let value = value {
                        queryItems.append(URLQueryItem(name: name, value: value))
                    }
                }
                
                urlComponents.queryItems = queryItems
                if let urlFromComponents = urlComponents.url, queryItems.count > 0 {
                    url = urlFromComponents
                }
            }
            
            return url
        }
        
        // MARK: URLRequestConvertible
        
        func asURLRequest() throws -> URLRequest {
            var url = try self.baseURLString.appending(self.path).asURL()
            url = self.addQueryParams(url: url)
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = self.method.rawValue
            urlRequest = try self.addParametersAndHeadersForRequest(request: urlRequest)
            
            return urlRequest
        }
    }
}

extension Dictionary where Key == String {
    func signed(secret: String) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self), let json = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return json.hmac(algorithm: .sha1, key: secret)
    }
}

private extension String {
    
    enum CryptoAlgorithm {
        case md5, sha1, sha224, sha256, sha384, sha512
        
        var HMACAlgorithm: CCHmacAlgorithm {
            var result: Int = 0
            switch self {
            case .md5:      result = kCCHmacAlgMD5
            case .sha1:     result = kCCHmacAlgSHA1
            case .sha224:   result = kCCHmacAlgSHA224
            case .sha256:   result = kCCHmacAlgSHA256
            case .sha384:   result = kCCHmacAlgSHA384
            case .sha512:   result = kCCHmacAlgSHA512
            }
            return CCHmacAlgorithm(result)
        }
        
        var digestLength: Int {
            var result: Int32 = 0
            switch self {
            case .md5:      result = CC_MD5_DIGEST_LENGTH
            case .sha1:     result = CC_SHA1_DIGEST_LENGTH
            case .sha224:   result = CC_SHA224_DIGEST_LENGTH
            case .sha256:   result = CC_SHA256_DIGEST_LENGTH
            case .sha384:   result = CC_SHA384_DIGEST_LENGTH
            case .sha512:   result = CC_SHA512_DIGEST_LENGTH
            }
            return Int(result)
        }
    }
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str         = self.cString(using: String.Encoding.utf8)
        let strLen      = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen   = algorithm.digestLength
        let result      = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr      = key.cString(using: String.Encoding.utf8)
        let keyLen      = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        
        let digest = stringFromResult(result: result, length: digestLen)
        
        result.deallocate(capacity: digestLen)
        
        return digest
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
}
