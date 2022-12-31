#!/usr/bin/env python3

import os
import argparse
import select
import sys
import signal

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
            "Sends SIGSTOP when no input appears in stdin for certain time. "
            "Sends SIGCONT immedieatly when the input appears again.")
    parser.add_argument('-t', '--timeout', type=float, default=300,
            help="Time in seconds")
    parser.add_argument('pids', metavar='<pid>', type=int, nargs="+", 
            help='PIDs of the processes to watch')
    args = parser.parse_args()


    state=0

    while True:
        inputready, outputready, exceptready = select.select([sys.stdin], [], [], args.timeout)

        good = False
        for x in inputready:
            if x == sys.stdin:
                read = sys.stdin.readline()[:-1] 
                print(read)

            good = True

        if not good:
            print("Timeout reached, stopping")
            state=0
            for pid in args.pids:
                os.kill(pid, signal.SIGSTOP)
        elif state==0:
            print("Resuming")
            state=1
            for pid in args.pids:
                os.kill(pid, signal.SIGCONT)


