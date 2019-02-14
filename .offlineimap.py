#! /usr/bin/env python2
import re
import socket
from subprocess import check_output

def get_password(server, user):
    """Get password from pass."""
    servl = server.split('.')
    if re.match("imap", servl[0]) is not None:
        servl.pop(0)
    return check_output(
        ["pass", '/'.join((socket.gethostname(), '.'.join(servl), user))]
        ).splitlines()[0]
