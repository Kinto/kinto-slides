SERVER_URL=${SERVER_URL-http://localhost:8888/v1}
USER=${USER-user}
PASSWORD=${PASSWORD-p4ssw0rd}

echo '{
  "data": {
      "last_modified": 1251800520143,
      "title": "Blog title",
      "description": "This is a blog description",
      "link": "http://www.example.com/main.html"
  }}' | http PUT "$SERVER_URL/buckets/default/collections/articles" --auth "$USER:$PASSWORD"

echo '{
  "data": {"id": "7bd204c6-1655-4c27-aeee-53f933c5395f","last_modified": 1251800520143,
       "title": "Blog title",
       "description": "This is a blog description",
       "link": "http://www.example.com/main.html"}}' | http POST "$SERVER_URL/buckets/default/collections/articles/records" --auth "$USER:$PASSWORD"
