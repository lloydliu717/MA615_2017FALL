# plot basic options

################################### 1 "type"
x = 1:10
y = 1:10
plot(x,y)
plot(x,y, type = 'o')
plot(x,y, type = 'l')
plot(x,y, type = 'b')
plot(x,y, type = 'c')
plot(x,y, type = 'h')
plot(x,y, type = 's')
?plot
#https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/plot.html
#"p" for points,
#"l" for lines,
#"b" for both,
#"c" for the lines part alone of "b",
#"o" for both ‘overplotted’,
#"h" for ‘histogram’ like (or ‘high-density’) vertical lines,
#"s" for stair steps,
#"S" for other steps, see ‘Details’ below,
#"n" for no plotting.

################################### 2 "lty"
plot(x,y, type = 'l', lty = 0)
plot(x,y, type = 'l', lty = 1)
plot(x,y, type = 'l', lty = 2)
plot(x,y, type = 'l', lty = 3)
plot(x,y, type = 'l', lty = 4)
plot(x,y, type = 'l', lty = 5)
plot(x,y, type = 'l', lty = 6)

################################### 3 "lwd"
plot(x,y, type = 'l', lty = 1, lwd = 2)
plot(x,y, type = 'l', lty = 1, lwd = 10)
plot(x,y, type = 'l', lty = 1, lwd = 200)

################################### 4 "pch"
dt <- read.table ("http://www.stat.columbia.edu/~gelman/arm/examples/pyth/exercise2.1.dat",
                  header=T, sep=" ")
x = dt$x2
y = dt$y
plot(x,y, type = 'p', pch = 1)
plot(x,y, type = 'p', pch = 2)
plot(x,y, type = 'p', pch = 11)
plot(x,y, type = 'p', pch = 16)
?points
#NA_integer_: no symbol.
#0:18: S-compatible vector symbols.
#19:25: further R vector symbols.
#26:31: unused (and ignored).
#32:127: ASCII characters.
#128:255 native characters only in a single-byte locale and for the symbol font. (128:159 are only used on Windows.)

################################### 5 "cex"
plot(x,y, type = 'p', pch = 16, cex = 1)
plot(x,y, type = 'p', pch = 16, cex = 2)
plot(x,y, type = 'p', pch = 16, cex = 3)
plot(x,y, type = 'p', pch = 11, cex = 10)

################################### 6 "text"
plot(x,y, type = 'p', pch = 16, cex = 1)
text(x[5],y[5],'string',cex = 5)

################################### 7 "col"
plot(x,y, type = 'p', pch = 16, col = 'purple')
plot(1:10,1:10, type = 'p', pch = 16, col = 'red')
plot(x,y, type = 'p', pch = 16, col = 'darkblue')

################################### 8 title and legend 
plot(x,y, type = 'p', pch = 16, 
     main = "A simple plot", xlab = 'this is x lab', ylab = 'this is y lab', cex.lab = 2)
abline(coef(lm(y~x))[1],coef(lm(y~x))[2], col = 'darkorange', lwd = 2)



