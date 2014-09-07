set size square

set key left top

set yrange [0:10]
set xrange [0:10]

set xtics 1
set ytics 1

a=1.300003051757812500000000
xl=1.470997232173119147500000
xg=7.856928817901421426400000

set label 1 "小不動点解" point pt 2 at xl,xl left front
set label 2 "大不動点解" point pt 2 at xg,xg left front

plot log(x)/log(a) title "log", a**x title "power"
