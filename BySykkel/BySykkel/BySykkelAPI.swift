import Foundation

public class BySykkelAPI {
    let session: URLSession
    let baseURL = URL(string: "https://oslobysykkel.no/api/v1/")

    public init(token: String, session: URLSession? = nil) {
        if let session = session {
            self.session = session
        } else {
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = ["Client-Identifier": token]
            config.timeoutIntervalForRequest = 5
            self.session = URLSession(configuration: config)
        }
    }

    public func getStations(callback: @escaping (Result<[Int: Station]>) -> Void) {
        request(path: "stations") { (result: Result<Stations>) in
            switch result {
            case .success(let item):
                let stationsDict = item.stations.reduce(into: [Int: Station](), { (dict, station) in
                    dict[station.id] = station
                })
                callback(.success(stationsDict))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    public func getAvailability(callback: @escaping (Result<[StationAvailability]>) -> Void) {
        request(path: "stations/availability") { (result: Result<StationsAvailability>) in
            switch result {
            case .success(let item):
                callback(.success(item.stations))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    private func request<T: Decodable>(path: String, callback: @escaping (Result<T>) -> Void) {
        let url = URL(string: path, relativeTo: baseURL)!
        let request = URLRequest(url: url)

        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                callback(.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                callback(.failure(BySykkelError.networkError(nil)))
                return
            }

            guard let data = data, response.statusCode == 200 else {
                callback(.failure(BySykkelError.networkError(response.statusCode)))
                return
            }
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                callback(.success(object))
            } catch {
                callback(.failure(error))
            }
        }.resume()
    }
}
