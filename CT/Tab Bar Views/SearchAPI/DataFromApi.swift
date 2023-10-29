import Foundation

func DataFromApi(kwhours: Int, region: String, completion: @escaping (_ result: [String: Any]?, _ error: Error?) -> Void) {
    
    let MY_API_KEY = "SBX5EFZAN0MEDNPD0NB78DQRBTAN"
    let url = URL(string: "https://beta3.api.climatiq.io/estimate")!
    let activity_id = "electricity-energy_source_grid_mix"
    let parameters: [String: Any] = [
        "energy": kwhours,
        "energy_unit": "kWh"
    ]
    let jsonBody: [String: Any] = [
        "emission_factor": [
            "activity_id": activity_id,
            "region": region
        ],
        "parameters": parameters
    ]
    
    let semaphore = DispatchSemaphore(value: 0)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer: \(MY_API_KEY)", forHTTPHeaderField: "Authorization")
    request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        defer { semaphore.signal() }
        
        guard error == nil else {
            completion(nil, error)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            completion(nil, NSError(domain: "Invalid response status code", code: 0, userInfo: nil))
            return
        }
        
        guard let responseData = data,
              let responseJson = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
            completion(nil, NSError(domain: "Unable to deserialize response data", code: 0, userInfo: nil))
            return
        }
        
        completion(responseJson, nil)
    }
    
    task.resume()
    
    semaphore.wait()
}
