set xlabel 'μ^2' font ',18' offset 0,-1
#set title 'Condensate' font ',18'
set xtics font ',14'
set ytics font ',14'
set grid x,y
set lmargin 14
set bmargin 5
set key font ',14'
set key bottom right
#set key box vertical width -1 height 1
#set logscale y
#set yrange [0:2.2]
#set xrange [-3.25:0.25]


set title "Action" font ',18'
set ylabel 'S/L' font ',20' rotate by 0 offset -2,0
p 'L16/action.dat' u 1:2:3 w errorbars title 'L=16' pt 1 lw 2, 'L32/action.dat' u 1:2:3 w errorbars title 'L=32' pt 1 lw 2, 'L64/action.dat' u 1:2:3 w errorbars title 'L=64' pt 1 lw 2, 'L128/action.dat' u 1:2:3 w errorbars title 'L=128' pt 1 lw 2,  'L256/action.dat' u 1:2:3 w errorbars title 'L=256' pt 1 lw 2 lc "red"

pause -1
