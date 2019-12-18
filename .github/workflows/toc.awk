################################################
#
# awk script to generate the README.md file 
# for the PTC catalog
#
# Assumptions:
# 1. The first level 1 heading in the file is 
#    a short description of the PTC.
# 2. The "Target" level 2 heading will preceed
#    the description.
# 3. There is at least one other level 2 heading
#
# Author: Greg Watson (ORNL)
#
################################################

#
# Print the preamble for the catalog
#
BEGIN{
  print "# PTC Catalog"
  print
  print "The table below lists the currently available Progress Tracking Cards (PTCs) with brief descriptions of their goals."
  print
  print "Title|Goal(s)"
  print ":---|:---"
}

# Find the fist level 1 heading and print out the short description
# and the filename
$1 == "#" {
  printf "["
  for (i=2; i <= NF; i++) {
    if (i > 2) printf " ";
    printf "%s", $i
  }
  printf "][%s]|", FILENAME
}

# When we find the "Target" second level heading, change
# the record separator so that we start processing lines
# until a blank line is found
$1 == "##" && $2 == "Target" {RS=""; start=1; next}

# When we find any other second level heading, we've
# finished so go to the next file
$1 == "##" && $2 != "Target" {RS="\n"; start=0; nextfile}

# We've found the Target heading, so print any records
# we read until the next blank line, which is the description
start == 1 {printf "%s\n", $0}
