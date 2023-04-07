import XCTest
@testable import DI

class MyTestService {
    func val() -> String {
        "value string"
    }
}

final class diTests: XCTestCase {

    func testSingleton() throws {
        class Foo {
            func val() -> String {
                "value string"
            }
        }

        try DI.register([
            DIServiceItem(isSingleton: true, serviceName: "Foo", serviceInitFunc: { Foo() })
        ])

        let foo1: Foo = try DI.get()
        let foo2: Foo = try DI.get()
        XCTAssertTrue(foo1 === foo2)
    }

    func testNotSingleton() throws {
        class Foo2 {
            func val() -> String {
                "value string"
            }
        }

        try DI.register([
            DIServiceItem(isSingleton: false, serviceName: "Foo2", serviceInitFunc: { Foo2() })
        ])

        let foo1: Foo2 = try DI.get("Foo2")
        let foo2: Foo2 = try DI.get("Foo2")
        XCTAssertTrue(foo1 !== foo2)
    }

    func testDIServiceInitFunc() throws {
        try DI.register([
            DIServiceItem(isSingleton: false, serviceName: "MyService_InitFunc", serviceInitFunc: { MyTestService() })
        ])

        let retrievedService1: MyTestService = try DI.get("MyService_InitFunc")
        let retrievedService2: MyTestService = try DI.get("MyService_InitFunc")

        XCTAssertTrue(retrievedService1.val() == "value string")
        XCTAssertTrue(retrievedService2.val() == "value string")
        XCTAssertFalse(retrievedService1 === retrievedService2)
    }

    func testDIServiceInitFuncIncorrectType() throws {
        try DI.register([
            DIServiceItem(isSingleton: false, serviceName: "MyService_InitFunc_IncorrectType", serviceInitFunc: { MyTestService() })
        ])

        XCTAssertThrowsError(try DI.get("MyService_InitFunc_IncorrectType") as XCTestCase) { error in
            XCTAssertEqual(error as? DIError, DIError.serviceHasIncorrectType)
        }
    }

    func testRegisterSingleService() throws {
        try DI.register([
            DIServiceItem(isSingleton: true, serviceName: "MyService_Single", serviceInitFunc: { MyTestService() })
        ])

        let retrievedService: MyTestService = try DI.get()
        XCTAssertTrue(retrievedService.val() == "value string")
    }

    func testRegisterNonSingletonService() throws {
        try DI.register([
            DIServiceItem(isSingleton: true, serviceName: "MyService1_NonSingleton", serviceInitFunc: { MyTestService() }),
            DIServiceItem(isSingleton: true, serviceName: "MyService2_NonSingleton", serviceInitFunc: { MyTestService() }),
        ])

        let returnedServiceValue1: MyTestService = try DI.get("MyService1_NonSingleton")
        let returnedServiceValue1_2: MyTestService = try DI.get("MyService1_NonSingleton")
        let returnedServiceValue2: MyTestService = try DI.get("MyService2_NonSingleton")

        XCTAssertEqual(returnedServiceValue1.val(), returnedServiceValue2.val())
        XCTAssertFalse(returnedServiceValue1 === returnedServiceValue2)

        XCTAssertEqual(returnedServiceValue1_2.val(), returnedServiceValue1_2.val())
        XCTAssertTrue(returnedServiceValue1_2 === returnedServiceValue1_2)
    }

    func testRegisteringDuplicateService() throws {
        let serviceItem = DIServiceItem(isSingleton: true, serviceName: "MyService_Duplicate", serviceInitFunc: { MyTestService() })

        XCTAssertThrowsError(try DI.register([serviceItem, serviceItem])) { error in
            XCTAssertEqual(error as? DIError, DIError.serviceAlreadyRegistered)
        }
    }

    func testRegisteringIncorrectServiceType() throws {
        try DI.register([
            DIServiceItem(isSingleton: true, serviceName: "MyService1_IncorrectType", serviceInitFunc: { MyTestService() }),
        ])

        XCTAssertThrowsError(try DI.get("MyService1_IncorrectType") as XCTestCase) { error in
            XCTAssertEqual(error as? DIError, DIError.serviceHasIncorrectType)
        }
    }


    func testNotRegistered() throws {
        XCTAssertThrowsError(try DI.get() as XCTestCase) { error in
            XCTAssertEqual(error as? DIError, DIError.serviceNotRegistered)
        }
    }

    func testNotRegisteredByName() throws {
        XCTAssertThrowsError(try DI.get("NotRegistered") as MyTestService) { error in
            XCTAssertEqual(error as? DIError, DIError.serviceNotRegistered)
        }
    }
}
