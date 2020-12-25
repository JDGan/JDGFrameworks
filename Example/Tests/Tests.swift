import XCTest
import JDGFrameworks

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTryFindPath () {
        let fm = FileManager.default
        guard let path = Bundle.main.resourcePath, let children = fm.enumerator(atPath: path) else {return}
        print(Locale.preferredLanguages)
        guard let prefer = Locale.preferredLanguages.first else {
            return
        }
        print("--------------------")
        for dir in children {
            if let subPath = dir as? String,
               subPath ~== "^[^/]+\\.lproj$",
               let name = subPath.components(separatedBy: ".").first {
                let s = name.similarityWithAnother(prefer)
                print(name+"<>"+prefer+"=",s)
            }
        }
    }
    
    func testRegex () {
        let source = "abbbbbbbc"
        let pattern = "^ab"
        XCTAssertTrue(source ~== pattern)
        print((source ~~> pattern).stringResults)
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        let p = JDGProjectConfiguration.default
        p.log
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            let changing = NSLocalizedString("Requesting", tableName: "Demo", value: "1+1=%d", comment: "this is a test")
            let r = String.localizedStringWithFormat(changing, (1+1))
            XCTAssertEqual(r, "")
        }
    }
    
}
