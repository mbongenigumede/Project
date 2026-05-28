#!/bin/bash

yum update -y
yum install -y python3

cat <<APP > /home/ec2-user/app.py
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'Hello World from Terraform EC2!')

server = HTTPServer(('0.0.0.0', 8808), Handler)
server.serve_forever()
APP

nohup python3 /home/ec2-user/app.py > /home/ec2-user/app.log 2>&1 &