fake_data = rnorm(1e6) + c(rep(0, 290000),
    dnorm(seq(-10, 10, length.out=10000)) * 2, 
    rep(0, 290000), 
    dnorm(seq(-30, 30, length.out=10000)) * 10, 
    rep(0, 400000))

fake_data

png("test.png", width=11, height=4.25, units="in", res=300)
scatter.smooth(fake_data, span=0.01, degree=0, family="gaussian", 
               evaluation=6600, pch=".", col="#00000003")
dev.off()
