import Kitura
import Cocoa

let router = Router()

router.all("/ClaimsService/add", middleware: BodyParser())

router.get("/"){
    request, response, next in
    response.send("Hello! Welcome to visit the service. ")
    next()
}


router.get("ClaimsService/getAll"){
    request, response, next in
    let claimList = ClaimsFunctions().getAll()
    let jsonData : Data = try JSONEncoder().encode(claimList)
    let jsonStr = String(data: jsonData, encoding: .utf8)
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    next()
}

router.post("ClaimsService/add") {
    request, response, next in
    let body = request.body
    let jObj = body?.asJSON
    if let jDict = jObj as? [String:String] {
        if let id = jDict["ID"],let title = jDict["Title"],let date = jDict["Date"],let solved = Bool(jDict["isSolved"]!) {
            let cObj = Claim(i:id, t:title, d:date, s:solved)
            ClaimsFunctions().addClaim(cObj: cObj)
        }
    }
    response.send("The Claim was successfully inserted.")
    next()
}

Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()

