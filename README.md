# DI - Dependency Injection Container
DI is a simple dependency injection container for Swift. It allows you to register services and retrieve them later, helping to decouple the different components of your codebase.

## Installation
You can install DI using the Swift Package Manager. Just add the following line to your Package.swift file:

```swift
.package(url: "https://github.com/bordunosp/DI.git", from: "1.0.1")
```

## Usage
### Registering services

To register a service, create a DIServiceItem object containing a closure that initializes the service. The closure should return an instance of the service as AnyObject.

```swift
DI.register([
    DIServiceItem(
        isSingleton: true,
        serviceName: "ILogger",
        serviceInitFunc: {
            return Logger()
        }
    )
])
```

If the service should be a singleton (i.e. there should only be one instance of it), set the isSingleton parameter to true. Otherwise, set it to false.

## Retrieving services

To retrieve a service, call the get function with the type of the service you want to retrieve. If there are multiple services of that type registered, the first one that was registered will be returned.

```swift 
let logger: ILogger = try DI.get(ILogger.self)
```

If you want to retrieve a specific service by name, call the get function with both the type and the name of the service.

```swift
let logger: ILogger = try DI.get(ILogger.self, "ILogger")
```

If no service of the given type or name is registered, a DIError will be thrown.

## Error handling
The following errors can be thrown when using DI:

- DIError.serviceNotRegistered: The requested service is not registered.
- DIError.serviceHasIncorrectType: The requested service cannot be cast to the requested type.
- DIError.serviceAlreadyRegistered: A service with the same name is already registered.

## Example

```swift
// Define a protocol for your service
protocol MyServiceProtocol {
    func doSomething()
}

// Implement the protocol
class MyService: MyServiceProtocol {
    func doSomething() {
        print("Did something")
    }
}

DI.register([
    DIServiceItem(
        isSingleton: true,
        serviceName: "MyService",
        serviceInitFunc: { MyService() }
    )
])

// Use the service
let myServiceInstance: MyServiceProtocol = try DI.get(MyServiceProtocol.self)
myServiceInstance.doSomething()
```