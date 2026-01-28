set xlabel 'μ^2' font ',18'
set ylabel 'ξ' font ',18' rotate by 0 offset -2,0
set title 'Correlation Length' font ',18'
set xtics font ',14'
set ytics font ',14'
set grid x,y
set lmargin 14
set bmargin 4
set key font ',14'
set key left
#set key box vertical width -1 height 1
#set logscale y
#set yrange [0.0:6]
set xrange [-3.25:0.25]
p 'L16/long.dat' u 1:2:3 w errorbars title 'L=16' lw 2, 'L32/long.dat' u 1:2:3 w errorbars title 'L=32' lw 2, 'L64/long.dat' u 1:2:3 w errorbars title 'L=64' lw 2, 'L128/long.dat' u 1:2:3 w errorbars title 'L=128' lw 2
pause -1
