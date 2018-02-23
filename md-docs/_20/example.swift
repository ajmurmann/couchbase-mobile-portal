// Get the database (and create it if it doesn’t exist).
let database: Database
do {
    database = try Database(name: "mydb")
} catch {
    fatalError("Error opening database")
}

// Create a new document (i.e. a record) in the database.
let mutableDoc = MutableDocument()
    .setFloat(2.0, forKey: "version")
    .setString("SDK", forKey: "type")

// Save it to the database.
var document: Document
do {
    document = try database.saveDocument(mutableDoc)
} catch {
    fatalError("Error saving document")
}

// Update a document.
if let mutableDoc = database.document(withID: document.id)?.toMutable() {
    mutableDoc.setString("Swift", forKey: "language")
    do {
        document = try database.saveDocument(mutableDoc)

        // Log the document ID (generated by the database)
        // and properties
        print("Document ID :: \(document.id)")
        print("Learning \(document.string(forKey: "language"))")
    } catch {
        fatalError("Error updating document")
    }
}

// Create a query to fetch documents of type SDK.
let query = QueryBuilder
    .select(SelectResult.all())
    .from(DataSource.database(database))
    .where(Expression.property("type").equalTo(Expression.string("SDK")))

// Run the query.
do {
    let result = try query.execute()
    print("Number of rows :: \(result.allResults().count)")
} catch {
    fatalError("Error running the query")
}

// Create replicators to push and pull changes to and from the cloud.
let targetEndpoint = URLEndpoint(url: URL(string: "ws://localhost:4984/example_sg_db")!)
let replConfig = ReplicatorConfiguration(database: database, target: targetEndpoint)
replConfig.replicatorType = .pushAndPull

// Add authentication.
replConfig.authenticator = BasicAuthenticator(username: "john", password: "pass")

// Create replication.
replication = Replicator(config: replConfig)

// Listen to database change events.
replication?.addChangeListener { (change) in
    if let error = change.status.error as NSError? {
        print("Error code :: \(error.code)")
    }
}

// Start replication.
replication?.start()
