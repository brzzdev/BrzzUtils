import IdentifiedCollections

extension IdentifiedArray {
	@inlinable
	public subscript(id id: ID?) -> Element? {
		guard let id else { return nil }

		return self[id: id]
	}
}
