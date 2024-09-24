import BrzzUtils
import Combine
import Testing

@Suite
struct CancelBagTests {
	@Test
	func cancelAll() {
		let cancelBag = CancelBag()

		var isCancelled1 = false
		var isCancelled2 = false
		var isCancelled3 = false

		let cancellable1 = AnyCancellable { isCancelled1 = true }
		let cancellable2 = AnyCancellable { isCancelled2 = true }
		let cancellable3 = AnyCancellable { isCancelled3 = true }

		cancellable1.store(in: cancelBag)
		cancellable2.store(in: cancelBag)
		cancellable3.store(in: cancelBag)

		#expect(!isCancelled1)
		#expect(!isCancelled2)
		#expect(!isCancelled3)

		cancelBag.cancelAll()

		#expect(isCancelled1)
		#expect(isCancelled2)
		#expect(isCancelled3)

		#expect(cancelBag.isEmpty)
	}

	@Test
	func cancellablesBuilder() {
		let cancelBag = CancelBag()

		var isCancelled1 = false
		var isCancelled2 = false

		let cancellable1 = AnyCancellable { isCancelled1 = true }
		let cancellable2 = AnyCancellable { isCancelled2 = true }

		cancelBag.store {
			cancellable1
			cancellable2
		}

		#expect(cancelBag.count == 2)

		#expect(!isCancelled1)
		#expect(!isCancelled2)

		cancelBag.cancelAll()

		#expect(isCancelled1)
		#expect(isCancelled2)

		#expect(cancelBag.isEmpty)
	}
}
