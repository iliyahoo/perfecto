#!/usr/bin/env python
import re

v_row = int(raw_input("Enter a row:    "))
v_column = int(raw_input("Enter a column:    "))

file = "simple.csv"
re_obj = re.compile(r'"(.*),(.*)"')

with open(file) as f:
    for num, row in enumerate(f):
        if num + 1 != v_row:
            continue
        # substitute a coma between double quotes and wipe them away
        # I need it to split a line with correct delimiter
        a = re.sub(re_obj, r'\1"\2', row).rstrip("\n")
        for num, col in enumerate(a.split(",")):
            if num + 1 == v_column:
                if '"' in col:
                    # revert modified field
                    print('"' + col.replace('"', ",") + '"')
                else:
                    print(col)
                break
