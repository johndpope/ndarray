
import XCTest
import NDArray

class FloatingPointFunctionsTests: XCTestCase {
    
    func testFloor() {
        do {
            let a = NDArray([[1, 1.3], [1.7, 2.2]])
            XCTAssertEqual(floor(a), NDArray([[1, 1], [1, 2]]))
        }
    }
    
    func testCeil() {
        do {
            let a = NDArray([[1, 1.3], [1.7, 2.2]])
            XCTAssertEqual(ceil(a), NDArray([[1, 2], [2, 3]]))
        }
    }
    
    func testRound() {
        do {
            let a = NDArray([[1, 1.49], [1.5, 1.51]])
            XCTAssertEqual(round(a), NDArray([[1, 1], [2, 2]]))
        }
    }
    
    func testAbs() {
        do {
            let a = NDArray([[-1, -2], [-3, 4]])
            XCTAssertEqual(abs(a), NDArray([[1, 2], [3, 4]]))
        }
    }

    func testSqrt() {
        do {
            // continuous
            let a = NDArray.range(8).reshaped([2, 2, 2])[1]
            let b = sqrt(a)
            XCTAssertEqual(b, NDArray(shape: [2, 2], elements: [4, 5, 6, 7].map(sqrtf)))
        }
        do {
            // dense, uncontinuous
            let a = NDArray.range(8).reshaped([2, 2, 2]).transposed()
            let b = sqrt(a)
            XCTAssertEqual(b, NDArray(shape: [2, 2, 2], elements: [0, 4, 2, 6, 1, 5, 3, 7].map(sqrtf)))
        }
        do {
            // not dense, least stride is 1
            let a = NDArray.range(8).reshaped([2, 2, 2])[nil, 1]
            let b = sqrt(a)
            XCTAssertEqual(b, NDArray(shape: [2, 2], elements: [2, 3, 6, 7].map(sqrtf)))
        }
        do {
            // not dense, least stride is not 1
            let a = NDArray.range(8).reshaped([2, 2, 2])[nil, nil, 1]
            let b = sqrt(a)
            XCTAssertEqual(b, NDArray(shape: [2, 2], elements: [1, 3, 5, 7].map(sqrtf)))
        }
    }
    
    

}
