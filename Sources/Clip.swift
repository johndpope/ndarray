
import Accelerate

extension NDArray {
    /// Clip lower values.
    public func clip(low: Float) -> NDArray {
        return apply(self, low, vDSP_vmax)
    }
    
    /// Clip higher values.
    public func clip(high: Float) -> NDArray {
        return apply(self, high, vDSP_vmin)
    }
    
    /// Clip lower and higher values.
    public func clip(low: Float, high: Float) -> NDArray {
        return self.clip(low: low).clip(high: high)
    }
}


private typealias vDSP_func = (UnsafePointer<Float>, vDSP_Stride, UnsafePointer<Float>, vDSP_Stride, UnsafeMutablePointer<Float>, vDSP_Stride, vDSP_Length) -> Void

private func apply(_ array: NDArray, _ scalar: Float, _ vDSPfunc: vDSP_func) -> NDArray {
    
    var scalar = scalar
    
    if isDense(shape: array.shape, strides: array.strides) {
        let src = UnsafePointer(array.data) + array.baseOffset
        let dst = UnsafeMutablePointer<Float>.allocate(capacity: array.data.count)
        defer { dst.deallocate(capacity: array.data.count) }
        vDSPfunc(src, 1, &scalar, 0, dst, 1, vDSP_Length(array.data.count))
        return NDArray(shape: array.shape,
                       strides: array.strides,
                       baseOffset: 0,
                       data: [Float](UnsafeBufferPointer(start: dst, count: array.data.count)))
    } else {
        // Separate scattered major shape and strided minor shape
        let volume = array.volume
        let minorDims = stridedDims(shape: array.shape, strides: array.strides)
        let majorShape = [Int](array.shape.dropLast(minorDims))
        let majorStrides = [Int](array.strides.dropLast(minorDims))
        
        let stride = array.strides.last!
        let blockSize = array.shape.suffix(minorDims).prod()
        
        let dst = UnsafeMutablePointer<Float>.allocate(capacity: volume)
        defer { dst.deallocate(capacity: volume) }
        
        let offsets = getOffsets(shape: majorShape, strides: majorStrides)
        let _blockSize = vDSP_Length(blockSize)
        
        let src = UnsafePointer(array.data) + array.baseOffset
        var dstPtr = dst
        for offset in offsets {
            let src = src + offset
            
            vDSPfunc(src, stride, &scalar, 0, dstPtr, 1, _blockSize)
            dstPtr += blockSize
        }
        
        return NDArray(shape: array.shape,
                       elements: [Float](UnsafeBufferPointer(start: dst, count: volume)))
    }
}
