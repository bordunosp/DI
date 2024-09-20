import Foundation

public struct DI {
    nonisolated(unsafe) private static var _services = [String: Any]()

    public static func addSingleton<T>(_ interface: T.Type, _ initFunc: @escaping DIServiceInitFunc<T>) throws {
        try addSingleton(interface, "", initFunc)
    }

    public static func addSingleton<T>(
        _ interface: T.Type, _ name: String = "", _ initFunc: @escaping DIServiceInitFunc<T>
    ) throws {
        let objectIdentifier = ObjectIdentifier(T.self)
        var hasher = Hasher()

        objectIdentifier.hash(into: &hasher)

        let key = String(hasher.finalize()) + name

        guard _services[key] == nil else {
            throw DIError.serviceAlreadyRegistered
        }

        _services[key] = try initFunc()
    }

    public static func addSingleton<T>(_ initFunc: @escaping DIServiceInitFunc<T>) throws {
        try addSingleton("", initFunc)
    }

    public static func addSingleton<T>(
        _ name: String = "", _ initFunc: @escaping DIServiceInitFunc<T>
    ) throws {
        let objectIdentifier = ObjectIdentifier(T.self)
        var hasher = Hasher()

        objectIdentifier.hash(into: &hasher)

        let key = String(hasher.finalize()) + name

        guard _services[key] == nil else {
            throw DIError.serviceAlreadyRegistered
        }

        _services[key] = try initFunc()
    }

    public static func add<T>(_ initFunc: @escaping DIServiceInitFunc<T>) throws {
        try add("", initFunc)
    }

    public static func add<T>(_ interface: T.Type, _ initFunc: @escaping DIServiceInitFunc<T>) throws {
        try add(interface, "", initFunc)
    }

    public static func add<T>(_ interface: T.Type, _ name: String, _ initFunc: @escaping DIServiceInitFunc<T>) throws {
        let objectIdentifier = ObjectIdentifier(T.self)
        var hasher = Hasher()

        objectIdentifier.hash(into: &hasher)

        let key = String(hasher.finalize()) + name

        guard _services[key] == nil else {
            throw DIError.serviceAlreadyRegistered
        }

        _services[key] = initFunc
    }

    
    public static func add<T>(_ name: String = "", _ initFunc: @escaping DIServiceInitFunc<T>)
        throws
    {
        let objectIdentifier = ObjectIdentifier(T.self)
        var hasher = Hasher()

        objectIdentifier.hash(into: &hasher)

        let key = String(hasher.finalize()) + name

        guard _services[key] == nil else {
            throw DIError.serviceAlreadyRegistered
        }

        _services[key] = initFunc
    }

    public static func resolve<T>(_ name: String = "") throws -> T {
        let objectIdentifier = ObjectIdentifier(T.self)
        var hasher = Hasher()

        objectIdentifier.hash(into: &hasher)

        let key = String(hasher.finalize()) + name

        guard let service = _services[key] else {
            throw DIError.serviceNotRegistered
        }

        if let factory = service as? DIServiceInitFunc<T> {
            return try factory()
        }

        guard let convertibleType = service as? T else {
            throw DIError.serviceHasIncorrectType
        }

        return convertibleType
    }
}
