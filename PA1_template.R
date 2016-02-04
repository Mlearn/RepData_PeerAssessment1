dat <- read.csv("activity.csv")

steps_day <- tapply(dat$steps,dat$date,sum,na.rm=TRUE)

hist(steps_day,length(steps_day))

mean(steps_day)

median(steps_day)

steps_interval <- tapply(dat$steps,dat$interval,mean,na.rm=TRUE)
plot(steps_interval, type = "l")

which.max(steps_interval)

sum(is.na(dat$steps))

loc <- is.na(dat$steps)
intval_loc <- dat$interval[loc]
dat_new <- dat
dat_new$steps[loc] <- steps_interval[as.character(intval_loc)]

steps_day_new <- tapply(dat_new$steps,dat_new$date,sum,na.rm=TRUE)
hist(steps_day_new, length(steps_day_new))

mean(steps_day_new)

median(steps_day_new)

library(timeDate)
wd <- dayOfWeek(as.timeDate(dat$date))
wdlev <- as.factor(c("weekday","weekend"))
dat_new <- data.frame(dat_new, week = wdlev[1])
dat_new$week[(wd=="Sat"|wd=="Sun")] <- wdlev[2]

library(dplyr)
a <- filter(dat_new, week=="weekday")
b <-filter(dat_new, week=="weekend")

aa <- tapply(a$steps,a$interval, mean, na.rm=TRUE)
bb <- tapply(b$steps,b$interval, mean, na.rm=TRUE)

aa <- data.frame(steps_interval=aa, week=wdlev[1], interval=as.numeric(rownames(aa)))
bb <- data.frame(steps_interval=bb, week=wdlev[2], interval=as.numeric(rownames(bb)))

steps_interval_week <- rbind(aa,bb)
library(lattice)
xyplot(steps ~ interval | week, data=steps_interval_week, xlab = "Interval", ylab = "Numbers of steps", type="l", layout = c(1,2))