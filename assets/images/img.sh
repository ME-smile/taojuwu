find $1 -type f -name "*.png" | awk '{print "cp " $1 " ./ "}'
