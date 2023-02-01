match($0, /# (\S+\.(\[.+\]|\S+)+)/, g) { m=g[1]; l=$0 }
match($0, /^(.* )resource .*{$/, g) { if (l!~/has changed/ && l!~/will be read/) print g[1] m }
