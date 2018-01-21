n_u <- 100
n_cu <- 4
ram <- "4g"
port <- 20000
port_h2o <- 30000
passwd <- "<insert password here>"

n_c <- parallel::detectCores()
stopifnot(n_c %% n_cu == 0)
for (i in 1:n_u) {
  cpu_start <- ((i-1)*n_cu) %% n_c
  cpus <- paste0(cpu_start,"-",cpu_start+(n_cu-1))
  cmd <- paste0("docker run -d -p ",port+i,":8787 -p ",port_h2o+i,":54321 -e ROOT=TRUE -e PASSWORD=",passwd," -m ",ram," --cpuset-cpus ",cpus," rgbm")
  print(cmd)
  system(cmd)
}

