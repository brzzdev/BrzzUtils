public import AuthenticationServices
public import Foundation
#if os(iOS)
import UIKit
#endif

extension ASWebAuthenticationSession {
	private final class PresentationContextProviding: NSObject,
		ASWebAuthenticationPresentationContextProviding
	{
		func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
			#if os(iOS)
			// A bare `UIWindow()` is deprecated: the anchor has to belong to a scene.
			// Presenting a session already needs a connected one.
			let scene = UIApplication.shared
				.connectedScenes
				.lazy
				.compactMap { $0 as? UIWindowScene }
				.first
			guard let scene else {
				preconditionFailure("ASWebAuthenticationSession needs a connected window scene")
			}
			return scene.keyWindow ?? ASPresentationAnchor(windowScene: scene)
			#else
			ASPresentationAnchor()
			#endif
		}
	}

	@MainActor private static let presentationContextProviding = PresentationContextProviding()

	@MainActor
	public static func authenticate(
		url: URL,
		callbackURLScheme: String?,
		prefersEphemeralWebBrowserSession: Bool,
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
				},
			)

			session.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
			session.presentationContextProvider = presentationContextProviding
			session.start()
		}
	}
}
