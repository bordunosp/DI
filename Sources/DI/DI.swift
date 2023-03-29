import Foundation

public struct DI {
    private static let _servicesLock = NSLock()
    private static var _services = [String: Any]()

    /**
    Registers an array of services with the dependency injection container.

    - Parameter services: An array of `DIServiceItem` objects representing the services to register.
    - Throws: An error of type `DIError` if a service with the same name is already registered.
    */
    public static func register(_ services: [DIServiceItem]) throws {
        _servicesLock.lock()
        defer { _servicesLock.unlock() }

        for service in services {
            guard _services[service.serviceName] == nil else {
                throw DIError.serviceAlreadyRegistered
            }

            if service.isSingleton {
                _services[service.serviceName] = try service.serviceInitFunc()
            } else {
                _services[service.serviceName] = service.serviceInitFunc
            }
        }
    }

    /**
     - Parameter type: The type of the service to be returned.
     - Returns: The first registered service of type `T`.
     - Throws: A `DIError` if no service of the given type is registered.
     */
    public static func get<T>(_ type: T.Type) throws -> T {
        guard let service = _services.values.first(where: { $0 is T }) as? T else {
            throw DIError.serviceNotRegistered
        }
        return service
    }

    /**
     - Parameters:
       - type: The type of the service to be returned.
       - serviceName: The unique name of the service.
     - Returns: The requested service of type `T`.
     - Throws: A `DIError` if the service is not registered or if it cannot be cast to the requested type.
    */
    public static func get<T>(_ type: T.Type, _ serviceName: String) throws -> T {
        guard let service = _services[serviceName] else {
            throw DIError.serviceNotRegistered
        }

        if let diInitFunc = service as? DIServiceInitFunc {
            guard let convertibleType = try diInitFunc() as? T else {
                throw DIError.serviceHasIncorrectType
            }
            return convertibleType
        }

        guard let convertibleType = service as? T else {
            throw DIError.serviceHasIncorrectType
        }

        return convertibleType
    }
}
