import sys
import pymysql
import json
import os
import decimal
import boto3

# rds settings
def get_secret():
    secret_name = os.environ['SECRET']
    region_name = os.environ['REGION']

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

try:
    conn = pymysql.connect(host=rds_proxy_host, user=user_name, passwd=password, ssl={'ca': '/etc/ssl/cert.pem'}, connect_timeout=5)
except pymysql.MySQLError as e:
    print("ERROR: Unexpected error: Could not connect to MySQL instance.")
    print(e)
    sys.exit(1)

with conn.cursor() as cur:
    cur.execute("CREATE DATABASE IF NOT EXISTS books")
    conn.commit()
    conn.close()

try:
    conn = pymysql.connect(host=rds_proxy_host, user=user_name, passwd=password,db=db_name, ssl={'ca': '/etc/ssl/cert.pem'}, connect_timeout=5)
except pymysql.MySQLError as e:
    print("ERROR: Unexpected error: Could Not Create database.")
    print(e)
    sys.exit(1)

with conn.cursor() as cur:
        cur.execute("CREATE TABLE IF NOT EXISTS books(id INT AUTO_INCREMENT PRIMARY KEY,title VARCHAR(255) NOT NULL,`desc` TEXT,price DECIMAL(10, 2) NOT NULL,cover VARCHAR(255))")
conn.commit()

print("SUCCESS: Connection to RDS for MySQL instance succeeded")

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, decimal.Decimal):
            return str(obj)
        return super(DecimalEncoder, self).default(obj)


def build_response(status_code, body):
    return {
        'statusCode': status_code,
        'body': json.dumps(body, cls=DecimalEncoder),
        'headers': {
            'Content-Type': 'application/json',
            # 'Access-Control-Allow-Origin': 'https://lamabooks.development.sandbox.adex.ltd'
            'Access-Control-Allow-Origin': '*'
        }
    }


def lambda_handler(event, context):
    print(event)
    books_path = '/books'
    book_path = '/books/{id}'
    response = None

    try:
        http_method = event.get('httpMethod')
        path = event.get('path')
        resource = event.get('resource')

        if http_method == 'GET' and resource == book_path:
            book_id = event['pathParameters']['id']
            response = get_book(book_id)
        elif http_method == 'GET' and path == books_path:
            response = get_books()
        elif http_method == 'POST' and path == books_path:
            response = save_book(json.loads(event['body']))
        elif http_method == 'PUT' and resource == book_path:
            book_id = event['pathParameters']['id']
            body = json.loads(event['body'])
            response = modify_book(book_id, body)
        elif http_method == 'DELETE' and resource == book_path:
            book_id = event['pathParameters']['id']
            response = delete_book(book_id)
        else:
            response = build_response(404, '404 Not Found')

    except Exception as e:
        print('Error:', e)
        response = build_response(400, 'Error processing request')

    return response

def get_book(book_id):
    try:
        query = "SELECT * FROM books WHERE id = %s"
        with conn.cursor() as cur:
            cur.execute(query, (book_id,))
            result = cur.fetchone()
        if result:
            return build_response(200, result)
        else:
            return build_response(404, 'Book not found')
    except Exception as e:
        print('Error:', e)
        return build_response(400, str(e))

def get_books():
    try:
        query = "SELECT * FROM books"
        with conn.cursor() as cur:
            cur.execute(query)
            rows = cur.fetchall()
        return build_response(200, rows)
    except Exception as e:
        print('Error:', e)
        return build_response(400, str(e))


def save_book(body):
    title = body['title']
    desc = body['desc']
    price = body['price']
    cover = body['cover']
    item_count = 0

    query = f"Insert INTO books(title, `desc`, price, cover) VALUES(%s,%s,%s,%s)"

    with conn.cursor() as cur:
        cur.execute(query, (title, desc, price, cover))
        cur.execute("select * from books ORDER BY id DESC LIMIT 1")
        print("The following items have been added to the books table:")
        for row in cur:
            item_count += 1
            print(row)
    conn.commit()
    return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
    }
    }

def delete_book(book_id):
    query = "DELETE FROM books WHERE id = %s"
    try:
        with conn.cursor() as cur:
            cur.execute(query, (book_id,))
            conn.commit()
        return build_response(200, f"Book ID {book_id} deleted")
    except Exception as e:
        print('Error:', e)
        return build_response(400, str(e))

def modify_book(book_id, body):
    title = body['title']
    desc = body['desc']
    price = body['price']
    cover = body['cover']
    query = f"UPDATE books SET title = %s, `desc` = %s, price = %s, cover = %s  WHERE id = %s"
    try:
        with conn.cursor() as cur:
            cur.execute(query, (title, desc, price, cover, book_id))
            conn.commit()
        return build_response(200, f"Book ID {book_id} updated")
    except Exception as e:
        print('Error:', e)
        return build_response(400, str(e))
