
extension NDArray {
    public init(_ array: [Float]) {
        self.init(shape: [array.count], elements: array)
    }
    
    public init(_ array: [[Float]]) {
        
        let size1 = array.count
        let size2 = array.first!.count
        precondition(array.map { $0.count == size2 }.all())
        
        self.init(shape: [size1, size2], elements: array.flatMap { $0 })
    }
    
    public init(_ array: [[[Float]]]) {
        
        let size1 = array.count
        let size2 = array.first!.count
        precondition(array.map { $0.count == size2 }.all())
        
        let flat1 = array.flatMap { $0 }
        let size3 = flat1.first!.count
        precondition(flat1.map { $0.count == size3 }.all())
        
        self.init(shape: [size1, size2], elements: flat1.flatMap { $0 })
    }
}
