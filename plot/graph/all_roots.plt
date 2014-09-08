#1/e^e < a < 1
single_root="../data/single_root.csv"
#1 < a
two_roots="../data/two_roots.csv"
#0 < a < 1/e^e
three_roots="../data/three_roots.csv"

set datafile separator ","

set yrange [0:10]
set xrange [0:1.6]

set key left top

e1e = 1.44466786101
e = 2.71828182846
_1ee = 0.06598803584
_1e = 0.36787944117

set arrow 1 from 0,e to e1e,e nohead lt 0
set arrow 2 from e1e,0 to e1e,e nohead lt 0

set label 1 "e" at -0.005,e right
set label 2 "e^(1/e)" at e1e,0.3 left

plot single_root using 1:2 notitle lt 1 w l, two_roots using 1:2 notitle lt 1 w l, two_roots using 1:3 title "大不動点解" lt 1 lc rgb "dark-green" w l, three_roots using 1:2 title "小共役解" lt 1 lc rgb "green" w l, three_roots using 1:4 title "大共役解" lt 1 lc rgb "blue" w l, three_roots using 1:3 title "小不動点解" lt 1 w l
