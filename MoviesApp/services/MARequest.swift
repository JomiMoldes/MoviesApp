//
// Created by MIGUEL MOLDES on 19/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//
import Foundation
import Alamofire

class MARequest : MARequestProtocol {

    var body : Data!
    var path : String = ""
    var timeout : Int = 0
    var method : HTTPMethod = .get
    var params = [String:String]()

    init(requestType:HTTPMethod, path: String) {
        self.method = requestType
        self.path = path
        
    }

    var request: URLRequest? {
        get {
            do {
                let request = try URLRequest(url: URL(fileURLWithPath: self.path), method: self.method)
                return request
            }catch {

            }
            return nil
        }
    }
}


protocol MARequestProtocol {

    var request : URLRequest? {get}

    var path : String {get}
    var method : HTTPMethod {get}

}

protocol MAResponseProtocol {


}
