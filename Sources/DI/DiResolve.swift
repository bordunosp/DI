
@propertyWrapper
public struct DiResolve<T> {
    private var service: T?
    private let name: String

    public init(name: String = "") {
        self.name = name
    }

    public var wrappedValue: T {
        mutating get {
            if let service = self.service {
                return service
            }

            do {
                let service: T = try DI.resolve(name)
                self.service = service
                return self.service!
            } catch {
                fatalError("Failed to resolve dependency for \(T.self). \(error)")
            }
        }
    }
}
