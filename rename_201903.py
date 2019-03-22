#!/usr/bin/env python

"""
cleanup some PV names

see: https://github.com/APS-USAXS/AreaDetectorConfig/issues/1
also: https://github.com/APS-USAXS/ipython-usaxs/issues/145
"""

from collections import OrderedDict
import os

replacements = OrderedDict()
replacements["USAXS_Pin"] = "SAXS"
replacements["Pin_"] = "SAXS_"
replacements["USAXS_WAXS"] = "WAXS"
replacements["SAXS:waxs_"] = "SAXS:WAXS_"

TARGET_EXTENSION = ".xml"
NEWFILE_EXTENSION = ".new"


def make_changes(fname):
    fname_out = fname + NEWFILE_EXTENSION
    with open(fname, "r") as fin:
        buf = ""
        changes = False
        for line_count, text in enumerate(fin.readlines()):
            line_count += 1
            in_text = text
            for k, v in replacements.items():
                text = text.replace(k, v)
            buf += text
            if in_text != text:
                msg = "\n({},{}):".format(fname, line_count)
                msg += "\n{} {}".format("---", in_text.rstrip())
                msg += "\n{} {}".format("+++", text.rstrip())
                print(msg)
                changes = True

        if changes:
            with open(fname_out, "w") as fout:
                fout.write(buf)
                print("wrote:{}".format(fname_out))


def inspect_directory(path):
    path = os.path.abspath(path)
    
    # look at files in this directory first
    for entry in sorted(os.listdir(path)):
        full_name = os.path.join(path, entry)
        if os.path.isfile(full_name) and full_name.endswith(TARGET_EXTENSION):
            print("")
            print("reading:{}".format(full_name))
            make_changes(full_name)
    
    # look at subdirectories next
    for entry in sorted(os.listdir(path)):
        full_name = os.path.join(path, entry)
        if os.path.isdir(full_name):
            inspect_directory(full_name)


if __name__ == "__main__":
    # start here: /share1/AreaDetectorConfig
    inspect_directory(os.path.dirname(__file__))
