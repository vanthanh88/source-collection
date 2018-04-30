import RealmSwift

class LocalDataManager {
    
    class func querySearchCommunity(completionHandler: @escaping ((Results<RCommunity>) -> Void)) {
        let topFilters = RealmStore.defaultRealm().objects(RCommunity.self)
        completionHandler(topFilters)
    }
    
    class func persistSearchCommunityFilter(_ searchFilter: RCommunity, completionHandler: @escaping ((Error?) -> Void)) {
        do {
            try RealmStore.defaultRealm().write {
                RealmStore.defaultRealm().add(searchFilter)
            }
            completionHandler(nil)
        } catch {
            completionHandler(error)
        }
    }
    
    class func deleteAllSearchCommunity(completionHandler: @escaping ((Error?) -> Void)) {
        do {
            try RealmStore.defaultRealm().write {
                self.querySearchCommunity(completionHandler: { (results) in
                    RealmStore.defaultRealm().delete(results)
                })
            }
            completionHandler(nil)
        } catch {
            completionHandler(error)
        }
    }
    
    class func querySearchCommunity(name: String, completionHandler: @escaping ((Results<RCommunity>) -> Void)) {
        let searchHistory = RealmStore.defaultRealm().objects(RCommunity.self).filter("name == %@", name)
        completionHandler(searchHistory)
    }
}
