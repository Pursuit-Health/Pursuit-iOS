import Foundation

extension Error {
    var psError: PSError {
        return PSError.custom(error: self, statusCode: nil).log()
    }
}
