# libraries
import getpass
import pymongo
from random import randint

CONNECTION_STRING = getpass.getpass(
    prompt="Enter connection string available in networking tab of cosmos account: "
)

#print("Using " + CONNECTION_STRING + "to connect with MongoDB")

DATABASE = "thinknyx"
COLLECTION = "thinknyx"
FIELD = "Day"

def create_database_unsharded_collection(client):
    """Create sample database with shared throughput if it doesn't exist and
    an unsharded collection
    """
    db = client[DATABASE]

    # Create database if it doesn't exist
    if DATABASE not in client.list_database_names():
        # Database with 400 RU throughput that can be shared across the
        # DB's collections
        db.command({"customAction": "CreateDatabase", "offerThroughput": 400})
        print("Created db {} with shared throughput".format(DATABASE))

    # Create collection if it doesn't exist
    if COLLECTION not in db.list_collection_names():
        # Creates a unsharded collection that uses the DBs shared throughput
        db.command(
            {
                "customAction": "CreateCollection",
                "collection": COLLECTION,
            }
        )
        print("Created collection {}".format(COLLECTION))

    return db[COLLECTION]

def main():
    """Connect to the API for MongoDB, create DB and collection, perform
    CRUD operations
    """
    client = pymongo.MongoClient(CONNECTION_STRING)
    try:
        client.server_info()  # validate connection string
    except pymongo.errors.ServerSelectionTimeoutError:
        raise TimeoutError(
            "Invalid API for MongoDB connection string \
                or timed out when attempting to connect"
        )

    collection = create_database_unsharded_collection(client)


if __name__ == "__main__":
    main()
