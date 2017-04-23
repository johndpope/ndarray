
import XCTest
import NDArray

class IrisClassificationTests: XCTestCase {

    func testLogisticRegression() {
        
        // TODO: Not completed yet
        
        let x = Iris.x_train
        let y = toOneHot(Iris.y_train)
        
        let numFeatures = x.shape[1]
        let numOutput = y.shape[1]
        
        // Two layer neural network
        
        let numHiddenUnits1 = 5
        
        var W1 = NDArray.normal(mu: 0, sigma: 0.2, shape: [numFeatures, numHiddenUnits1])
        var b1 = NDArray.zeros([numHiddenUnits1])
        
        var W2 = NDArray.normal(mu: 0, sigma: 0.2, shape: [numHiddenUnits1, numOutput])
        var b2 = NDArray.zeros([numOutput])
        
        for i in 0..<1 {
            let h1 = sigmoid(x <*> W1 + b1)
            let h2 = sigmoid(h1 <*> W2 + b2)
            let out = softmax(h2)
            let losses = -y * log(max(y - out, 1e-10))
            let loss = mean(losses)
            
            print(losses)
        }
    }

}

func sigmoid(_ x: NDArray) -> NDArray {
    return 1 / (1 + exp(-x))
}

func softmax(_ x: NDArray) -> NDArray {
    var ret: [NDArray] = []

    for i in 0..<x.shape[0] {
        let row = exp(x[i])
        ret.append(row / sum(row))
    }
    
    return NDArray.stack(ret)
}

func toOneHot(_ y: NDArray) -> NDArray {
    precondition(y.ndim == 1)
    
    let size = Int(max(y).asScalar()) + 1
    
    var ret: [NDArray] = []
    
    for i in y.elements() {
        var vector = NDArray.zeros([size])
        vector[Int(i)] = NDArray(scalar: 1)
        ret.append(vector)
    }
    
    return NDArray.stack(ret)
}
