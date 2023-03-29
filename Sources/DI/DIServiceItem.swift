import Foundation


public struct DIServiceItem {
    public let isSingleton: Bool
    public let serviceName: String
    public let serviceInitFunc: DIServiceInitFunc

    public init(isSingleton: Bool, serviceName: String, serviceInitFunc: @escaping DIServiceInitFunc) {
        self.isSingleton = isSingleton
        self.serviceName = serviceName
        self.serviceInitFunc = serviceInitFunc
    }
}

