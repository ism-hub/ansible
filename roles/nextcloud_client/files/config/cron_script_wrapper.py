'''
Wrapper around nclient.sh,
The wrapper makes sure there is no currently running job -
    if there is one running exits
    else run the nclient.sh
'''
import sys
import logging
import fcntl
import errno
import subprocess
import os

logger = logging
logger.basicConfig(level=logging.DEBUG, stream=sys.stdout)

def main():
    logger.log(logger.INFO, "-------- Starting cron script --------")

    # Check that there is no currently running script
    f = open('nclient_flock', 'w')
    try: 
        fcntl.lockf(f, fcntl.LOCK_EX | fcntl.LOCK_NB) # EX - exclusive (only one can open), NB - None-Blocking (will return EAGAIN if lock is already taken)

    except IOError as e:
        if e.errno == errno.EAGAIN: # lock is exclusive and already taken
            logger.log(logger.INFO, f"---- Failed to get flock, means that the last job didn't finish yet, exiting.")
            sys.exit(-1)
        raise # some other failure

    # call the sh script
    # /nclient/config/nextcloudcmd_cronjob.sh
    # nextcloudcmd_cronjob.sh is created by ansible
    return subprocess.run("/nclient/config/nextcloudcmd_cronjob.sh", shell=True, universal_newlines=True, check=True) # will throw on fail

if __name__ == "__main__":
    main()
