import Foundation

public protocol BySykkelViewModelDelegate: class {
    func didLoad()
    func didFail(with error: Error)
}

public class BySykkelViewModel {
    let api: BySykkelAPI
    weak var delegate: BySykkelViewModelDelegate?
    var stations: [Station]?

    public init(api: BySykkelAPI) {
        self.api = api
    }

    func viewDidLoad() {
        api.getStations { [weak self] (result) in
            switch result {
            case .success(var stations):
                self?.api.getAvailability { [weak self] (result) in
                    switch result {
                    case .success(let stationAvailability):
                        stationAvailability.forEach {
                            stations[$0.id]?.availability = $0.availability
                        }

                        self?.stations = stations
                            .compactMap { $1 }
                            .sorted(by: {$0.id < $1.id})

                        self?.delegate?.didLoad()
                    case .failure(let error):
                        self?.delegate?.didFail(with: error)
                    }
                }

            case .failure(let error):
                self?.delegate?.didFail(with: error)
            }
        }
    }
}
