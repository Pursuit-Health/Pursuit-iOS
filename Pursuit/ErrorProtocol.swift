
protocol ErrorProtocol: Error {
    var statusCode: Int { get }
    var description: String { get }
    
    func log() -> PSError
    //func alert(action: ((JHTAlertAction) -> Void)?) -> JHTAlertController
    func alert(action: UIAlertAction) -> UIAlertController
}
