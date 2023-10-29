import Foundation

// File private variable to be returned containing the JSON data
fileprivate var jsonDataFromApi = Data()

public func FlightDataFromApi(passengers: Int, distance: Int, type: String, completion: @escaping (_ result: [String: Any]?, _ error: Error?) -> Void) {
    let MY_API_KEY = "SBX5EFZAN0MEDNPD0NB78DQRBTAN"
    let url = URL(string: "https://beta3.api.climatiq.io/estimate")!
    let activity_id = type
    let parameters: [String: Any] = [
        "passengers": passengers,
        "distance": distance,
        "distance_unit": "mi"
    ]
    let jsonBody: [String: Any] = [
        "emission_factor": [
            "activity_id": activity_id
        ],
        "parameters": parameters
    ]
    
    // Create a URLRequest object
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer: \(MY_API_KEY)", forHTTPHeaderField: "Authorization")
    request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody)
    
    // Create a semaphore to control fetching API data in an Asynchronous Manner.
    let semaphore = DispatchSemaphore(value: 0)
    
    // Send the HTTP request and retrieve the response
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
        // Check for errors
        guard error == nil else {
            completion(nil, error)
            semaphore.signal()
            return
        }
        
        // Check for HTTP response status codes
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            completion(nil, NSError(domain: "Invalid response status code", code: 0, userInfo: nil))
            semaphore.signal()
            return
        }
        
        // Deserialize the response JSON data
        guard let responseData = data,
              let responseJson = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
            completion(nil, NSError(domain: "Unable to deserialize response data", code: 0, userInfo: nil))
            semaphore.signal()
            return
        }
        
        // Store the JSON data to the file private variable
        jsonDataFromApi = responseData
        
        // Return the response JSON data to the completion handler
        completion(responseJson, nil)
        
        // Release the semaphore after completion of the task
        semaphore.signal()
    }
    task.resume()
    
    // Wait for the HTTP request to finish before returning the JSON data
    semaphore.wait()
}

