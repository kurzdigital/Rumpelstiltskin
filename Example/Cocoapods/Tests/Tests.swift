
import Rumpelstiltskin
import XCTest

let testData = """
"ErrorMessages.EmptyCredentials" = "Fields empty. Please fill out all required fields.";
"ErrorMessages.WrongCredentials" = "Wrong credentials. Please try again.";
"""

let expectedResult = """
// This code was generated by Rumpelstiltskin
// Do not modify anything by hand and run the main.swift skript instead

import Foundation

struct Localizations {
struct ErrorMessages {
/// Base translation: Fields empty. Please fill out all required fields.
public static let EmptyCredentials = NSLocalizedString("ErrorMessages.EmptyCredentials", tableName: nil, bundle: Bundle.main, value: "", comment: "")
/// Base translation: Wrong credentials. Please try again.
public static let WrongCredentials = NSLocalizedString("ErrorMessages.WrongCredentials", tableName: nil, bundle: Bundle.main, value: "", comment: "")
}

}
"""

let complicatedTestData = """
// This is a comment
/// This is also a comment
"ErrorMessages.EmptyCredentials" = "Fields empty. Please fill out all required fields.";


/* This comment should be ignore */
/** This aswell **/
/* Multiline should be no

problem aswell */
"ErrorMessages.WrongCredentials" = "Wrong credentials %d. Please try again %@.";
"""

let expectedResultComplicatedData = """
// This code was generated by Rumpelstiltskin
// Do not modify anything by hand and run the main.swift skript instead

import Foundation

struct Localizations {
struct ErrorMessages {
/// Base translation: Fields empty. Please fill out all required fields.
public static let EmptyCredentials = NSLocalizedString("ErrorMessages.EmptyCredentials", tableName: nil, bundle: Bundle.main, value: "", comment: "")
/// Base translation: Wrong credentials %d. Please try again %@.
public static func WrongCredentials(value1: Int, _ value2: String) -> String {
return String(format: NSLocalizedString("ErrorMessages.WrongCredentials", tableName: nil, bundle: Bundle.main, value: "", comment: "")
, value1, value2)
}
}

}
"""

class TableOfContentsSpec: XCTestCase {
    func testSwiftCodeGen() {
        let structure = Rumpelstiltskin.extractStructure(from: testData)
        let code = structure.swiftCode()
        XCTAssertEqual(
            code.trimmingCharacters(in: .whitespacesAndNewlines),
            expectedResult.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    func testSwiftCodeGenComplicated() {
        let structure = Rumpelstiltskin.extractStructure(from: complicatedTestData)
        let code = structure.swiftCode()
        XCTAssertEqual(
            code.trimmingCharacters(in: .whitespacesAndNewlines),
            expectedResultComplicatedData.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    func testIfFunctionParsingApplies() {
       XCTAssertTrue(Rumpelstiltskin.functionValueBuilder.applies(to: "Hallo %d"))
    }

    func testGenerationFromFile() throws {
        guard let strings =
            Bundle(for: type(of: self)).path(forResource: "Strings", ofType: "txt") else {
                fatalError("Error initializing test")
        }

        let fileUrl = URL(fileURLWithPath: strings)
        let fileContent = try Data(contentsOf: fileUrl)
        let fileContentAsString = String(data: fileContent, encoding: .utf8)!
        let result = Rumpelstiltskin.extractStructure(from: fileContentAsString)
        let code = result.swiftCode()
        let indentedCode = Indentation(indentationType: .spaces(tabSize: 4)).indent(code)
    }
}