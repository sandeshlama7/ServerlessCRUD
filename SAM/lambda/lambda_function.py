import sys
import pymysql
import json
import os
import boto3

def get_secret():
    secret_name = "rds!db-77922a37-c730-4eea-a8e6-32630ba8b138"
    region_name = "us-east-1"

    # Create a Secrets Manager client
    client = boto3.client('secretsmanager', region_name=region_name)

    # Retrieve the secret value
    response = client.get_secret_value(SecretId=secret_name)
    # Decrypts secret using the associated KMS key
    if 'SecretString' in response:
        secret = response['SecretString']
    else:
        secret = base64.b64decode(response['SecretBinary'])

    # Parse the secret JSON string and return the password
    secret_dict = json.loads(secret)
    return secret_dict['password']

# rds settings
user_name = os.environ['USERNAME']
rds_proxy_host = os.environ['RDS_PROXY_HOST']
db_name = os.environ['DB_NAME']
password = get_secret()
print(password)

# create the database connection outside of the handler to allow connections to be
# re-used by subsequent function invocations.
# try:
#     conn1 = pymysql.connect(host=rds_proxy_host, user=user_name, passwd=password, connect_timeout=10)
# except pymysql.MySQLError as e:
#     logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
#     logger.error(e)
#     sys.exit(1)

# with conn1.cursor() as cur:
#     cur.execute(f"CREATE DATABASE IF NOT EXISTS {db_name}")
# conn1.commit()
# conn1.close()

try:
    conn = pymysql.connect(host=rds_proxy_host, user=user_name, passwd=password, db=db_name, ssl={'ca': '/etc/ssl/cert.pem'}, connect_timeout=10)
except pymysql.MySQLError as e:
    print("Couldnot connect to rds")
    print(e)

try:
    with conn.cursor() as curr:
        curr.execute("CREATE TABLE IF NOT EXISTS users (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,username VARCHAR(45) NOT NULL UNIQUE,email VARCHAR(255) NOT NULL,password VARCHAR(255) NOT NULL, img VARCHAR(255));")
        curr.execute("CREATE TABLE IF NOT EXISTS posts (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,title VARCHAR(200) NOT NULL,description VARCHAR(1000) NOT NULL,img VARCHAR(255) NOT NULL,date DATETIME NOT NULL,cat VARCHAR(100) NOT NULL, uid INT NOT NULL,FOREIGN KEY (uid) REFERENCES users(id));")
        conn.commit()
except pymysql.MySQLError as e:
    print("couldn't create tables")

print("SUCCESS: Connection to RDS for MySQL instance succeeded")

def lambda_handler(event, context):
    print(event)

    try:
        http_method = event.get('httpMethod')
        path = event.get('path')

        if http_method == 'POST':
            response = save_post(json.loads(event['body']))
        elif http_method == 'GET':
            response = get_posts()
        elif http_method == 'DELETE':
            response = delete_post(post_id)

        return response

    except Exception as e:
        print('Error:', e)


def save_post(body):
    title = body['title']
    description = body['description']
    img = body['img']
    date = body['date']
    uid = body['uid']
    item_count = 0

    query = f"Insert INTO posts(title, description, img, date, uid) VALUES(%s,%s,%s,%s,%s)"

    with conn.cursor() as cur:
        cur.execute(query, (title, description, img, date, uid))
        cur.execute("select * from posts ORDER BY id DESC LIMIT 1")
        print("The following items have been added to the database:")
        for row in cur:
            item_count += 1
            print(row)
    conn.commit()

def get_posts():
    sql = "SELECT * FROM posts"
    with conn.cursor() as cur:
        cur.execute(sql)
        # Fetch all rows from the executed query
        rows = cur.fetchall()

        # Convert rows to JSON format
        json_data = json.dumps(rows, default=str)  # default=str to handle non-serializable types like datetime

    # Print or return the JSON data
    return {
            'statusCode': 200,
            'body': json_data,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        }
