import AuthenticationServices
import Foundation

extension ASWebAuthenticationSession {
	private final class PresentationContextProviding: NSObject,
		ASWebAuthenticationPresentationContextProviding {
		func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
			ASPresentationAnchor()
		}
	}

	@MainActor
	private static let presentationContextProviding = PresentationContextProviding()

	@MainActor
	public static func authenticate(
		url: URL,
		callbackURLScheme: String?,
		prefersEphemeralWebBrowserSession: Bool
	) async throws -> URL {
		try await withCheckedThrowingContinuation { continuation in
			let session = ASWebAuthenticationSession(
				url: url,
				callbackURLScheme: callbackURLScheme,
				completionHandler: { url, error in
					do {
						if let error {
							throw error
						}
						guard let url else {
							throw URLError(.badServerResponse)
						}
						continuation.resume(returning: url)
					} catch {
						continuation.resume(throwing: error)
					}
				}
			)

			session.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
			session.presentationContextProvider = presentationContextProviding
			session.start()
		}
	}
}
