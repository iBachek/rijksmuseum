import Foundation
//
public enum APIError: Error {
    case undefined
    case noInternet
    case invalidRequest
    case invalidResponse

//    init(afError: AFError) {
//        switch afError {
//        case .createUploadableFailed,
//             .createURLRequestFailed,
//             .invalidURL,
//             .multipartEncodingFailed,
//             .parameterEncodingFailed,
//             .parameterEncoderFailed,
//             .requestAdaptationFailed,
//             .requestRetryFailed,
//             .serverTrustEvaluationFailed,
//             .sessionDeinitialized,
//             .sessionInvalidated,
//             .sessionTaskFailed,
//             .urlRequestValidationFailed:
//            self = .invalidRequest
//
//        case .downloadedFileMoveFailed,
//             .explicitlyCancelled:
//            self = .undefined
//
//        case .responseValidationFailed,
//             .responseSerializationFailed:
//            self = .invalidResponse
//        }
//    }
}

