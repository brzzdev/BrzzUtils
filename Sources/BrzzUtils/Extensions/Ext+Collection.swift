import Foundation

extension Collection {
	public var isNotEmpty: Bool {
		!isEmpty
	}
}

extension Collection where Index == Int {
	public subscript(safe index: Index) -> Element? {
		validIndex(index, count: count) ? self[index] : nil
	}
}

extension MutableCollection where Index == Int {
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

func validIndex(_ index: Int, count: Int) -> Bool {
	index >= 0 && index < count
}
