import Foundation

extension URLResponse {
	/// The HTTP status code of the response.
	/// Returns -1 if the response is not an HTTP response.
	public var httpStatusCode: Int {
		(self as? HTTPURLResponse)?.statusCode ?? -1
	}

	/// Indicates whether the response was successful based on its HTTP status code.
	/// Returns `true` if the status code is in the range 200-299, `false` otherwise.
	/// Also returns `false` if the response is not an HTTP response.
	public var isSuccessful: Bool {
		return (200 ... 299).contains(httpStatusCode)
	}
}
