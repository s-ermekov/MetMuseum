//
//  Decodable.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 05.03.2023.
//

import Foundation

struct SearchResult: Decodable {
    var total: Int
    var objectIDs: [Int]?
}

struct Object: Decodable {
    var objectID              : Int?
//    var isHighlight           : Bool?
    var accessionNumber       : String?
    var accessionYear         : String?
//    var isPublicDomain        : Bool?
    var primaryImage          : String?
    var primaryImageSmall     : String?
//    var additionalImages      : [String?]
    //  var constituents          : [Constituents]
    var department            : String?
    var objectName            : String?
    var title                 : String?
//    var culture               : String?
//    var period                : String?
//    var dynasty               : String?
//    var reign                 : String?
//    var portfolio             : String?
    var artistRole            : String?
//    var artistPrefix          : String?
    var artistDisplayName     : String?
    var artistDisplayBio      : String?
//    var artistSuffix          : String?
    var artistAlphaSort       : String?
    var artistNationality     : String?
    var artistBeginDate       : String?
    var artistEndDate         : String?
//    var artistGender          : String?
//    var artistWikidata_URL     : String?
//    var artistULAN_URL         : String?
    var objectDate            : String?
    var objectBeginDate       : Int?
    var objectEndDate         : Int?
    var medium                : String?
    var dimensions            : String?
    //  var measurements          : [Measurements]
    var creditLine            : String?
//    var geographyType         : String?
//    var city                  : String?
//    var state                 : String?
//    var county                : String?
//    var country               : String?
//    var region                : String?
//    var subregion             : String?
//    var locale                : String?
//    var locus                 : String?
//    var excavation            : String?
//    var river                 : String?
    var classification        : String?
//    var rightsAndReproduction : String?
//    var linkResource          : String?
//    var metadataDate          : String?
    var repository            : String?
    var objectURL             : String?
    //  var tags                  : [Tags]
//    var objectWikidataURL     : String?
//    var isTimelineWork        : Bool?
//    var GalleryNumber         : String?
}
