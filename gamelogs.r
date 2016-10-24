### scraping game logs from nba site
library(rjson)
sample_url = "http://stats.nba.com/stats/leaguegamelog?Counter=1000&Direction=DESC&LeagueID=00&PlayerOrTeam=P&Season=2015-16&SeasonType=Regular+Season&Sorter=PTS"

play_url = "http://stats.nba.com/stats/leaguegamelog?counter=10&LeagueID=00&PlayerOrTeam=P&Season=2015-16&SeasonType=Regular+Season"

template_url = "http://stats.nba.com/stats/leaguegamelog?Counter=1000&Direction=DESC&LeagueID=00&PlayerOrTeam=P&Season=20%02d-%02d&SeasonType=Regular+Season&Sorter=PTS"
#template_url = "http://stats.nba.com/stats/leaguegamelog?counter=10&LeagueID=00&PlayerOrTeam=P&Season=20%02d-%02d&SeasonType=Regular+Season"

urls = sapply(0:15,function(x) {print(x);sprintf(template_url,x,x+1)})

raw = lapply(urls,function(x) {print(x);fromJSON(file=x)})

tmp = lapply(raw,function(x) do.call(rbind,x$resultSets[[1]]$rowSet))

tmp1 = do.call(rbind,tmp)
nullToNA <- function(x) {
  x[sapply(x, is.null)] <- NA
  return(x)
}
tmp2 = nullToNA(tmp1)

gamelogs = as.data.frame(tmp2) %>% mutate_each(funs(unlist))
names(gamelogs) = raw[[1]]$resultSets[[1]]$headers

write.csv(gamelogs,"gamelogs.csv",quote = F,row.names = F)
