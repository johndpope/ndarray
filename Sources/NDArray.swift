public struct NDArray {
    /// Shape of NDArray.
    public internal(set) var shape: [Int]
    /// Source of elements.
    var data: NDArrayData
    
    /// Strides for each dimensions.
    public internal(set) var strides: [Int]
    /// Base offset of data.
    public internal(set) var baseOffset: Int
    
    init(shape:[Int], strides: [Int], baseOffset: Int, data: NDArrayData) {
        assert(shape.count == strides.count)
        assert(shape.all { $0 >= 0 })
        assert(0 <= baseOffset && (baseOffset < data.count || data.isEmpty))
        self.shape = shape
        self.strides = strides
        self.data = data
        self.baseOffset = baseOffset
    }
    
    init(shape: [Int], elements: NDArrayData) {
        self.init(shape: shape,
                  strides: getContiguousStrides(shape: shape),
                  baseOffset: 0,
                  data: elements)
    }
    
    /// Init with contiguous strides.
    public init(shape: [Int], elements: [Float]) {
        precondition(shape.all { $0 >= 0 }, "Shape(\(shape)) contains minus value.")
        precondition(shape.prod() == elements.count, "Elements count must correspond to product of shape.")
        
        self.init(shape: shape,
                  elements: NDArrayData(elements))
    }
    
    /// Get all elements.
    public func elements() -> [Float] {
        return gatherElements(self).asArray()
    }
    
    /// Get single element.
    public func element(at ndIndex: [Int]) -> Float {
        precondition(ndIndex.count == strides.count, "Invalid index for single element.")
        let ndIndex = normalizeIndex(shape: shape, ndIndex: ndIndex)
        let index = getIndexOffset(strides: strides, ndIndex: ndIndex) + baseOffset
        return data[index]
    }
    
    /// Number of dimensions.
    public var ndim: Int {
        return shape.count
    }
    
    /// NDArray's volume.
    /// - Returns: Number of elements
    public var volume: Int {
        return shape.prod()
    }
    
    public func asContiguousArray() -> NDArray {
        return NDArray(shape: shape, elements: elements())
    }
}

extension NDArray: Equatable {
    
}

public func ==(lhs: NDArray, rhs: NDArray) -> Bool {
    guard lhs.shape == rhs.shape else {
        return false
    }
    let lhs = gatherElements(lhs)
    let rhs = gatherElements(rhs)
    
    var lp = lhs.pointer
    var rp = rhs.pointer
    for _ in 0..<lhs.count {
        guard lp.pointee == rp.pointee else {
            return false
        }
        lp += 1
        rp += 1
    }
    return true
}
