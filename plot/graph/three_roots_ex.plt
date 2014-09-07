set size square

set key right top

set yrange [0:1.2]
set xrange [0:1.2]

a=0.030014038085937500000000
xl=0.056172981782145840730000
xf=0.322642002577845539820000
xg=0.821233719309331982450000

set label 1 "小共役解" point pt 2 at xl,xg left front
set label 2 "不動点解" point pt 2 at xf,xf left front
set label 3 "大共役解" point pt 2 at xg,xl left front

plot log(x)/log(a) title "log", a**x title "power"
