import Foundation

extension Collection {
	/// A Boolean value indicating whether the collection contains any elements.
	///
	/// This is the inverse of `isEmpty` and can make code more readable in certain contexts.
	///
	/// ```swift
	/// let array = [1, 2, 3]
	/// if array.isNotEmpty {
	///     print("Array has elements")
	/// }
	/// ```
	public var isNotEmpty: Bool {
		!isEmpty
	}
}

extension Collection where Index == Int {
	/// Safely accesses the element at the specified position.
	///
	/// Unlike the default subscript, this subscript returns `nil` if the index is out of bounds
	/// instead of triggering a runtime error.
	///
	/// - Parameter index: The position of the element to access. `index` must be greater than or
	///   equal to zero and less than the number of elements in the collection.
	/// - Returns: The element at the specified index if it exists, or `nil` if the index is out of bounds.
	///
	/// ```swift
	/// let numbers = [1, 2, 3]
	/// print(numbers[safe: 1])    // Optional(2)
	/// print(numbers[safe: 10])   // nil
	/// ```
	public subscript(safe index: Index) -> Element? {
		validIndex(index, count: count) ? self[index] : nil
	}
	
	/// Returns a new array with the element inserted at the end
	public func appending(_ element: Element) -> [Element] {
		self + [element]
	}
	
	/// Returns a new array with the element inserted at the beginning
	public func prepending(_ element: Element) -> [Element] {
		[element] + self
	}
	
	/// Returns a new array with elements inserted at the end
	public func appending(contentsOf elements: [Element]) -> [Element] {
		self + elements
	}
	
	/// Returns a new array with elements inserted at the beginning
	public func prepending(contentsOf elements: [Element]) -> [Element] {
		elements + self
	}
}

extension MutableCollection where Index == Int {
	/// Safely accesses or modifies the element at the specified position.
	///
	/// This subscript provides both read and write access to elements while ensuring
	/// operations are safe even with out-of-bounds indices.
	///
	/// - Parameter index: The position of the element to access. `index` must be greater than or
	///   equal to zero and less than the number of elements in the collection.
	/// - Returns: The element at the specified index if it exists, or `nil` if the index is out of bounds.
	///
	/// ```swift
	/// var numbers = [1, 2, 3]
	/// numbers[safe: 1] = 5      // [1, 5, 3]
	/// numbers[safe: 10] = 7     // No effect, still [1, 5, 3]
	/// ```
	public subscript(safe index: Index) -> Element? {
		get {
			validIndex(index, count: count) ? self[index] : nil
		}
		
		set {
			if let newValue, validIndex(index, count: count) {
				self[index] = newValue
			}
		}
	}
}

/// Checks if the given index is valid for a collection of the specified count.
///
/// - Parameters:
///   - index: The index to validate.
///   - count: The number of elements in the collection.
/// - Returns: `true` if the index is within bounds (0..<count), `false` otherwise.
///
/// ```swift
/// let isValid = validIndex(2, count: 5)  // true
/// let isInvalid = validIndex(10, count: 5)  // false
/// ```
private func validIndex(_ index: Int, count: Int) -> Bool {
	index >= 0 && index < count
}
