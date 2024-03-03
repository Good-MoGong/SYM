
import Foundation
import CoreData


final class CoreDataManger {
    
    static let shared = CoreDataManger()
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    /// CoreData 초기설정
    private init() {
        container = NSPersistentContainer(name: "SYMCoreData")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("코어데이터 로딩 중 에러 발생 \(error.localizedDescription)")
            } else {
                print("코어데이터 로딩 성공! \(description)")
            }
        }

        context = container.viewContext
        // 기존에 저장되어있던 항목에 병합할건지 여부.
        context.automaticallyMergesChangesFromParent = true
    }
    
    /// 새로운 쓰기, 수정, 삭제등을 백그라운드 스레드에서 동작시킬때 사용할 context
    func newContextForBackgroundThread() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    // MARK: - CRUD Methods
    /// 여러 Entity의 내용을 한번에 등록할 경우.
    @discardableResult func create(contextValue: NSManagedObjectContext? = nil,
                newEntityDataHandler: () -> Void) -> Bool {
        print("📝 CoreDataManager create")
        var context: NSManagedObjectContext
        if let contextValue {
            context = contextValue
        } else {
            context = self.context
        }
        newEntityDataHandler()
        
        return self.save(context: context)
    }
            
    /// 데이터 조회 (조건가능 <한컬럼>)
    func retrieve<Entity, Value>(type: Entity.Type,
                                 sortkey: WritableKeyPath<Entity, String>? = nil,
                                 sortAsc: Bool = true,
                                 column: WritableKeyPath<Entity, Value>? = nil,
                                 comparision: CoreDataManger.Comparisons = .equal,
                                 value: Value? = nil) -> [Entity] where Entity: NSManagedObject {
        print("📝 CoreDataManager Retrieve")
        let request = NSFetchRequest<Entity>(entityName: "\(type.self)")
        // 조건이 있는 경우.
        if let column, let value {
            let predicateFormat = "%K \(comparision.rawValue) %@"
            let predicate = NSPredicate(format: predicateFormat, column.toKeyName, "\(value)")
            request.predicate = predicate
        }
        // 현재는 이렇게 조회된 NSMangedObject를 직접 쓰는게 아니기때문에 Sort를 줘도 의미가 없음.
        if let sortkey = sortkey {
              let sortDesription = NSSortDescriptor(key: sortkey.toKeyName, ascending: sortAsc)
              request.sortDescriptors = [sortDesription]
              print("Sort Key: \(sortkey.toKeyName)")
          }
        
        do {
            let results = try self.context.fetch(request)
            return results
        } catch {
            print("\(error.localizedDescription)☹️")
        }

        return []
    }
    
    /// 데이터 조회 (전체조회)
    func retrieve<Entity>(type: Entity.Type,
                          sortkey: WritableKeyPath<Entity, String>? = nil,
                          sortAsc: Bool = true) -> [Entity] where Entity: NSManagedObject {
        print("📝CoreDataManager Retrieve")
        let request = NSFetchRequest<Entity>(entityName: "\(type.self)")
        let sortDesription = NSSortDescriptor(key: sortkey?.toKeyName, ascending: sortAsc)
        
        request.sortDescriptors?.append(sortDesription)
        
        do {
            let results = try self.context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    /// 수정
    /// clouser에 entity.setValue("변경할 데이터", forKey: "컬럼명") 의 형식으로 작성.!!
    @discardableResult func update<Entity, Value>(type: Entity.Type,
                               column: WritableKeyPath<Entity, Value>,
                               value: Value,
                               contextValue: NSManagedObjectContext? = nil,
                               newEntityDataHandler: () -> Void) -> Bool where Entity: NSManagedObject {
        print("📝 CoreDataManager Update")
        var context: NSManagedObjectContext
        if let contextValue {
            context = contextValue
        } else {
            context = self.context
        }
        
        let isResult = self.delete(type: type, column: column, value: value)
        guard isResult else { return false }
        newEntityDataHandler()

        return self.save(context: context)
    }

    /// 해당 데이터만 삭제
    @discardableResult func delete<Entity, Value>(type: Entity.Type,
                               column: WritableKeyPath<Entity, Value>,
                               value: Value,
                               contextValue: NSManagedObjectContext? = nil) -> Bool where Entity: NSManagedObject {
        print("📝 CoreDataManager Delete")
        var context: NSManagedObjectContext
        if let contextValue {
            context = contextValue
        } else {
            context = self.context
        }
        
        let deleteDatas = self.retrieve(type: type, column: column, comparision: .equal, value: value)
        guard !deleteDatas.isEmpty else { return false }
        
        deleteDatas.forEach { context.delete($0) }

        return self.save(context: context)
    }
    
    /// 해당 타입 전체삭제.
    @discardableResult func deleteAll<Entity>(type: Entity.Type,
                           contextValue: NSManagedObjectContext? = nil) -> Bool where Entity: NSManagedObject {
        print("📝 CoreDataManager DeleteAll")
        var context: NSManagedObjectContext
        if let contextValue {
            context = contextValue
        } else {
            context = self.context
        }
        
        let allDatas = self.retrieve(type: type)
        allDatas.forEach { context.delete($0) }

        return self.save(context: context)
    }
    
}

extension CoreDataManger {
    private func save(context: NSManagedObjectContext) -> Bool {
        guard context.hasChanges
        else {
            print("📝 코어데이터 변경사항 없음.")
            return false
        }
        
        do {
            try context.save()
            print("📝 코어데이터 저장 성공 !!")
            return true
        } catch {
            print("📝 코어데이터 변경사항 저장 실패! \(error.localizedDescription)")
            return false
        }
        
    }
    
    enum Comparisons: String {
        case equal = "=="          // ==
        case lessThan = "<"       // <
        case overThan = ">"      // >
        case lessOrEqual = "<="   // <=
        case overOrEqual = ">="   // >=
        case notEqual = "!="      // !=
    }
}
