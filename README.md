# DI - Dependency Injection Container
DI is a simple dependency injection container for Swift. It allows you to register services and retrieve them later, helping to decouple the different components of your codebase.

## Installation
You can install DI using the Swift Package Manager. Just add the following line to your Package.swift file:

```swift
.package(url: "https://github.com/bordunosp/DI.git", from: "2.0.1")
```

## Usage
### Registering services


```swift
protocol IAnimal {
    func sayHi()
}

public struct CatService: IAnimal {
    func sayHi() {
        print("meow")
    }
}

public struct DogService: IAnimal {
    func sayHi() {
        print("wow wow")
    }
}


// register transient service
try DI.add({ CatService() })

// register transient service with name attribute
try DI.add("Some Uniq Name for multiple services per one Type", { CatService() })

// register transient service by Interface (protocol)
try DI.add(IAnimal.self, { CatService() })

// register transient service by Interface (protocol) with name attribute
try DI.add(IAnimal.self, "Some Uniq Name for multiple services per one Type", { 
    return CatService() 
})


// register singleton service
try DI.addSingleton({ DogService() })

// register singleton service with name attribute
try DI.addSingleton("Some Uniq Name", { DogService() })

// register singleton service by Interface (protocol)
try DI.addSingleton(IAnimal.self, { CatService() })

// register singleton service by Interface (protocol) with name attribute
try DI.addSingleton(IAnimal.self, "Some Uniq Name for multiple services per one Type", { 
    return CatService() 
})
```

## Retrieving services

To retrieve a service, call the get function with the type of the service you want to retrieve. If there are multiple services of that type registered, the first one that was registered will be returned.

```swift 
let cat: CatService = try DI.resolve()
```

If you want to retrieve a specific service by name, call the get function with both the type and the name of the service.

```swift
let cat: CatService = try DI.resolve("Some Uniq Name for multiple services per one Type")
```

If no service of the given type or name is registered, a DIError will be thrown.

## Error handling
The following errors can be thrown when using DI:

- DIError.serviceNotRegistered: The requested service is not registered.
- DIError.serviceHasIncorrectType: The requested service cannot be cast to the requested type.
- DIError.serviceAlreadyRegistered: A service with the same name is already registered.

## Example
Magic rosolver by "DiResolve" attribute


```swift
import DI

class SomeClass {
    public func doSome() {
        print("SomeClass")
    }
}


class SomeOtherClass {
    @DiResolve()
    public var someClass: SomeClass
}

try DI.add({ SomeClass() })
try DI.add({ SomeOtherClass() })

var service: SomeOtherClass = try DI.resolve()

service.someClass.doSome()
```


---

# #StandForUkraine 🇺🇦

This project aims to show support for Ukraine and its people amidst a war that has been ongoing since 2014. This war has a genocidal nature and has led to the deaths of thousands, injuries to millions, and significant property damage. We believe that the international community should focus on supporting Ukraine and ensuring security and freedom for its people.

Join us and show your support using the hashtag #StandForUkraine. Together, we can help bring attention to the issues faced by Ukraine and provide aid.

