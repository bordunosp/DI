import Foundation


public enum DIError: Error {
    case serviceNotRegistered
    case serviceHasIncorrectType
    case serviceAlreadyRegistered
}
