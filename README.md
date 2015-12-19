# File Uploader

Use this docker container to provide a simple, generic way to upload files
from a local machine to some cloud storage area.  Most useful when combined
with volumes and another docker container that uses the uploaded files.

Protected with Basic Auth.

## Build Docker Image

   ( cd server; npm install )
   docker build -t uploader .

## Local Run Example

    docker run -d -p 80:80  \
        -v $(pwd)/test:/deploy/server/public
        -e 'SITE_TITLE=Video File Upload' \
        -e SITE_USER=admin -e SITE_PASSWORD=password \
        --name uploader uploader

## More Interesting Example

docker-compose.yml:

    data:
      container_name: data
      build: ./data/
      volumes:
        - /deploy/server/public
    
    uploader:
      container_name: uploader
      build: ./cloud-file-upload
      volumes_from:
        - data
      ports:
        - "80:80"
      environment:
        SITE_USER: admin
        SITE_PASSWORD: password
        SITE_TITLE: "Test Video Upload"
        SITE_DESCRIPTION: "Drag and drop video files from your desktop onto the page below to add files, then Start Upload." 
    
    ffserver:
      container_name: ffserver
      build: ./ffserver
      volumes_from:
        - data
      ports:
        - "554:554"
      environment:
        WATCH_DIR: /deploy/server/public/files
      links:
        - uploader
    
