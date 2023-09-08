#!/usr/bin/env python
import fileinput

def join_art(s1, s2, str_between=""):
     lines1 = s1.split('\n')
     lines2 = s2.split('\n')
     max_dist = max([len(s) for s in lines1])
     f_str = '{:<'+str(max_dist)+'}{}{}'
     s3 = "\n".join([f_str.format(str1,str_between,str2) for str1,str2 in zip(lines1,lines2)])
     return s3

if __name__ == "__main__":
    strs = []
    for l in fileinput.input(encoding="utf-8"):
        if fileinput.isfirstline():
            strs.append("")
        strs[-1] = strs[-1]+l
    print(join_art(strs[0], strs[1]))
