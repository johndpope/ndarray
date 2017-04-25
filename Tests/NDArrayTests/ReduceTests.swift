
import XCTest
import NDArray

class ReduceTests: XCTestCase {

    func testMax() {
        do {
            let a = NDArray([[3, 2],
                             [1, 0]])
            XCTAssertEqual(max(a, along: 0), NDArray([3, 2]))
            XCTAssertEqual(max(a, along: 1), NDArray([3, 1]))
        }
    }
    
    func testArgmin() {
        do {
            let a = NDArray([[1, 2, 3],
                             [1, 3, 2],
                             [3, 1, 2]])
            XCTAssertEqual(argmin(a, along: 0), NDArray([0, 2, 1]))
            XCTAssertEqual(argmin(a, along: 1), NDArray([0, 0, 1]))
        }
    }

}