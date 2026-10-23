#!/usr/bin/env python3
"""Serve index.html on a free loopback port, then open it in the default browser.

Why a server at all: browsers refuse notification permission on file:// pages.

Why the port is remembered: a browser keys localStorage (settings and records)
by origin, and the origin includes the port. Picking a fresh port each launch
would look like a brand-new install, so the first free port is stored and reused.

Usage: python3 serve.py [--no-open]
"""

import http.server
import os
import subprocess
import sys
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MARKER = b"window.pomodoro"


class Handler(http.server.BaseHTTPRequestHandler):
    """Serves index.html for / and 404 for everything else, so no other repo file is exposed."""

    server_version = "LiamPomodoro"
    sys_version = ""

    def do_GET(self):
        if self.path.split("?")[0] not in ("/", "/index.html"):
            self.send_error(404)
            return
        try:
            with open(os.path.join(ROOT, "index.html"), "rb") as handle:
                body = handle.read()
        except OSError:
            self.send_error(500)
            return
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):
        pass


def data_dir():
    if sys.platform == "darwin":
        base = os.path.expanduser("~/Library/Application Support")
    elif os.name == "nt":
        base = os.environ.get("LOCALAPPDATA") or os.path.expanduser("~")
    else:
        base = os.environ.get("XDG_DATA_HOME") or os.path.expanduser("~/.local/share")
    return os.path.join(base, "Liam Pomodoro Browser")


def url(port):
    return "http://127.0.0.1:{}/".format(port)


def is_ours(port):
    try:
        with urllib.request.urlopen(url(port), timeout=1) as response:
            return MARKER in response.read(65536)
    except Exception:
        return False


def remembered_port():
    try:
        with open(os.path.join(data_dir(), "port")) as handle:
            return int(handle.read().strip())
    except Exception:
        return None


def remember_port(port):
    try:
        os.makedirs(data_dir(), exist_ok=True)
        with open(os.path.join(data_dir(), "port"), "w") as handle:
            handle.write("{}\n".format(port))
    except OSError:
        pass


def open_browser(target):
    if sys.platform == "darwin":
        subprocess.Popen(["open", target])
    elif os.name == "nt":
        os.startfile(target)
    else:
        subprocess.Popen(["xdg-open", target])


def main():
    no_open = "--no-open" in sys.argv

    port = remembered_port()
    if port and is_ours(port):
        if not no_open:
            open_browser(url(port))
        print(url(port))
        return 0

    httpd = http.server.ThreadingHTTPServer(("127.0.0.1", 0), Handler)
    port = httpd.server_address[1]
    remember_port(port)
    print(url(port))
    sys.stdout.flush()
    if not no_open:
        open_browser(url(port))
    httpd.serve_forever()
    return 0


if __name__ == "__main__":
    sys.exit(main())
