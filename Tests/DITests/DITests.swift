import XCTest
@testable import DI

class MyTestService {
    func val() -> String {
        return "value string"
    }
}

final class diTests: XCTestCase {

    func testSingleton() throws {
        class Foo {
            func val() -> String {
                "value string"
            }
        }

        try DI.addSingleton {
            return Foo()
        }

        let foo1: Foo = try DI.resolve()
        let foo2: Foo = try DI.resolve()
        XCTAssertTrue(foo1 === foo2)
    }

    func testNotSingleton() throws {
        class Foo2 {
            func val() -> String {
                "value string"
            }
        }

        try DI.add("Foo2", {
            return Foo2()
        })

        let foo1: Foo2 = try DI.resolve("Foo2")
        let foo2: Foo2 = try DI.resolve("Foo2")
        XCTAssertTrue(foo1 !== foo2)
    }

    func testDIServiceInitFunc() throws {
        try DI.add("MyService_InitFunc", {
            return MyTestService()
        })

        let retrievedService1: MyTestService = try DI.resolve("MyService_InitFunc")
        let retrievedService2: MyTestService = try DI.resolve("MyService_InitFunc")

        XCTAssertTrue(retrievedService1.val() == "value string")
        XCTAssertTrue(retrievedService2.val() == "value string")
        XCTAssertFalse(retrievedService1 === retrievedService2)
    }

    func testRegisterSingleService() throws {
        try DI.addSingleton ("MyService_Single", {
            return MyTestService()
        })

        let service: MyTestService = try DI.resolve("MyService_Single")
        XCTAssertTrue(service.val() == "value string")
    }

    func testRegisterNonSingletonService() throws {
        try DI.addSingleton ("MyService1_NonSingleton", {
            return MyTestService()
        })
        try DI.addSingleton ("MyService2_NonSingleton", {
            return MyTestService()
        })
        
        let returnedServiceValue1: MyTestService = try DI.resolve("MyService1_NonSingleton")
        let returnedServiceValue1_2: MyTestService = try DI.resolve("MyService1_NonSingleton")
        let returnedServiceValue2: MyTestService = try DI.resolve("MyService2_NonSingleton")

        XCTAssertEqual(returnedServiceValue1.val(), returnedServiceValue2.val())
        XCTAssertFalse(returnedServiceValue1 === returnedServiceValue2)

        XCTAssertEqual(returnedServiceValue1_2.val(), returnedServiceValue1_2.val())
        XCTAssertTrue(returnedServiceValue1_2 === returnedServiceValue1_2)
    }

    func testRegisteringDuplicateService() throws {
        
        try DI.addSingleton("MyService_Duplicate", {
            return MyTestService()
        })

        XCTAssertThrowsError(try DI.addSingleton("MyService_Duplicate", {
            return MyTestService()
        })) { error in
            XCTAssertEqual(error as? DIError, DIError.serviceAlreadyRegistered)
        }
    }

    func testNotRegistered() throws {
        XCTAssertThrowsError(try DI.resolve() as XCTestCase) { error in
            XCTAssertEqual(error as? DIError, DIError.serviceNotRegistered)
        }
    }

    func testNotRegisteredByName() throws {
        XCTAssertThrowsError(try DI.resolve("NotRegistered") as MyTestService) { error in
            XCTAssertEqual(error as? DIError, DIError.serviceNotRegistered)
        }
    }
}
